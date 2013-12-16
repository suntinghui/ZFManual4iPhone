//
//  ShowFileContentViewController.m
//  LKOA4iPhone
//
//  Created by  STH on 7/31/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "ShowContentViewController.h"
#import "ContentModel.h"
#import "CollectDBHelper.h"
#import "SliderViewController.h"
#import "FPPopoverController.h"
#import "SearchWebView.h"

@interface ShowContentViewController ()

@end

@implementation ShowContentViewController

@synthesize webView = _webView;
@synthesize progressInd = _progressInd;
@synthesize fileName = _fileName;
@synthesize link = _link;
@synthesize htmlStr = _htmlStr;
@synthesize toolBar = _toolBar;

@synthesize fontButtonItem = _fontButtonItem;
@synthesize lightButtonItem = _lightButtonItem;
@synthesize collectButtonItem = _collectButtonItem;
@synthesize searchButtonItem = _searchButtonItem;
@synthesize shareButtonItem = _shareButtonItem;
@synthesize fontSlide = _fontSlide;
@synthesize lightSlide = _lightSlide;

@synthesize fontPopoverController = _fontPopoverController;

@synthesize recognizer = _recognizer;
@synthesize mySearchBar = _mySearchBar;

@synthesize fontButton = _fontButton;
@synthesize lightButton = _lightButton;

static bool hasTapped = false;

-(id) initWithFileName:(NSString *) fileName
{
    if (self = [super init]) {
        _fileName = fileName;
        _link = nil;
        _htmlStr = nil;
    }
    
    return self;
}

-(id) initWithUrl:(NSString *) url
{
    if (self = [super init]) {
        _link = url;
        _fileName = nil;
        _htmlStr = nil;
    }
    
    return self;
}

-(id) initWithHtmlString:(NSString *) htmlStr
{
    if (self = [super init]) {
        _htmlStr = htmlStr;
        _link = nil;
        _fileName = nil;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"big_bg"]]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    float height = 397.0f;
    if (IS_IOS_7 && IS_IPHONE_5){
        height = 504.0f;
    } else if (IS_IOS_7 && !IS_IPHONE_5){
        height = 417.0f;
    } else if(!IS_IOS_7 && IS_IPHONE_5){
        height = 484.0f;
    }
    
    self.view.frame = CGRectMake(0, 0, 320, height);

    // webview
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-44-44-20)];
    [self.webView setUserInteractionEnabled:YES];
    // YES, 初始太小，但是可以放大；NO，初始可以，但是不再支持手势。 FUCK！！！
    _webView.scalesPageToFit = YES; // 设置网页和屏幕一样大小，使支持缩放操作
    [_webView setDelegate:self];
    
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.recognizer setNumberOfTapsRequired:1];
    [self.webView addGestureRecognizer:self.recognizer];
    self.recognizer.delegate = self;
    
    _fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fontButton setFrame:CGRectMake(self.view.frame.size.width/5/2,self.view.frame.size.height-44, self.view.frame.size.width/5, 44)];
    [self.view addSubview:_fontButton];
    _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lightButton setFrame:CGRectMake(self.view.frame.size.width/5*2-self.view.frame.size.width/10,self.view.frame.size.height-44, self.view.frame.size.width/5, 44)];
    [self.view addSubview:_lightButton];
    
    
    [self initToolBar];
    
    
    if (self.link) {
        [self showWithUrl:self.link];
    } else if (self.fileName) {
        [self showWithFileName:self.fileName];
    } else if (self.htmlStr) {
        [self showWithHtmlString:self.htmlStr];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [self hideWaiting];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark-
#pragma mark--功能函数
/**
 *  初始化底部工具bar
 */
- (void)initToolBar
{
    // toolbar
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    _toolBar.barStyle = UIBarStyleDefault;
    [_toolBar sizeToFit];
    _toolBar.autoresizesSubviews = NO;
    
    [_toolBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"footer.png"]]];
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:6];
    UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                             target:nil
                                                                                             action:nil];
    
//    [_fontButton setImage:[UIImage imageNamed:@"font_n.png"] forState:UIControlStateNormal];
//    [_fontButton addTarget:self action:@selector(fontsizeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _fontButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"font_n.png"]
                                                                            style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(fontsizeAction:)];
    
    _lightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"light_n.png"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(lightAction:)];
    _collectButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collect_n.png"]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(collectAction:)];
    _searchButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scroll_icon_n_2.png"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(searchAction:)];
    _shareButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(shareAction:)];
    
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:_fontButtonItem];
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:_lightButtonItem];
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:_collectButtonItem];
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:_searchButtonItem];
    [buttons addObject:flexibleSpaceButtonItem];
    [buttons addObject:_shareButtonItem];
    [buttons addObject:flexibleSpaceButtonItem];
    
    [_toolBar setItems:buttons];
    [self.view addSubview:_toolBar];

}
- (void) setScalesPageToFit
{
    [self.webView setScalesPageToFit:YES];
}

-(void) showWithFileName:(NSString *) fileName
{
    NSLog(@"filename %@",fileName);
    NSArray *dicArray = [fileName componentsSeparatedByString:@"/"];
    NSString *fname = dicArray[dicArray.count-1];
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:15];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = [fname substringToIndex:[fname rangeOfString:@".htm"].location];
        self.navigationItem.titleView = titleLabel;
    }
    // Bundle
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:nil];
    
    // Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
    
}

-(void) showWithUrl:(NSString *) url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

-(void) showWithHtmlString:(NSString *) html
{
    [self.webView loadHTMLString:html baseURL:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '500%'"];//通过 javaScript的语言进行大小的控制
    [self.view addSubview:self.webView];
}

//显示进度滚轮指示器
-(void)showWaiting {
    _progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    //    _progressInd.center=CGPointMake(self.view.center.x,240);
    _progressInd.center = self.view.center;
    [_progressInd setColor:[UIColor blackColor]];
    [self.view addSubview:_progressInd];
    [_progressInd startAnimating];
}

//消除滚动轮指示器
-(void)hideWaiting
{
    [_progressInd stopAnimating];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    // 测试发现，当为EXCEL文件时（即扩展名为xls或xlsx),则一直在屏幕上显示加载不消失，故采用如下特殊处理之。
//    if (self.fileName && [[self.fileName pathExtension] rangeOfString:@"xls"].location != NSNotFound) {
//        return ;
//    }
    
    [self showWaiting];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    /***
     
     // http://blog.csdn.net/kmyhy/article/details/7198920
     // http://www.icab.de/blog/2010/12/27/changing-the-range-of-the-zoom-factor-for-uiwebview-objects/
     
     NSString *path = [[NSBundle mainBundle] pathForResource:@"IncreaseZoomFactor" ofType:@"js"];
     NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
     [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
     [self.webView stringByEvaluatingJavaScriptFromString:@"increaseMaxZoomFactor()"];
     ***/
    [self hideWaiting];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件打开失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

#pragma mark-
#pragma mark--UIAletViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark-
#pragma mark--按钮点击事件
- (void) handleTap
{
    NSLog(@"----");
    
    //如果搜索栏存在 则隐藏搜索栏
    if ([self.view.subviews containsObject:self.mySearchBar])
    {
        [self.mySearchBar removeFromSuperview];
    }
    
    hasTapped = true;
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.navigationController.navigationBarHidden) //全屏状态
        {
            self.navigationController.navigationBarHidden = NO;
            self.navigationController.navigationBar.frame = CGRectMake(0, 20, 320, 44);
            self.webView.frame = CGRectMake(0, 0, 320, ScreenHeight-20-44-44);
            self.toolBar.frame = CGRectMake(0, self.view.frame.size.height-44, 320, 44);
        }
        else
        {
            
            self.navigationController.navigationBar.frame = CGRectMake(0, -44, 320, 44);
            self.webView.frame = CGRectMake(0, 0, 320, ScreenHeight-20);
            self.toolBar.frame = CGRectMake(0,  self.view.frame.size.height, 320, 44);
        }
        
    } completion:^(BOOL finished) {
        
        if (self.navigationController.navigationBar.frame.origin.y<0)
        {
            self.navigationController.navigationBarHidden = YES;
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)shareAction:(id)sender//分享
{
    // Do any additional setup after loading the view, typically from a nib.
    ZS_Share  *share = [[ZS_Share alloc] init];
    
    ZS_ShareResult * result = [share shareContent:nil
                                      withShareBy:NSClassFromString(@"ZS_ShareByMessage")
                                withShareDelegate:self];
    
    if (!result.shState) {
        NSLog(@"------失败-------");
    }else{
        NSLog(@"------成功------");
    }
    
}
-(void)searchAction:(id)sender//搜索
{
    if ([self.view.subviews containsObject:self.mySearchBar])
    {
        [self.mySearchBar removeFromSuperview];
    }
    else
    {
        _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0,0, 320, 44.0)];
        _mySearchBar.delegate = self;
        _mySearchBar.showsCancelButton = YES;
        [self.view addSubview: _mySearchBar];

    }
}
-(void)collectAction:(id)sender//收藏
{
    ContentModel *cmodel = [[ContentModel alloc]init];
    cmodel.url = _fileName;
    NSArray *dicArray = [_fileName componentsSeparatedByString:@"/"];
    NSString *fname = dicArray[dicArray.count-1];
    cmodel.fileName = [fname substringToIndex:[fname rangeOfString:@".htm"].location];
    FMDatabase *db = [BaseDBHelper getOpenedFMDatabase];
    [CollectDBHelper createTable:db];
    CollectDBHelper *cdb = [[CollectDBHelper alloc]init];
    
    if ([cdb findCollect:cmodel]) {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消收藏" message:@"您确定要取消收藏吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消" ,nil];
         [cdb deleteCollect:cmodel];
    }else{
        [cdb insertCollect:cmodel];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:@"收藏成功！" delegate:self cancelButtonTitle:Nil otherButtonTitles:nil ,nil];
    }
}

/**
 *  屏幕亮度调整
 *
 *  @param sender
 */
-(void)lightAction:(id)sender
{
    //the controller we want to present as a popover
    
   SliderViewController *control = [[SliderViewController alloc]init];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:control];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(200, 120);
    }
    popover.arrowDirection = FPPopoverArrowDirectionUp;
    
    //sender is the UIButton view
    //[popover presentPopoverFromView:sender];
    
     [popover presentPopoverFromView:_lightButton];
}



-(void)fontsizeAction:(id)sender//字体大小
{
    SliderViewController *control = [[SliderViewController alloc]init:_webView];
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:control];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverDefaultTint;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(200, 120);
    }
    popover.arrowDirection = FPPopoverArrowDirectionUp;
    
    //sender is the UIButton view
    //[popover presentPopoverFromView:sender];
    [popover presentPopoverFromView:_fontButton];
    
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
	[_webView highlightAllOccurencesOfString:searchBar.text];
	[_mySearchBar resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[_webView removeAllHighlights];
	[_mySearchBar resignFirstResponder];
}

-(void) shareBy:(ZS_ShareBy *) shareBy withResult:(ZS_ShareResult *) result
{
    NSLog(@"%@", result.shRetInfo);
    
    NSDictionary * dic = (NSDictionary *) result.shRetInfo;
    
    for (NSString * key in [dic allKeys])
    {
        NSLog(@"%@", [dic  objectForKey:key]);
        
    }
    [shareController dismissViewControllerAnimated:YES completion:^{
        shareController = nil;
        
    }];
    [self.navigationController.view setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-70)];
}

-(void) shareBy:(ZS_ShareBy *)shareBy withRootOject:(id)controller
{
    shareController = [controller retain];
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

@end
