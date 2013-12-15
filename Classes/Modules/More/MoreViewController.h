//
//  MoreViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-12-1.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：更多 列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "BaseViewController.h"
#import "ZS_Share.h"

@interface MoreViewController : BaseViewController<UITableViewDataSource,
    UITableViewDelegate,
    UIAlertViewDelegate,
    ZS_ShareDelegate>
{
    UIViewController * shareController;
}

@property(nonatomic, strong)NSArray *textArray;


@end
