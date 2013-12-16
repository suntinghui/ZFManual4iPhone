//
//  HomeViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-30.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "BookModel.h"
#import "BookMuLuViewController.h"
#import "PayViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize mytableView = _mytableView;
@synthesize myarray = _myarray;
@synthesize imageView = _imageView;
@synthesize bookarray = _bookarray;
@synthesize booktableView;


- (id)init
{
    if (self = [super init]) {
        _myarray = [[NSMutableArray array]init];
        _bookarray = [[NSMutableArray array]init];
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
    
    
    //[ApplicationDelegate.rootNavigationController setNavigationBarHidden:NO animated:YES];
    
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"手册列表";
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
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--http请求
-(void)refresh{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
    sendRequestWithRequestDic:@{@"userName":[UserDefaults objectForKey:KUSERNAME]}
    requesId:BOOKLIST messId:nil success:^(id obj) {
        if([[obj objectForKey:@"rs"]intValue] == 1){
            NSArray *listArray = obj[@"rsList"];
            for(int i = 0;i<listArray.count;i++){
                NSDictionary *dic = listArray[i];
                BookModel *book = [[BookModel alloc]init];
                book.bookname = dic[@"bookName"];
                book.bookId = dic[@"bookId"];
                book.state = dic[@"state"];
                book.price = dic[@"price"];
                [self.myarray addObject:book];
            }
            [self.mytableView reloadData];
        }else if([[obj objectForKey:@"rs"]intValue] == 0){
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
    } failure:^(NSString *errMsg) {
        
    }];
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                          prompt:@"加载中..."
                                   completeBlock:nil];
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
    
    BookModel *book = self.myarray[indexPath.row];
    UILabel *bnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 170, 50)];
    bnameLabel.backgroundColor = [UIColor clearColor];
    bnameLabel.textAlignment = UITextAlignmentLeft;
    bnameLabel.font = [UIFont boldSystemFontOfSize:15];
    bnameLabel.textColor = [UIColor blackColor];
    bnameLabel.text = book.bookname;
    [cell.contentView addSubview:bnameLabel];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 60, 50)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textAlignment = UITextAlignmentCenter;
    priceLabel.font = [UIFont boldSystemFontOfSize:15];
    priceLabel.textColor = [UIColor blackColor];
    if ([book.price intValue] == 0){
        priceLabel.text = @"免费";
    }else{
        priceLabel.text = [NSString stringWithFormat:@"￥%@元",book.price];
    }
    [cell.contentView addSubview:priceLabel];
    
    if ([book.state isEqualToString:@"1"]) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buy_s.png"]];
    }else{
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buy_n.png"]];
    }
    [_imageView setFrame:CGRectMake(235, 0, 6, 50)];
    [_imageView setUserInteractionEnabled:YES];
    [cell.contentView addSubview:_imageView];
                          
    UILabel *buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 5, 40, 50)];
    buyLabel.backgroundColor = [UIColor clearColor];
    buyLabel.textAlignment = UITextAlignmentRight;
    buyLabel.font = [UIFont boldSystemFontOfSize:15];
    buyLabel.textColor = [UIColor blackColor];
    if ([book.state isEqualToString:@"1"]) {
        buyLabel.text = @"查看";
    }else{
        buyLabel.text = @"购买";
    }
    [cell.contentView addSubview:buyLabel];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(225, 5, 50, 50)];
    [btn setBackgroundColor:[UIColor clearColor]];
//    if ([book.state isEqualToString:@"1"]) {
//        [btn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
//    }else{
//        [btn addTarget:self action:@selector(buyBook:) forControlEvents:UIControlEventTouchUpInside];
//    }
    [cell.contentView addSubview:btn];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *book = self.myarray[indexPath.row];
    __block NSArray *bookarray = nil;
    if ([book.state isEqualToString:@"1"]||[book.price intValue] == 0)//查看
    {
        AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                             sendRequestWithRequestDic:@{@"bookname":[book.bookname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]}
                                             requesId:MULU messId:nil success:^(id obj) {
                                                 bookarray = [NSArray arrayWithArray:obj];
                                                 NSLog(@"count %d",[bookarray count]);
                                                 [[Transfer sharedTransfer]downloadBookWithName:book.bookname
                                                                                      bookArray:bookarray
                                                                                 viewController:self
                                                                                        success:^(id obj) {
                                                                                            NSLog(@"success");
                                                                                            
                                                                                            BookMuLuViewController *bookMulu = [[BookMuLuViewController alloc]initWithBookName:book.bookname];
                                                                                         //   bookMulu.title = @"图书列表";
                                                                                            
                                                                                            [self.navigationController pushViewController:bookMulu animated:YES];
                                                                                            
                                                                                        } failure:^(NSString *errMsg) {
                                                                                            
                                                                                        }];
                                                 
                                             } failure:^(NSString *errMsg) {
                                                 
                                             }];
        [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil]
                                              prompt:@"加载中..."
                                       completeBlock:nil];
    }else{//购买
        PayViewController *payVC = [[PayViewController alloc]initWithNamePrice:book.bookname pprice:[book.price floatValue] bookId:book.bookId shouldSure:YES];
      
        [self.navigationController pushViewController:payVC animated:YES ];
    }
    
}

@end
