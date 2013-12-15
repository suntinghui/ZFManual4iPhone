//
//  PayViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-11-26.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：付款页面  提供支付宝和银联两种方式付款
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "BaseViewController.h"
#import "AlixLibService.h"
#import "UPPayPluginDelegate.h"

@interface PayViewController : BaseViewController<UPPayPluginDelegate>

{
    SEL _result;
    NSString* mData;
}

@property (nonatomic)BOOL isYl;//是否为银联
@property (nonatomic)BOOL isZf;//是否为支付宝
@property (nonatomic,strong) UIButton *zfbutton;
@property (nonatomic,strong) UIButton *ylbutton;

@property (nonatomic,assign) float price;
@property (nonatomic,strong) NSString *bookname;
@property (nonatomic,strong) NSString *bookId;
@property (nonatomic) BOOL sure;

-(id) initWithNamePrice:(NSString *) bookName pprice:(float) price bookId:(NSString *)bookId shouldSure:(BOOL) sure;
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
-(void)paymentResult:(NSString *)result;


@end
