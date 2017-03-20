//
//  OrdersCollectionCell.m
//  pairearch_WLY
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "OrdersCollectionCell.h"

#import "ListTableCell.h"
#import "OrderListModel.h"

@implementation OrdersCollectionCell

//加载cell
+ (instancetype)getCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath pushBlock:(PushActionBlock)pushBlock {
    OrdersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrdersCollectionCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.pushBlock = pushBlock;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.listTableView];
    [self addSubview:self.transpotBtn];
}

#pragma mark -- LazyLoding

- (UITableView *)listTableView {
    if (!_listTableView) {
        self.listTableView = [UITableView new];
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.listTableView];
        [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.bottom.and.right.mas_equalTo(self);
        }];
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.tableFooterView = [UIView new];
        [MJRefreshUtil pullDownRefresh:self andScrollView:self.listTableView andAction:@selector(loadDataFromNet)];
    }
    return _listTableView;
}

- (UIButton *)transpotBtn {
    if (!_transpotBtn) {
        self.transpotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.transpotBtn];
        [self.transpotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).with.offset(-20);
            make.size.mas_equalTo(CGSizeMake(90, 35));
        }];
        self.transpotBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        self.transpotBtn.backgroundColor = MAIN_THEME_COLOR;
        [self.transpotBtn setTitle:@"接收运单" forState:UIControlStateNormal];
        [self.transpotBtn addTarget:self action:@selector(pushButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transpotBtn;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (indexPath.item == 0) {
        self.type = @"unabsorbed";
    } else if (indexPath.item == 1) {
        self.type = @"distribution";
    } else {
        self.type = @"complete";
    }
    
    if (self.indexPath.item == 0) {
        if (self.listModelArr.count <= 0) {
            [self.transpotBtn setHidden:YES];
        } else {
            [self.transpotBtn setHidden:NO];
        }
    } else {
        [self.transpotBtn setHidden:YES];
    }
}

- (void)setListModelArr:(NSMutableArray *)listModelArr {
    _listModelArr = listModelArr;
}

//  请求网络数据
- (void)loadDataFromNet {
    NSString *driverTel = [[NSUserDefaults standardUserDefaults] objectForKey:USER_NUMBER];
    [self.listModelArr removeAllObjects];
    [OrderListModel getDataWithParameters:@{@"driverTel":driverTel? driverTel:@"", @"status":self.type? self.type:@""} endBlock:^(id model, NSError *error) {
        if (!error) {
            self.listModelArr = [NSMutableArray arrayWithArray:model];
            [self.reloadFlags replaceObjectAtIndex:self.indexPath.item withObject:@(0)];
        } else {
            [MBProgressHUD bwm_showTitle:error.userInfo[ERROR_MSG] toView:self.listTableView.superview hideAfter:HUD_HIDE_TIMEINTERVAL];
        }
        [self.listTableView reloadData];
        [MJRefreshUtil endRefresh:self.listTableView];
        //显示隐藏底部“接收运单按钮”
        if (self.indexPath.item == 0) {
            if (self.listModelArr.count <= 0) {
                [self.transpotBtn setHidden:YES];
            } else {
                [self.transpotBtn setHidden:NO];
            }
        } else {
            [self.transpotBtn setHidden:YES];
        }
    }];
}


#pragma marks -- TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListModel *orderModel = self.listModelArr[indexPath.row];
    
    CGFloat loadNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货地名称：%@", orderModel.SOURCE_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat loadAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"发货地址：%@", orderModel.SOURCE_ADDR] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat shipTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预约发货时间：%@", orderModel.PLAN_DELIVER_TIME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat getNameConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地名称：%@", orderModel.DC_NAME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat getAddressConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"收货地址：%@", orderModel.DC_ADDRESS] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat getTimeConstant = [BaseModel heightForTextString:[NSString stringWithFormat:@"预计到货时间：%@", orderModel.PLAN_ACHIEVE_TIME] width:(kScreenWidth - 95.0)  fontSize:CELL_LABEL_FONTSIZE];
    CGFloat height = 62.0+CELL_LABEL_HEIGHT*2+loadNameConstant+loadAddressConstant+shipTimeConstant+getNameConstant+getAddressConstant+getTimeConstant;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableCell *cell = [ListTableCell getCellWithTable:tableView fightSingleBlock:^{
        
    }];
    
    cell.indexPath = indexPath;
    cell.orderModel = self.listModelArr[indexPath.row];
    
    //处理选择框显示和隐藏
    if (self.indexPath.item != 0) {
        cell.selectedBtn.hidden = YES;
    } else {
        cell.selectedBtn.hidden = NO;
    }
    
    //设置cell状态
    if ([cell.orderModel.TRANSPORT_CODE isEqualToString:ORDER_TYPE_KA]) {
        cell.assortLabel.text = @"KA";
        if (self.indexPath.item == 2) {
            cell.assortLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            cell.stateLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            cell.kaLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            [cell.telephoneBtn setBackgroundImage:[UIImage imageNamed:@"telephone-del"] forState:UIControlStateNormal];
        } else {
            cell.assortLabel.backgroundColor = THEME_COLOR_KA;
            cell.stateLabel.backgroundColor = THEME_COLOR_KA;
            cell.kaLabel.backgroundColor = THEME_COLOR_KA;
            [cell.telephoneBtn setBackgroundImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
        }
    } else if ([cell.orderModel.TRANSPORT_CODE isEqualToString:ORDER_TYPE_BACK]) {
        cell.assortLabel.text = @"回";
        if (self.indexPath.item == 2) {
            cell.assortLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            cell.stateLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            cell.kaLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            [cell.telephoneBtn setBackgroundImage:[UIImage imageNamed:@"telephone-del"] forState:UIControlStateNormal];
        } else {
            cell.assortLabel.backgroundColor = THEME_COLOR_BACK;
            cell.stateLabel.backgroundColor = THEME_COLOR_BACK;
            cell.kaLabel.backgroundColor = THEME_COLOR_BACK;
            [cell.telephoneBtn setBackgroundImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
        }
    } else if ([cell.orderModel.TRANSPORT_CODE isEqualToString:ORDER_TYPE_COMMON]) {
        cell.assortLabel.text = @"常";
        if (self.indexPath.item == 2) {
            cell.assortLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            cell.stateLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            cell.kaLabel.backgroundColor = ABNORMAL_THEME_COLOR;
            [cell.telephoneBtn setBackgroundImage:[UIImage imageNamed:@"telephone-del"] forState:UIControlStateNormal];
        } else {
            cell.assortLabel.backgroundColor = THEME_COLOR_COMMON;
            cell.stateLabel.backgroundColor = THEME_COLOR_COMMON;
            cell.kaLabel.backgroundColor = THEME_COLOR_COMMON;
            [cell.telephoneBtn setBackgroundImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.indexPath.item == 0) {
        OrderListModel *model = self.listModelArr[indexPath.row];
        model.isSelected = !model.isSelected;
        [self.listTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (self.indexPath.item == 1) {
        if (self.pushBlock) {
            OrderListModel *model = self.listModelArr[indexPath.row];
            NSMutableArray *modelArr = [NSMutableArray arrayWithObject:model];
            self.pushBlock(modelArr, self.indexPath);
        }
    }
}


#pragma mark -- ButtonAction

//拼单按钮点击事件
- (void)pushButtonAction:(UIButton *)sender {
    if (self.pushBlock) {
        NSMutableArray *modelArr = [NSMutableArray array];
        for (OrderListModel *model in self.listModelArr) {
            if (model.isSelected) {
                [modelArr addObject:model];
            }
        }
        self.pushBlock(modelArr, self.indexPath);
    }
}

@end
