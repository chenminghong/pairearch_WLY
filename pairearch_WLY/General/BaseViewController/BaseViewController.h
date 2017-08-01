//
//  BaseViewController.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/27.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NextStepBlock)(NSDictionary *paraDict);

@interface BaseViewController : UIViewController

@property (nonatomic, copy) NextStepBlock nextBlock;


@end
