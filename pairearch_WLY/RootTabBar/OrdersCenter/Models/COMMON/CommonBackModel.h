//
//  CommonBackModel.h
//  pairearch_WLY
//
//  Created by Leo on 2017/3/14.
//  Copyright © 2017年 Leo. All rights reserved.
//

#import "BaseModel.h"

@interface CommonBackModel : BaseModel

/*
 {
 bsLdnLen = 0;
 bwWgt = "0.1";
 cdtyCd = "EB_PLT";
 createtime = "2017-02-28 20:27:28";
 crtdDtt = "2016-03-07 15:59:08";
 frmDlvyDtt = "2016-03-07 00:01:00";
 frmPkupDtt = "2016-03-07 00:00:00";
 frmShpgAddr = "\U4e0a\U6d77\U5e02";
 frmShpgAddrId = 9286;
 frmShpgLocCd = 000000000200217;
 frmShpgLocName = "\U6c38\U5bbd";
 id = 1187;
 ldLegId = 40087100;
 shpmNum = W000844259;
 toDlvyDtt = "2016-03-22 23:59:00";
 toDpndCmtdEndDtt = "2016-03-20 14:19:00";
 toDpndCmtdStrtDtt = "2016-03-20 14:00:00";
 toPkupDtt = "2016-03-22 23:58:00";
 toShpgAddr = "\U4e0a\U6d77\U5e02";
 toShpgAddrId = 249451;
 toShpgLocCd = 000000000200217;
 toShpgLocName = "\U6c38\U5bbd";
 totPce = 1;
 totSkid = 0;
 updatetime = "2017-02-28 20:27:28";
 updtDtt = "2016-03-22 10:33:22";
 }
 */

@property (nonatomic, copy) NSString *toShpgAddr;                //收货地址

@property (nonatomic, copy) NSString *ldLegId;                   //负载货单

@property (nonatomic, copy) NSString *trucType;                  //车辆类型

@property (nonatomic, copy) NSString *truckNum;                  //车牌号


@end
