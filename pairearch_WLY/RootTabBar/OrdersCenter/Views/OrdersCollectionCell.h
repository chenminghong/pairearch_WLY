//
//  OrdersCollectionCell.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ListTableCell.h"

typedef void(^PushActionBlock)(NSArray *selectModelArr, NSIndexPath *indexPath);

typedef void(^AbnormalReportBlock)(NSString *loadNumber);


@interface OrdersCollectionCell : UICollectionViewCell<UITableViewDelegate, UITableViewDataSource, AbnormalReportDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UIButton *transpotBtn; //拼单按钮（查看详情按钮）

@property (nonatomic, strong) NSIndexPath *indexPath;  //当前table位置

@property (nonatomic, copy) NSString *type;  //当前显示的cell的订单状态

@property (nonatomic, copy) PushActionBlock pushBlock; //选中行的回调

@property (nonatomic, strong) NSMutableArray *listModelArr;

//@property (nonatomic, strong) NSMutableArray *reloadFlags;  //存储刷新标识(1:需要刷新, 0:不需要刷新)

@property (nonatomic, strong) AbnormalReportBlock abnormalReportBlock;


//加载cell
+ (instancetype)getCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath pushBlock:(PushActionBlock)pushBlock;

//  请求网络数据
- (void)loadDataFromNet;


/**
 异常上报按钮点击事件

 @param block 异常上报按钮点击事件回调
 */
- (void)addAbnormalReportBlock:(AbnormalReportBlock)block;

@end
