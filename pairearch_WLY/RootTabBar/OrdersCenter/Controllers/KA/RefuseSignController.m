//
//  RefuseSignController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/3/6.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "RefuseSignController.h"

#import "CommonPickerView.h"
#import "RejectReasonListModel.h"
#import "BidPickerView.h"
#import "RejectSignCell.h"

#import "AbnormalReportCell.h"
#import "LxGridViewFlowLayout.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "OrderStatusKA245Controller.h"


#define MAX_IMAGE_COUNT  3   //最大可以选择的照片张数

@interface RefuseSignController ()<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) NSArray *reasonListArr;  //存储异常原因列表

@end

@implementation RefuseSignController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setLxCode:(NSInteger)lxCode {
    _lxCode = lxCode;
    
    //获取异常列表数据
    [self getReasonList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //设置提交按钮
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [commitButton setTitleColor:MAIN_THEME_COLOR forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    commitButton.frame = CGRectMake(kScreenWidth - 100, 0, 50, 44);
    UIBarButtonItem *commitItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    self.navigationItem.rightBarButtonItem = commitItem;
    

    
    if (self.lxCode == ABNORMAL_CODE_261) {
        self.title = @"破损/拒收/退货上报";
    } else if (self.lxCode == ABNORMAL_CODE_262) {
        self.title = @"破损/拒收/退货上报";
    } else {
        self.title = @"预警原因";
    }
}

+ (RefuseSignController *)pushToRefuseSignWithController:(UIViewController *)controller signResultBlock:(RefuseSignBlock)signResultBlock {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RefuseSignController" bundle:[NSBundle mainBundle]];
    RefuseSignController *refuseVC = [sb instantiateViewControllerWithIdentifier:@"RefuseSignController"];
    [controller.navigationController pushViewController:refuseVC animated:YES];
    refuseVC.signResultBlock = signResultBlock;
    return refuseVC;
}


//获取异常原因列表数据
- (void)getReasonList {
    [RejectReasonListModel getDataWithParameters:@{@"type":@(self.lxCode)} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.reasonListArr = [NSArray arrayWithArray:model];
        }
        [self.tableView reloadData];
    }];
}

//提交按钮事件
- (void)commitButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    RejectSignCell *cell = (RejectSignCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RejectReasonListModel *model = cell.selectModel;
    
    if ([model.name isEqualToString:@"其他"] && cell.reasonTV.text.length <= 0) {
        [MBProgressHUD bwm_showTitle:@"请输入其他原因" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        return;
    }
    
    switch (self.lxCode) {
        case ABNORMAL_CODE_261:
        case ABNORMAL_CODE_262:
        {
            NSString *orderCode = [NSString stringWithFormat:@"%@", self.paraDict[@"orderCode"]];
            NSString *orderNum = [NSString stringWithFormat:@"%@", self.paraDict[@"shpmNum"]];
            NSDictionary *paraDict = @{@"orderCode":orderCode,
                                       @"orderNum":orderNum,
                                       @"driverName":[LoginModel shareLoginModel].name,
                                       @"driverTel":[LoginModel shareLoginModel].tel,
                                       @"remark":cell.reasonTV.text,
                                       @"productCode":@"",
                                       @"productName":@"",
                                       @"abnormalNum":@"",
                                       @"status":@(self.lxCode),
                                       @"dictCode":model.reasonId.length? model.reasonId:@"",
                                       @"dictName":model.name.length? model.name:@""};
            NSLog(@"paraDict:%@", paraDict);
            __weak typeof(self) weakself = self;
            [NetworkHelper POST:ORDER_REJECT_GET_API parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSInteger i = 0; i < _selectedPhotos.count; i++) {
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(_selectedPhotos[i], 0.5) name:@"file" fileName:[NSString stringWithFormat:@"abnormal_upload%ld.jpg", (long)i] mimeType:@"image/jpeg"];
                }
            } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *msg = responseObject[@"msg"];
                __block NSInteger resultFlag = [responseObject[@"status"] integerValue];
                MBProgressHUD *hud = [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
                if (resultFlag == 1) {
                    [hud setCompletionBlock:^(){
                        if (weakself.lxCode == ABNORMAL_CODE_262 || weakself.lxCode == ABNORMAL_CODE_261) {
                            if (weakself.signResultBlock) {
                                NSDictionary *flagDict = weakself.signResultBlock(@{@"flag":@(resultFlag)});
                                if (flagDict) {
                                    NSString *pushFlag = [flagDict objectForKey:@"toEvaluationPageFlag"];
                                    if (pushFlag.length > 0 && [pushFlag boolValue]) {
                                        OrderStatusKA245Controller *evaluationVC = [OrderStatusKA245Controller new];
                                        evaluationVC.paraDict = flagDict;
                                        [self.navigationController pushViewController:evaluationVC animated:YES];
                                    } else {
                                        [weakself.navigationController popViewControllerAnimated:YES];
                                    }
                                }
                            }
                        } else {
                            [weakself.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }];
                }
            } failure:^(NSError *error) {
                [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            }];
        }
            break;
            
        case ABNORMAL_CODE_263:
        {
            NSString *modelId = [NSString stringWithFormat:@"%@", self.paraDict[@"id"]];
            NSDictionary *paraDict = @{@"id":modelId,
                                       @"dictCode":model.reasonId.length? model.reasonId:@"",
                                       @"dictName":model.name.length? model.name:@"",
                                       @"remark":cell.reasonTV.text};
            NSLog(@"paraDict:%@", paraDict);
            __weak typeof(self) weakself = self;
            [NetworkHelper POST:WARNING_UPDATE_API parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSInteger i = 0; i < _selectedPhotos.count; i++) {
                    NSData *data = UIImageJPEGRepresentation(_selectedPhotos[i], 0.5);
                    [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"abnormal_upload%ld.jpg", (long)i] mimeType:@"image/jpeg"];
                }
            } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *msg = responseObject[@"msg"];
                __block NSInteger resultFlag = [responseObject[@"status"] integerValue];
                MBProgressHUD *hud = [ProgressHUD bwm_showTitle:msg toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
                if (resultFlag == 1) {
                    [hud setCompletionBlock:^(){
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }];
                }
            } failure:^(NSError *error) {
                [ProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
        _margin = 4;
        _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 235, self.view.tz_width, self.view.tz_height - 235) collectionViewLayout:layout];
        CGFloat rgb = 244 / 255.0;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    }
    return _collectionView;
}

- (UIImagePickerController *)imagePickerVc {
    if (!_imagePickerVc) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


#pragma mark -- ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

#pragma mark -- TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight - 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RejectSignCell *cell = [RejectSignCell getCellWithTable:tableView];
    [cell.contentView addSubview:self.collectionView];
    cell.dataListArr = self.reasonListArr;
    return cell;
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}


#pragma mark -- CollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count < MAX_IMAGE_COUNT? _selectedPhotos.count + 1:_selectedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        [cell.deleteBtn setImage:[UIImage imageNamed:@"delete_img"] forState:UIControlStateNormal];
        cell.deleteBtn.hidden = NO;
    }
    cell.gifLable.hidden = YES;
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView endEditing:YES];
    if (indexPath.row == _selectedPhotos.count) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        //拍照
        UIAlertAction *paozhaoAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            NSLog(@"拍照");
            [self takePhoto];
        }];
        
        //选择相册
        UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"去相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            NSLog(@"相册");
            [self pushImagePickerController];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }];
        
        [alertController addAction:paozhaoAction];
        [alertController addAction:selectAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isImage = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isImage = phAsset.mediaType == PHAssetMediaTypeImage;
        }
        if (isImage) {// preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 1;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.allowPickingOriginalPhoto = NO;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerController
//拍照
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        // 拍照之前还需要检查相册权限
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            [MBProgressHUD bwm_showTitle:@"相机功能无法使用或没有相机！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
            NSLog(@"模拟器中无法打开照相机，请在真机中使用");
        }
    }
}


/**
 拍照结束回调
 
 @param picker imagepickerVC对象
 @param info 拍照获取的资源
 */
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE_COUNT delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}


/**
 刷新上传图片列表
 
 @param asset 新拍照的照片资源
 @param image 拍照获取的图片
 */
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    
    if (_selectedPhotos.count < MAX_IMAGE_COUNT) {
        [_selectedAssets addObject:asset];
        [_selectedPhotos addObject:image];
        [_collectionView reloadData];
    } else {
        [MBProgressHUD bwm_showTitle:[NSString stringWithFormat:@"最多只能上传%d张照片！", MAX_IMAGE_COUNT] toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
    }
}


//弹出选择相册
- (void)pushImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:MAX_IMAGE_COUNT columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    [imagePickerVc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:18.0]}];
    imagePickerVc.navigationBar.barTintColor = TOP_BOTTOMBAR_COLOR;
    imagePickerVc.navigationBar.tintColor = UIColorFromRGB(0x666666);
    imagePickerVc.barItemTextFont = [UIFont systemFontOfSize:16.0];
    imagePickerVc.barItemTextColor = UIColorFromRGB(0x666666);
    imagePickerVc.navigationBar.barTintColor = TOP_BOTTOMBAR_COLOR;
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.alwaysEnableDoneBtn = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.isSelectOriginalPhoto = NO;  //返回原图图
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

//删除按钮点击事件
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    if (_selectedPhotos.count >= MAX_IMAGE_COUNT - 1) {
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            indexPath = [NSIndexPath indexPathForItem:_selectedPhotos.count inSection:0];
            [_collectionView insertItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    } else {
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
