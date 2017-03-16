//
//  StartTransportFooterView.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/28.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartTransportFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *startTransportBtn;

//初始化
+ (StartTransportFooterView *)getFooterView;

@end
