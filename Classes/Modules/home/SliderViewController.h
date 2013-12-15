//
//  SliderViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-12-12.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：手册阅读属性设置页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "BaseViewController.h"
#import "ShowContentViewController.h"

@interface SliderViewController : BaseViewController
@property(nonatomic,strong)UISlider *Slide;
@property (nonatomic, strong) UIWebView   *webView;
@property (nonatomic) int flag;

-(id) init:(UIWebView *) webv;
@end
