//
//  HelpViewController.m
//  LKOA4iPhone
//
//  Created by  STH on 7/31/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"帮助";
        self.navigationItem.titleView = titleLabel;
    }
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"big_bg"]]];
    float height = 416.0f;
    if (IS_IPHONE_5) {
        height = 568.0f;
    }
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, height - 63)];
    
    //使用loadHTMLString()方法显示网页内容
    [webView loadHTMLString:[self getHtmlString] baseURL:nil];
    
    [self.view addSubview:webView];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


//读取html文件内容
- (NSString *)getHtmlString{
    
    //文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"html"];
    
    NSString *contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return contents;
}



@end
