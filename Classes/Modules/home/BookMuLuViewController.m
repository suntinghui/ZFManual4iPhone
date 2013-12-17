//
//  BookMuLuViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-11-5.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "BookMuLuViewController.h"
#import "BookModel.h"
#import "TreeViewNode.h"
#import "TheProjectCell.h"
#import "FileManagerUtil.h"
#import "TreeViewNode.h"
#import "ShowContentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BookMuLuViewController ()

@end

@implementation BookMuLuViewController
@synthesize bookName = _bookName;
@synthesize mytableView = _mytableView;

@synthesize nodes = _nodes;
@synthesize displayArray = _displayArray;
@synthesize indentation = _indentation;


-(id) initWithBookName:(NSString *) bookName
{
    if (self = [super init]) {
        _bookName = bookName;
        _nodes = [NSMutableArray array];
        _displayArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.isHomeMain = YES;
    self.hasSureButton = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg"]]];
   
    //[ApplicationDelegate.rootNavigationController setNavigationBarHidden:NO animated:YES];
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"图书列表";
        self.navigationItem.titleView = titleLabel;
    }
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
    
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
    NSMutableArray *firnodes = [FileManagerUtil showFileList:_bookName];
    for (NSString *filename in firnodes) {
        TreeViewNode *LevelNode = [[TreeViewNode alloc]init];
        LevelNode.nodeLevel = 0;
        LevelNode.parentName = _bookName;
        if ([filename rangeOfString:@".htm"].location != NSNotFound) {
            LevelNode.nodeObject = [NSString stringWithFormat:@"%@",[filename substringToIndex:[filename rangeOfString:@".htm"].location]];
            LevelNode.isLeaf = YES;
        }else{
            LevelNode.nodeObject = [NSString stringWithFormat:@"%@",filename];
            LevelNode.nodeChildren = [[self fillChildrenForNode:0 parentName:[NSString stringWithFormat:@"%@/%@",_bookName,filename]] mutableCopy];
            LevelNode.isLeaf = NO;
        }
        LevelNode.isExpanded = NO;
        [_nodes addObject:LevelNode];
    }
    
    [self fillDisplayArray];
    [self.mytableView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillNodesArray:(int)level
{
    TreeViewNode *levelNode = [[TreeViewNode alloc]init];
    levelNode.nodeLevel = 0;
    
}
- (NSArray *)fillChildrenForNode:(NSInteger)nodelevel parentName:(NSString *)pname
{
    NSMutableArray *childnode = [NSMutableArray arrayWithCapacity:10];
    childnode = [FileManagerUtil showFileList:pname];
    NSMutableArray *childarray = [NSMutableArray arrayWithCapacity:10];
    for (NSString *filename in childnode) {
        TreeViewNode *LevelNode = [[TreeViewNode alloc]init];
        LevelNode.nodeLevel = nodelevel + 1;
        LevelNode.parentName = pname;
        if ([filename rangeOfString:@".htm"].location != NSNotFound) {
            LevelNode.nodeObject = [NSString stringWithFormat:@"%@",[filename substringToIndex:[filename rangeOfString:@".htm"].location]];
            LevelNode.isLeaf = YES;
        }else{
            LevelNode.nodeObject = [NSString stringWithFormat:@"%@",filename];
            LevelNode.nodeChildren = [[self fillChildrenForNode:nodelevel+1 parentName:[NSString stringWithFormat:@"%@/%@",pname,filename]] mutableCopy];
            LevelNode.isLeaf = NO;
        }
        LevelNode.isExpanded = NO;
        [childarray addObject:LevelNode];
    }
    return childarray;
}

- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.mytableView reloadData];
}
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in _nodes) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

#pragma mark -Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"treeNodeCell";
    UINib *nib = [UINib nibWithNibName:@"ProjectCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    TheProjectCell *cell = (TheProjectCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    cell.treeNode = node;
    cell.cellLabel.text = node.nodeObject;
    if (!node.isLeaf) {
        if (node.isExpanded&&!node.isLeaf) {
            [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"open.png"]];
        }
        else {
            [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"close.png"]];
        }
    }else{
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"bookicon.png"]];
    }
    [cell setNeedsDisplay];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    if (node.isLeaf) {
        ShowContentViewController *vc = [[ShowContentViewController alloc] initWithFileName:[NSString stringWithFormat:@"%@/%@.htm",node.parentName,node.nodeObject ]];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else{
        return;
    }
}



@end
