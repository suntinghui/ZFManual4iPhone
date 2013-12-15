//
//  SliderViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-12.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "SliderViewController.h"

@interface SliderViewController ()

@end

@implementation SliderViewController
@synthesize Slide = _Slide;
@synthesize webView = _webView;
@synthesize flag = _flag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) init:(UIWebView *) webv
{
    if (self = [super init]) {
        _webView = webv;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"屏幕亮度调整";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg.png"]]];
    _Slide = [[UISlider alloc] initWithFrame:CGRectMake(5, 10, 170, 20)];
    
    if (_webView==nil) {
        NSLog(@"111");
        [_Slide addTarget:self action:@selector(SlideChange) forControlEvents:UIControlEventValueChanged];
    }else{
           NSLog(@"222");
        [_Slide addTarget:self action:@selector(fontSlideChange) forControlEvents:UIControlEventValueChanged];
    }
    _Slide.maximumValue = 1.0f;
    _Slide.minimumValue =0.0f;
    _Slide.value = 1.0f;
    [self.view addSubview:_Slide];
}
-(void)SlideChange
{
    [[UIScreen mainScreen] setBrightness: _Slide.value];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fontSlideChange
{
    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",_Slide.value];
    [_webView stringByEvaluatingJavaScriptFromString:str1];
}

@end
