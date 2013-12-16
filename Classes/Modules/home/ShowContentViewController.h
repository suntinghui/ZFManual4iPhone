//
//  ShowFileContentViewController.h
//  LKOA4iPhone
//
//  Created by  STH on 7/31/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：手册内容阅读页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZS_Share.h"
#import "SliderViewController.h"

@interface ShowContentViewController : BaseViewController <UIWebViewDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate,ZS_ShareDelegate,UISearchBarDelegate>

{
    UIViewController * shareController;
}

@property (nonatomic, strong) UIWebView   *webView;
@property (nonatomic, strong) UIActivityIndicatorView *progressInd;

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *htmlStr;

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic,retain) UISearchBar *mySearchBar;

@property (nonatomic, strong) UIBarButtonItem *fontButtonItem;
@property (nonatomic, strong) UIBarButtonItem *lightButtonItem;
@property (nonatomic, strong) UIBarButtonItem *collectButtonItem;
@property (nonatomic, strong) UIBarButtonItem *searchButtonItem;
@property (nonatomic, strong) UIBarButtonItem *shareButtonItem;

@property (nonatomic, strong) UIPopoverController *fontPopoverController;
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;

@property (nonatomic, strong) UISlider* lightSlide;
@property (nonatomic, strong) UISlider* fontSlide;

@property (nonatomic,strong) UIButton *fontButton;
@property (nonatomic,strong) UIButton *lightButton;

-(id) initWithFileName:(NSString *) fileName;
-(id) initWithUrl:(NSString *) url;
-(id) initWithHtmlString:(NSString *) htmlStr;


-(void)lightAction:(id)sender;

@end
