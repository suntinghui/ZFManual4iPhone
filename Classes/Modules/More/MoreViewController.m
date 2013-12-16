//
//  MoreViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-1.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "MoreViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_HEIGHT 40

@interface MoreViewController ()

@end

@implementation MoreViewController
@synthesize textArray = _textArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    if (self = [super init]) {
        _textArray = [[NSArray array]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"1111");
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;

    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"系统设置";
        self.navigationItem.titleView = titleLabel;
    }
    self.isBackMain = YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg"]]];
    
    self.textArray = [NSArray arrayWithObjects:@"帮助", @"访问官网",@"推荐好友", @"关于我们", @"注销登录", nil];
    
    int tableViewHeight = 0;
    if(IS_IPHONE_5){
        tableViewHeight = 420.0f;
    }else{
        tableViewHeight = 330.0f;
    }
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, 300, tableViewHeight) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.layer.borderWidth = 1;
    myTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    myTableView.layer.cornerRadius = 8.0;
    [self setExtraCellLineHidden:myTableView];
    [self.view addSubview:myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.textArray count];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *contentText = [self.textArray objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 6, 100, 25)];
    [label setText:contentText];
    [label setFont:[UIFont systemFontOfSize:15]];
    [cell.contentView addSubview:label];
    
    NSString *imageName = [NSString stringWithFormat:@"setting_%d", indexPath.row+1];
    UIImageView *leftIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [leftIV setFrame:CGRectMake(15, 12, 15, 15)];
    [cell.contentView addSubview:leftIV];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    switch (indexPat.row) {
        case 0:
        {
            HelpViewController *vc = [[HelpViewController alloc] init];
        //    vc.scrollVC = self.scrollVC;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            NSURL *url = [NSURL URLWithString:@"http://www.npgi.com.cn"];
            [[UIApplication sharedApplication ] openURL:url ];
            break;
        }
        case 2:
        {
            // Do any additional setup after loading the view, typically from a nib.
            ZS_Share  *share = [[[ZS_Share alloc] init] autorelease];
            //    ZS_ShareResult * result = [share shareContent:nil withShareBy:NSClassFromString(@"ZS_ShareByMail") withShareDelegate:self];
            
            ZS_ShareResult * result = [share shareContent:nil
                                              withShareBy:NSClassFromString(@"ZS_ShareByMessage")
                                        withShareDelegate:self];
            
            if (!result.shState) {
                NSLog(@"------失败-------");
            }else{
                NSLog(@"------成功------");
            }
            break;
        }
        case 3:
        {
            AboutViewController *vc = [[AboutViewController alloc] init];
        //    vc.scrollVC = self.scrollVC;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注销登录" message:@"您确定要注销登录吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消" ,nil];
            alert.tag = 100;
            [alert show];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark-
#pragma mark--UIAlertViewDelagte
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100){
        if (buttonIndex == 0) {
            // 跳转到登录界面
            [ApplicationDelegate.rootNavigationController dismissViewControllerAnimated:YES completion:nil];
            [ApplicationDelegate.rootNavigationController popToRootViewControllerAnimated:YES];
            
        }
    }
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
        [shareController release];
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
