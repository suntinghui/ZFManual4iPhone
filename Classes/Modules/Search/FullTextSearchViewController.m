//
//  FullTextSearchViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-1.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "FullTextSearchViewController.h"

@interface FullTextSearchViewController ()

@end

@implementation FullTextSearchViewController

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
     self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"搜索";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
