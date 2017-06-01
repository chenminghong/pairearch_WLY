//
//  RejectReasonListModel.h
//  pairearch_WLY
//
//  Created by Jean on 2017/6/1.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface RejectReasonListModel : BaseModel

@property (nonatomic, copy) NSString *reasonId;   //原因编号

@property (nonatomic, copy) NSString *name;       //原因

@end
