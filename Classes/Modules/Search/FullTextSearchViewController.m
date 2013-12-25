//
//  FullTextSearchViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-12-1.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "FullTextSearchViewController.h"
#import "FileModel.h"
#import "ShowContentViewController.h"

@interface FullTextSearchViewController ()

@end

@implementation FullTextSearchViewController
@synthesize mytableView = _mytableView;
@synthesize myarray = _myarray;
@synthesize searchWord = _searchWord;
@synthesize mySearchBar = _mySearchBar;

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
    _myarray = [[NSMutableArray array]init];
    self.hasSureButton = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES];
   // [self.view setFrame:CGRectMake(0, 20, 320, [[UIScreen mainScreen] bounds].size.height)];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg"]]];
    
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,20, 320, 44.0)];
	_mySearchBar.delegate = self;
	_mySearchBar.showsCancelButton = YES;
	[self.view addSubview: _mySearchBar];
    
    _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 70, 310, self.tableViewHeight_1) style:UITableViewStylePlain];
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
- (void) viewDidAppear:(BOOL)animated
{
   
}
#pragma mark-
#pragma mark--http请求

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    _myarray = [[NSMutableArray array]init];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                         sendRequestWithRequestDic:@{@"searchword":[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]}
                                         requesId:FULLSEARCH messId:nil success:^(id obj) {
                                             if([[obj objectForKey:@"rs"]intValue] == 1){
                                                 NSArray *listArray = obj[@"rsList"];
                                                 for(int i = 0;i<listArray.count;i++){
                                                     NSDictionary *dic = listArray[i];
                                                     FileModel *file  = [[FileModel alloc]init];
                                                     file.filePath = dic[@"htmlPath"];
                                                     NSLog(@"file.filePath %@",file.filePath);
                                                     if ([dic[@"filename"] rangeOfString:@".htm"].location != NSNotFound) {
                                                         file.fileName = [NSString stringWithFormat:@"%@",[dic[@"filename"] substringToIndex:[dic[@"filename"] rangeOfString:@".htm"].location]];
                                                     }
                                                     [self.myarray addObject:file];
                                                 }
                                                 NSLog(@"self.myarray count %d",[self.myarray count]);
                                                 [self.mytableView reloadData];
                                             }else if([[obj objectForKey:@"rs"]intValue] == 0){
                                                 [SVProgressHUD showErrorWithStatus:@"无符合条件的记录"];
                                             }
                                         } failure:^(NSString *errMsg) {
                                             
                                         }];
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"搜索中..."
                                   completeBlock:nil];
	[_mySearchBar resignFirstResponder];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[_mySearchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.myarray.count;
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
    
    FileModel *file = [self.myarray objectAtIndex:indexPath.row];
    UILabel *bnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 300, 50)];
    bnameLabel.backgroundColor = [UIColor clearColor];
    bnameLabel.textAlignment = UITextAlignmentLeft;
    bnameLabel.font = [UIFont boldSystemFontOfSize:15];
    bnameLabel.textColor = [UIColor blackColor];
    bnameLabel.text = file.fileName;
    [cell.contentView addSubview:bnameLabel];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileModel *file = [self.myarray objectAtIndex:indexPath.row];
    NSString *bookname = [[file.filePath substringFromIndex:15]substringToIndex:[[file.filePath substringFromIndex:15] rangeOfString:@"\\"].location];
    NSLog(@"bookname %@",bookname);
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                         sendRequestWithRequestDic:@{@"username":[UserDefaults objectForKey:KUSERNAME],@"bookname":[bookname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]}
                                         requesId:ISBUY messId:nil success:^(id obj) {
                                             if([[obj objectForKey:@"rs"]intValue] == 1){//已购买
                                                 NSString *filep = [[file.filePath substringFromIndex:15] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                                                 NSLog(@"filep %@",filep);
                                                 ShowContentViewController *vc = [[ShowContentViewController alloc] initWithFileName:filep];
                                                 vc.hidesBottomBarWhenPushed = YES;
                                                 [self.navigationController pushViewController:vc animated:YES];
                                             }else if([[obj objectForKey:@"rs"]intValue] == 0){//未购买
                                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:
                                                                       [NSString stringWithFormat:@"您未购买不能查看，请到首页面购买%@电子书，以便查看。",bookname]
                                                                        delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消" ,nil];
                                                 [alert show];
                                             }
                                         } failure:^(NSString *errMsg) {
                                             
                                         }];
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"打开中..."
                                   completeBlock:nil];
}


@end
