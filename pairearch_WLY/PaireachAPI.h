//
//  PaireachAPI.h
//  pairearch_WLY
//
//  Created by Leo on 2017/2/22.
//  Copyright © 2017年 Leo. All rights reserved.
//

#ifndef PaireachAPI_h
#define PaireachAPI_h

#pragma markk -- APP接口定义

/*============================BaseUrl相关=============================*/
//API前缀定义
//#define PAIREACH_BASE_URL                @"http://192.168.0.158:8086/itip/client/"    //Leo
//#define PAIREACH_BASE_URL                @"http://192.168.0.116:8086/itip/client/"    //Bob
//#define PAIREACH_BASE_URL                @"http://192.168.0.124:8086/itip/client/"
//#define PAIREACH_BASE_URL                @"http://192.168.0.116:8086/itip/client/"

#define PAIREACH_BASE_URL                @"http://106.14.39.65:8285/itip/client/"     //测试线上
//#define PAIREACH_BASE_URL                @"http://192.168.1.14:8086/itip/client/"     //备用
//#define PAIREACH_BASE_URL                @"http://dt.paireach.com/itip/client/"       //双至域名
//#define PAIREACH_BASE_URL                @"http://139.219.188.45/itip/client/"        //双至IP



/*============================首页相关=============================*/

//首页数据显示
#define HOME_PAGE_DATA_API                @"homePageDisplay.a"              //get

//安全选项检查
#define SAFETY_CONFIRMATION_API           @"safeVeriSave.a"                 //post

//安全检查
#define DAFETY_CHECK_API                  @"isSafeChecked.a"                //get



/*============================运单中心用户相关=============================*/

//订单中心
#define ORDER_LIST_API                    @"loadAllOrder.a"                 //get

//订单详情
#define ORDER_DETAIL_API                  @"loadDetailByTelAndCode.a"       //get

//开始运输
#define ORDER_GETLOAD_API                 @"driverAcceptOrder.a"            //post

//签到确认
#define ORDER_CHECK_API                   @"orderHandling.a"                //post

//入厂确认
#define ORDER_ENTER_FAC_API               @"loadingPlant.a"                 //post

//出厂确认
#define ORDER_OUT_FAC_API                 @"exFactory.a"                    //post

//收货签到确认
#define ORDER_GETFAC_CHECK_API            ORDER_CHECK_API                   //post

//进入收货工厂
#define ORDER_ENTER_GETFAC_API            @"receivingPlant.a"               //post

//出收货工厂(正常签收)
#define ORDER_OUT_GETFAC_API              @"receivingDelivery.a"            //post

//拒绝签收
#define ORDER_REJECT_GET_API              @"bwRejectSign.a"                 //post

//KA异常签收
#define KA_ABNORMAL_SIGN_API              @"rejectSign.a"                   //post

//回空界面详情
#define PRDER_BACK_CHECK_API              @"emptyOrderDetail.a"             //post

//确认回空
#define ORDER_SURE_BACK_API               @"emptySingleScheduling.a"        //post

//取消回空
#define ORDER_CANCEL_BACK_API             @"emptyCancel.a"                  //post

//负载单评价
#define ORDER_EVALUATION_API              @"submissionEvaluation.a"         //post

//订单退回
#define ORDER_RETURN_API                  @"orderReturn.a"                  //post

//异常原因列表
#define REJECT_REASON_LIST_API            @"rejectReason.a"                 //post

//触发地理围栏报警
#define FENCE_MESSAGE_WARNING             @"saveFenceAlarmInfo.a"           //post


/*============================预警相关=============================*/

//预警列表
#define WARNING_LIST_API                  @"abnormalList.a"                 //get

//预警提交
#define WARNING_UPDATE_API                @"updateAbnormalSign.a"           //post


/*============================个人中心用户相关=============================*/

//用户登录
#define USER_LOGIN_API                    @"loginForDriver.a"               //post

//修改密码
#define CHANGE_PASSWORD_API               @"changeDriverPwd.a"              //post

//异常反馈
#define ABNORMAL_UPLOAD_API               @"uploadAbnormalPresentationInfo.a"  //post






/*============================通知中心相关=============================*/

#pragma mark -- 通知中心

//订单中心刷新通知
#define ORDERSCENTER_RELOAD_NAME            @"order_center_reloaddata"


//异常签收类型编码
#define ABNORMAL_CODE_261           261   //拒绝签收
#define ABNORMAL_CODE_262           262   //异常签收
#define ABNORMAL_CODE_263           263   //异常停留



#endif /* PaireachAPI_h */
