//
//  CollectViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-10.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "CollectViewController.h"
#import "CollectDBHelper.h"
#import "ContentModel.h"
#import "ShowContentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CollectViewController ()

@end

@implementation CollectViewController
@synthesize model = _model;
@synthesize isCollect = _isCollect;

@synthesize mytableView = _mytableView;
@synthesize myarray = _myarray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id) initWithFile:(ContentModel *) model
{
    if (self = [super init]) {
        _model = model;
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
    
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"我的收藏";
        self.navigationItem.titleView = titleLabel;
    }
    
    _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 10, 310, self.tableViewHeight_1) style:UITableViewStylePlain];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    [_mytableView setBackgroundColor:[UIColor clearColor]];
    [_mytableView setBackgroundView:[[UIView alloc]init]];
    _mytableView.layer.borderWidth = 1;
    _mytableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _mytableView.layer.cornerRadius = 8.0;
    [self setExtraCellLineHidden:_mytableView];
    [self.view addSubview:_mytableView];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}
-(void)refresh{
    CollectDBHelper *cdb = [[CollectDBHelper alloc]init];
    _myarray = [cdb queryAll];
    NSLog(@"myarray %d",[_myarray count]);
    [self.mytableView reloadData];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myarray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    static NSString *cellIdentifier = @"CellIdenti";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //避免重叠
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if ([self.myarray count] == 0) {
        UILabel *noDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 240, 25)];
        [noDateLabel setText:@"没有数据！"];
        [noDateLabel setTextAlignment:NSTextAlignmentCenter];
        [noDateLabel setBackgroundColor:[UIColor clearColor]];
        [noDateLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [noDateLabel setTextColor:[UIColor blackColor]];
        [cell.contentView addSubview:noDateLabel];
        return cell;
    }
    ContentModel *cm = self.myarray[indexPath.row];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buylist_icon.png"]];
    [image setFrame:CGRectMake(10, 25, 16, 15)];
    [image setUserInteractionEnabled:YES];
    [cell.contentView addSubview:image];
    
    
    UILabel *bnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, 280, 50)];
    bnameLabel.backgroundColor = [UIColor clearColor];
    bnameLabel.textAlignment = UITextAlignmentLeft;
    bnameLabel.font = [UIFont boldSystemFontOfSize:15];
    bnameLabel.textColor = [UIColor blackColor];
    bnameLabel.text = cm.fileName;
    [cell.contentView addSubview:bnameLabel];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentModel *cm = self.myarray[indexPath.row];
    ShowContentViewController *vc = [[ShowContentViewController alloc] initWithFileName:cm.url];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
