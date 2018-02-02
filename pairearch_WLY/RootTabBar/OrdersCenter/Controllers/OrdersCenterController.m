//
//  OrdersCenterController.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/15.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersCenterController.h"

#import "OrdersCollectionCell.h"
#import "OrderListModel.h"
#import "NestedSelectStateController.h"
#import "OrderStatusKA245Controller.h"
#import "BACKNestedSelectController.h"

#import "OrderStatusCOMMON212Controller.h"
#import "OrderStatusCOMMON220Controller.h"
#import "OrderStatusCOMMON226Controller.h"
#import "OrderStatusCOMMON228Controller.h"
#import "CommonSelectStateController.h"
#import "AbnormalReportController.h"


@interface OrdersCenterController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (nonatomic, strong) UIButton *selectedBtn;  //已经选中的Button

@property (nonatomic, strong) UIView *markView; //按钮标记view

//@property (nonatomic, strong) NSMutableArray *reloadFlags;  //table刷新标识

@property (nonatomic, strong) OrdersCollectionCell *currentCell;  //当前显示的cell

@end

@implementation OrdersCenterController

#pragma mark -- LazyLoding

- (UIView *)markView {
    if (!_markView) {
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 6.0 - 30.0, CGRectGetMaxY(self.selectView.bounds) - 2, 60.0, 2)];
        self.markView.backgroundColor = MAIN_THEME_COLOR;
    }
    return _markView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xCBC9C7);
    
    self.collectionView.pagingEnabled = YES;
    [self.selectView addSubview:self.markView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = (UIButton *)[self.selectView viewWithTag:(100 + i)];
        [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:MAIN_THEME_COLOR forState:UIControlStateSelected];
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
        } else {
            btn.selected = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.collectionView reloadData];
}


#pragma mark -- ButtonActions
- (IBAction)selectButtonAction:(UIButton *)sender {
    if (self.selectedBtn != sender) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(sender.tag - 100) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    [self resetMarkViewPositionWithIndex:sender.tag - 100];
}

#pragma mark -- CommoMethods

- (void)resetMarkViewPositionWithIndex:(NSInteger)index {
    [UIView animateWithDuration:0.2 animations:^{
        self.markView.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.selectView.bounds) * index / 3, 0.0);
    }];
}

//KA界面跳转逻辑
- (void)jumpToKaControllerWithStatus:(NSInteger)status paraDict:(NSDictionary *)paraDict {
    NestedSelectStateController *nestedVC = [NestedSelectStateController new];
    [self.navigationController pushViewController:nestedVC animated:YES];
    nestedVC.paraDict = [NSMutableDictionary dictionaryWithDictionary:paraDict];
}

//BACK界面跳转逻辑
- (void)jumpToBackControllerWithStatus:(NSInteger)status paraDict:(NSDictionary *)paraDict{
    BACKNestedSelectController *backVC = [BACKNestedSelectController new];
    backVC.paraDict = [NSMutableDictionary dictionaryWithDictionary:paraDict];
    [self.navigationController pushViewController:backVC animated:YES];
}

//COMMON界面跳转逻辑
- (void)jumpToCommonControllerWithStatus:(NSInteger)status paraDict:(NSDictionary *)paraDict{
    CommonSelectStateController *nestedVC = [CommonSelectStateController new];
    [self.navigationController pushViewController:nestedVC animated:YES];
    nestedVC.paraDict = [NSMutableDictionary dictionaryWithDictionary:paraDict];
}


#pragma mark -- DelegateMethods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 47);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrdersCollectionCell *cell = [OrdersCollectionCell getCellWithCollectionView:collectionView indexPath:indexPath pushBlock:^(NSArray *selectModelArr, NSIndexPath *indexPath) {
        if (selectModelArr.count == 0) {
            [MBProgressHUD bwm_showTitle:@"请选择要接收的运单！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        if (selectModelArr.count > 1) {
            for (OrderListModel *model in selectModelArr) {
                if (![model.TRANSPORT_CODE isEqualToString:ORDER_TYPE_KA]) {
                    [MBProgressHUD bwm_showTitle:@"只有KA可以拼单！" toView:self.view hideAfter:HUD_HIDE_TIMEINTERVAL];
                    return;
                }
            }
        }
        if (selectModelArr.count >= 1) {
            NSString *codeStr = @"";
            for (NSInteger i = 0; i < selectModelArr.count; i++) {
                OrderListModel *model = selectModelArr[i];
                if (i == 0) {
                    codeStr = [codeStr stringByAppendingFormat:@"%@", model.CODE];
                } else {
                    codeStr = [codeStr stringByAppendingFormat:@",%@", model.CODE];
                }
            }
            
            OrderListModel *listModel = selectModelArr[0];
            NSInteger status = [listModel.STATUS integerValue];
            NSString *transportCode = listModel.TRANSPORT_CODE;
            NSDictionary *paraDict = @{@"driverTel":[LoginModel shareLoginModel].tel, @"orderCode":codeStr, @"userName":[LoginModel shareLoginModel].name, @"totalWeight":listModel.TOTAL_WEIGHT};
            if (indexPath.item != 2) {
                if ([transportCode isEqualToString:ORDER_TYPE_KA]) {
                    [self jumpToKaControllerWithStatus:status paraDict:paraDict];
                } else if ([transportCode isEqualToString:ORDER_TYPE_BACK]) {
                    [self jumpToBackControllerWithStatus:status paraDict:paraDict];
                } else if ([transportCode isEqualToString:ORDER_TYPE_COMMON]) {
                    [self jumpToCommonControllerWithStatus:status paraDict:paraDict];
                }
            }
        }
    }];
    [cell addAbnormalReportBlock:^(NSString *loadNumber) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AbnormalReportController" bundle:[NSBundle mainBundle]];
        AbnormalReportController *abnormalVC = [sb instantiateViewControllerWithIdentifier:@"AbnormalReportController"];
        abnormalVC.loadNumber = loadNumber;
        [self.navigationController pushViewController:abnormalVC animated:YES];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) {
    
    OrdersCollectionCell *tempCell = (OrdersCollectionCell *)cell;
    [MJRefreshUtil begainRefresh:tempCell.listTableView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        [self resetMarkViewPositionWithIndex:index];
        UIButton *btn = (UIButton *)[self.selectView viewWithTag:(100 + index)];
        if (index + 100 == btn.tag) {
            [self selectButtonAction:btn];
        }
    }
}


- (void)dealloc {
    //移除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
