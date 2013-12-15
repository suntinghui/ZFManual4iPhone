//
//  AboutViewController.m
//  LKOA4iPhone
//
//  Created by liao jia on 13-7-31.
//  Copyright (c) 2013年 DHC. All rights reserved.
//

#import "AboutViewController.h"

#define LABEL_X 40
#define LABEL_H 150
#define LABEL_W 180

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"关于我们";
        self.navigationItem.titleView = titleLabel;
    }

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg"]]];
    
    UIImageView *logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [logoIV setFrame:CGRectMake(120, 20, 86, 86)];
    [logoIV setUserInteractionEnabled:YES];
    [self.view addSubview:logoIV];
    
    //分隔线
    UIImageView *lineIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divide_line"]];
    [lineIV setFrame:CGRectMake(20, 130, 280, 1)];
    [self.view addSubview:lineIV];
    
    //版本
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 300, 25)];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setText:@"执法手册iphone1.0.0版"];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setTextColor:[UIColor grayColor]];
    [versionLabel setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:versionLabel];
    
    //电话
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(40, LABEL_H, 240, 38)];
    [button setBackgroundImage:[UIImage imageNamed:@"phone_button.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //邮箱
    UILabel *mailLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_H+45, LABEL_W, 25)];
    [mailLabel1 setBackgroundColor:[UIColor clearColor]];
    [mailLabel1 setText:@"电子邮箱："];
    [mailLabel1 setTextAlignment:NSTextAlignmentLeft];
    [mailLabel1 setTextColor:[UIColor grayColor]];
    [mailLabel1 setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:mailLabel1];
    
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, LABEL_H+45, LABEL_W, 25)];
    [mailLabel setBackgroundColor:[UIColor clearColor]];
    [mailLabel setText:@"17600386@qq.com"];
    [mailLabel setTextAlignment:NSTextAlignmentLeft];
    [mailLabel setTextColor:[UIColor grayColor]];
    [mailLabel setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:mailLabel];
    
    //地址
    UILabel *addressLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_H+70, 60, 25)];
    [addressLabel1 setBackgroundColor:[UIColor clearColor]];
    [addressLabel1 setText:@"地       址:"];
    [addressLabel1 setTextAlignment:NSTextAlignmentLeft];
    [addressLabel1 setTextColor:[UIColor grayColor]];
    [addressLabel1 setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:addressLabel1];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, LABEL_H+70, 170, 25)];
    [addressLabel setBackgroundColor:[UIColor clearColor]];
    [addressLabel setText:@"北京市海淀区马甸东路9号"];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setTextColor:[UIColor grayColor]];
    addressLabel.lineBreakMode = UILineBreakModeWordWrap;
    addressLabel.numberOfLines = 0;
    [addressLabel setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:addressLabel];
    
    //copyright
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, LABEL_H+145+self.height, 300, 25)];
    [copyrightLabel setBackgroundColor:[UIColor clearColor]];
    [copyrightLabel setText:@"Copyright © 2010 www.npgi.com.cn All Rights Reserved"];
    [copyrightLabel setTextAlignment:NSTextAlignmentCenter];
    [copyrightLabel setTextColor:[UIColor grayColor]];
    [copyrightLabel setFont:[UIFont systemFontOfSize:11]];
    [self.view addSubview:copyrightLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)callButtonAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://01084290315"]];
}
@end
