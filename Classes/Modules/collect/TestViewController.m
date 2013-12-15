//
//  TestViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-11.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "TestViewController.h"
#import "FPPopoverController.h"
#import "SliderViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController
@synthesize loginIV = _loginIV;


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
    self.isHomeMain = YES;
    self.hasSureButton = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg"]]];
   // [ApplicationDelegate.rootNavigationController setNavigationBarHidden:NO animated:YES];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(33, 100, 257, 34)];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(bottomCenter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
}
-(void)popover:(id)sender
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
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    [popover presentPopoverFromView:sender];
}

-(IBAction)bottomCenter:(id)sender
{
    [self popover:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
