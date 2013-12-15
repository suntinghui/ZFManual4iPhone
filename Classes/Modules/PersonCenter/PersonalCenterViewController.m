//
//  PersonalCenterViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-11-3.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BookModel.h"
#import "AFHTTPRequestOperation.h"
#import "SVProgressHUD.h"

#define TF_X   33
#define TF_W   20
#define FONT_W 30

@interface PersonalCenterViewController ()

@end

@implementation PersonalCenterViewController
@synthesize isLeft = _isLeft;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize rightArray = _rightArray;
@synthesize leftView = _leftView;
@synthesize rightTView = _rightTView;

@synthesize userTF = _userTF;
@synthesize pwdTF = _pwdTF;
@synthesize pwd2TF = _pwd2TF;

@synthesize grzlLab = _grzlLab;
@synthesize grzlLabr = _grzlLabr;
@synthesize imagev = _imagev;
@synthesize imagevr = _imagevr;
@synthesize firstcount = _firstcount;

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
        _rightArray = [[NSMutableArray array]init];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg"]] ];
    //[ApplicationDelegate.rootNavigationController setNavigationBarHidden:YES animated:YES];
    
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
        titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
        titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"个人中心";
        self.navigationItem.titleView = titleLabel;
    }
    
    self.firstcount = 0;
    self.isLeft = YES;

    
    [self initTabSelect];
    
    [self initMainControl];
    
    [self initInputControl];
    
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark-
#pragma mark--功能函数
/**
 *  初始化顶部seg选择控件
 */
- (void)initTabSelect
{
    UISegmentedControl *segControl = [[UISegmentedControl alloc]initWithItems:@[@"个人资料",@"我的购买"]];
    segControl.frame = CGRectMake(50, 15, 220, 30);
    segControl.selectedSegmentIndex = 0;
    [self.view addSubview:segControl];
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
   // segControl.tintColor = RGBCOLOR(25, 85, 145);
    [segControl addTarget:self action:@selector(typeChange:) forControlEvents:UIControlEventValueChanged];
}
/**
 *  初始化密码输入框
 */
- (void)initInputControl
{
    UIImageView *username = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username.png"]];
    [username setFrame:CGRectMake(TF_X,50, 257, 34)];
    [username setUserInteractionEnabled:YES];
    [_leftView addSubview:username];
    _userTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X+FONT_W, 50, 227, 34)];
    _userTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userTF.delegate = self;
    [_userTF setPlaceholder:@"请输入用户名"];
    [_userTF setText:[UserDefaults objectForKey:KUSERNAME]];
    [_userTF setEnabled:NO];
    [_userTF setFont:[UIFont boldSystemFontOfSize:15]];
    _userTF.returnKeyType = UIReturnKeyDone;
    [_leftView addSubview:_userTF];
    
    UIImageView *pwdIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password.png"]];
    [pwdIV setFrame:CGRectMake(TF_X,84+TF_W, 257, 34)];
    [pwdIV setUserInteractionEnabled:YES];
    [_leftView addSubview:pwdIV];
    _pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X+FONT_W,84+TF_W, 227, 34)];
    _pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdTF.delegate = self;
    [_pwdTF setPlaceholder:@"请输入旧密码"];
    [_pwdTF setSecureTextEntry:YES];
    [_pwdTF setFont:[UIFont boldSystemFontOfSize:15]];
    _pwdTF.returnKeyType = UIReturnKeyDone;
    [_leftView addSubview:_pwdTF];
    
    UIImageView *pwd2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password.png"]];
    [pwd2 setFrame:CGRectMake(TF_X,133+TF_W, 257, 34)];
    [pwd2 setUserInteractionEnabled:YES];
    [_leftView addSubview:pwd2];
    _pwd2TF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X+FONT_W, 133+TF_W, 227, 34)];
    _pwd2TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwd2TF.delegate = self;
    [_pwd2TF setPlaceholder:@"请输入新密码"];
    [_pwd2TF setSecureTextEntry:YES];
    [_pwd2TF setFont:[UIFont boldSystemFontOfSize:15]];
    _pwd2TF.returnKeyType = UIReturnKeyDone;
    [_leftView addSubview:_pwd2TF];

}

/**
 *  初始化左右主要视图
 */
- (void)initMainControl
{
    
    //左侧
    float height = iPhone5?518: 480.0f;
    
    _leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 55, 320,height)];
    [_leftView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg.png"]]];
    [_leftView setUserInteractionEnabled:YES];
    [self.view addSubview:_leftView];
    
    
    UIButton *changebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changebutton setFrame:CGRectMake(TF_X, 201+TF_W, 257, 34)];
    [changebutton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [changebutton setTitle:@"确认修改" forState:UIControlStateNormal];
    [changebutton addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_leftView addSubview:changebutton];
    
    
    //右侧
    _rightTView = [[UITableView alloc]initWithFrame:CGRectMake(10, 60, 300, 280)];
    _rightTView.delegate = self;
    _rightTView.dataSource = self;
    _rightTView.layer.borderWidth = 1;
    _rightTView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    _rightTView.layer.cornerRadius = 8.0;
    //   [self setExtraCellLineHidden:_rightTView];
    //   [self rightRefresh];

}
/**
 *  页面输入合法性判断
 *
 *  @return
 */
-(BOOL) checkValue{
    if([@"" isEqualToString:[_userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"用户名不能为空"];
        return NO;
    }else if([@"" isEqualToString:[_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"旧密码不能为空"];
        return  NO;
    }else if([@"" isEqualToString:[_pwd2TF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空"];
        return  NO;
    }
    return YES;
}


#pragma mark-
#pragma mark--http请求
-(void)rightRefresh{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                         sendRequestWithRequestDic:@{@"userName":[UserDefaults objectForKey:KUSERNAME]}
                                         requesId:BUYLIST messId:nil success:^(id obj) {
                                             if([[obj objectForKey:@"rs"]intValue] == 1){
                                                 NSArray *listArray = obj[@"rsList"];
                                                 for(int i = 0;i<listArray.count;i++){
                                                     NSDictionary *dic = listArray[i];
                                                     BookModel *book = [[BookModel alloc]init];
                                                     book.bookname = dic[@"bookName"];
                                                     book.bookId = dic[@"bookId"];
                                                     //    book.state = dic[@"state"];
                                                     book.price = dic[@"price"];
                                                     book.buytime = dic[@"buytime"];
                                                     [self.rightArray addObject:book];
                                                 }
                                                 [self.rightTView reloadData];
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
#pragma mark--按钮点击事件
/**
 *  顶部seg选择控制
 *
 *  @param sender
 */
-(IBAction)typeChange:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    if (segment.selectedSegmentIndex == 0)
    {
        _isLeft = YES;
        [_rightTView removeFromSuperview];
        [self.view addSubview:_leftView];
    }
    else
    {
        _isLeft = NO;
        self.firstcount = _firstcount + 1;
       // if (self.firstcount == 1) {
            [self rightRefresh];
       // }
        [_leftView removeFromSuperview];
        [self setExtraCellLineHidden:_rightTView];
        [self.view addSubview:_rightTView];
        [_rightTView reloadData];
    }
}

/**
 *  密码修改操作
 *
 *  @param sender
 */
-(IBAction)changeAction:(id)sender
{
    if(![self checkValue]){
        return;
    }
    NSString *userName = [_userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newpwd = [_pwd2TF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"userName",password,@"oldpwd",newpwd,@"newpwd",nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]TransferWithRequestDic:requestDic requesId:MODPWD prompt:nil replaceId:nil success:^(id obj) {
        [AppDataCenter sharedAppDataCenter].sid = [obj objectForKey:@"sid"];
        if([[obj objectForKey:@"rs"]intValue]== 1){
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
        }else if([[obj objectForKey:@"rs"]intValue] == 0){
            [SVProgressHUD showErrorWithStatus:@"密码修改失败！"];
        }else if([[obj objectForKey:@"rs"]intValue]== 2){
            [SVProgressHUD showErrorWithStatus:@"原密码错误！"];
        }
    } failure:^(NSString *errMsg) {
        
    }];
    [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在修改密码..." completeBlock:^(NSArray *operations) {
        
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark-
#pragma mark--UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLeft) {
        
    }else{
        if ([self.rightArray count] == 0) {
            return 1;
        }
        return [_rightArray count];
    }
    return 0;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isLeft) {
        return 50;
    }else{
        return 400;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //避免重叠
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (!_isLeft) {
        if ([self.rightArray count] == 0) {
            UILabel *noDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 240, 25)];
            [noDateLabel setText:@"没有数据！"];
            [noDateLabel setTextAlignment:NSTextAlignmentCenter];
            [noDateLabel setBackgroundColor:[UIColor clearColor]];
            [noDateLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [noDateLabel setTextColor:[UIColor blackColor]];
            [cell.contentView addSubview:noDateLabel];
            return cell;
        }
    
        BookModel *book = self.rightArray[indexPath.row];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buylist_icon.png"]];
        [image setFrame:CGRectMake(10, 25, 16, 15)];
        [image setUserInteractionEnabled:YES];
        [cell.contentView addSubview:image];
        
        UILabel *bnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, 120, 50)];
        bnameLabel.backgroundColor = [UIColor clearColor];
        bnameLabel.textAlignment = UITextAlignmentLeft;
        bnameLabel.font = [UIFont boldSystemFontOfSize:15];
        bnameLabel.textColor = [UIColor blackColor];
        bnameLabel.text = book.bookname;
        [cell.contentView addSubview:bnameLabel];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 40, 50)];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = UITextAlignmentCenter;
        priceLabel.font = [UIFont boldSystemFontOfSize:15];
        priceLabel.textColor = [UIColor blackColor];
        priceLabel.text = [NSString stringWithFormat:@"￥%@元",book.price];
        [cell.contentView addSubview:priceLabel];
        
        UILabel *buytimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 5, 80, 50)];
        buytimeLabel.backgroundColor = [UIColor clearColor];
        buytimeLabel.textAlignment = UITextAlignmentRight;
        buytimeLabel.text = [NSString stringWithFormat:@"%@",book.buytime];
        buytimeLabel.font = [UIFont boldSystemFontOfSize:15];
        buytimeLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:buytimeLabel];
    }
    return cell;
}

@end
