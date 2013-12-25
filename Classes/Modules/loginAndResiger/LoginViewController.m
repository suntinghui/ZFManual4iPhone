//
//  LoginViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-18.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "HomeViewController.h"
#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "PersonalCenterViewController.h"
#import "MoreViewController.h"
#import "CollectViewController.h"
#import "TestViewController.h"
#import "FullTextSearchViewController.h"


#define TF_X1   33
#define TF_Y1   55
#define LB_x1   58
#define kDuration 0.9   // 动画持续时间(秒)



@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userTF = _userTF;
@synthesize pwdTF = _pwdTF;
@synthesize rememberPwdButton = _rememberPwdButton;
@synthesize rememberLabel = _rememberLabel;
@synthesize autoLoginButton = _autoLoginButton;
@synthesize loginIV = _loginIV;

@synthesize  isRember = _isRember;
@synthesize  isAutoLogin = _isAutoLogin;
static bool checkUpate = false;

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
    _isRember = [[NSUserDefaults standardUserDefaults] boolForKey:kREMEBERPWD];
    _isAutoLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kAUTOLOGIN];
    float height = 480.0f;
    float height_2 = 0.0f;
    if(iPhone5){
        height = 568.0f;
        height_2 = 20.0f;
    }
    _loginIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    [_loginIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg.png"]]];
    [_loginIV setUserInteractionEnabled:YES];
    [self.view addSubview:_loginIV];
    
    UIImageView *logoIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    [logoIV setFrame:CGRectMake(120, 40+height_2, 86, 86)];
    [logoIV setUserInteractionEnabled:YES];
    [_loginIV addSubview:logoIV];
    
    UIImageView *title = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"handbook.png"]];
    [title setFrame:CGRectMake(120, 136+height_2, 82, 20)];
    [logoIV setUserInteractionEnabled:YES];
    [_loginIV addSubview:title];
    
    UIImageView *username = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username.png"]];
    [username setFrame:CGRectMake(TF_X1,176+height_2, 257, 34)];
    [username setUserInteractionEnabled:YES];
    [_loginIV addSubview:username];
    _userTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X1+30, 176+height_2, 227, 34)];
    _userTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userTF.delegate = self;
    [_userTF setPlaceholder:@"请输入用户名"];
    [_userTF setText:[[NSUserDefaults standardUserDefaults]stringForKey:KUSERNAME]];
    [_userTF setFont:[UIFont boldSystemFontOfSize:15]];
    _userTF.returnKeyType = UIReturnKeyDone;
    [_loginIV addSubview:_userTF];
    
    UIImageView *pwd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password.png"]];
    [pwd setFrame:CGRectMake(TF_X1, 220+height_2, 257, 34)];
    [pwd setUserInteractionEnabled:YES];
    [_loginIV addSubview:pwd];
    _pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X1+30, 220+height_2, 227, 34)];
    _pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdTF.delegate = self;
    [_pwdTF setPlaceholder:@"请输入密码"];
    [_pwdTF setText:[[NSUserDefaults standardUserDefaults]stringForKey:kPASSWORD]];
    [_pwdTF setFont:[UIFont boldSystemFontOfSize:15]];
    [_pwdTF setSecureTextEntry:YES];
    _pwdTF.returnKeyType = UIReturnKeyDone;
    [_loginIV addSubview:_pwdTF];
    
    _rememberPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rememberPwdButton setFrame:CGRectMake(TF_X1, 274+height_2, 17, 17)];
    if(_isRember){
        [_rememberPwdButton setImage:[UIImage imageNamed:@"select_button_s.png"] forState:UIControlStateNormal];
    }else{
        [_rememberPwdButton setImage:[UIImage imageNamed:@"select_button_n.png"] forState:UIControlStateNormal];
    }
    [_rememberPwdButton addTarget:self action:@selector(remeberAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loginIV addSubview:_rememberPwdButton];
    _rememberLabel = [[UILabel alloc] initWithFrame:CGRectMake(LB_x1, 274+height_2, 80, 17)];
    [_rememberLabel setBackgroundColor:[UIColor clearColor]];
    [_rememberLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_rememberLabel setTextColor:[UIColor whiteColor]];
    [_rememberLabel setText:@"记住密码"];
    [_loginIV addSubview:_rememberLabel];
    
    _autoLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_autoLoginButton setFrame:CGRectMake(TF_X1+155, 274+height_2, 17, 17)];
    if(_isAutoLogin){
        [_autoLoginButton setImage:[UIImage imageNamed:@"select_button_s.png"] forState:UIControlStateNormal];
    }else{
        [_autoLoginButton setImage:[UIImage imageNamed:@"select_button_n.png"] forState:UIControlStateNormal];
    }
    [_autoLoginButton addTarget:self action:@selector(autoLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loginIV addSubview:_autoLoginButton];
    UILabel *autoLogin = [[UILabel alloc]initWithFrame:CGRectMake(TF_X1+155+25, 274+height_2, 80, 17)];
    [autoLogin setBackgroundColor:[UIColor clearColor]];
    [autoLogin setFont:[UIFont boldSystemFontOfSize:15]];
    [autoLogin setTextColor:[UIColor whiteColor]];
    [autoLogin setText:@"自动登录"];
    [_loginIV addSubview:autoLogin];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(TF_X1, 310, 257, 34)];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [_loginIV addSubview:loginButton];
    
    
    UIImageView *regIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"regsiter.png"]];
    [regIV setFrame:CGRectMake(TF_X1+180, 374, 17, 17)];
    [regIV setUserInteractionEnabled:YES];
    [_loginIV addSubview:regIV];
    UILabel *registerLab = [[UILabel alloc]initWithFrame:CGRectMake(TF_X1+200, 374, 80, 17)];
    [registerLab setBackgroundColor:[UIColor clearColor]];
    [registerLab setFont:[UIFont boldSystemFontOfSize:15]];
    [registerLab setTextColor:[UIColor whiteColor]];
    [registerLab setText:@"注册"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(TF_X1+200, 374, 90, 27)];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(registervc:) forControlEvents:UIControlEventTouchUpInside];

    [_loginIV addSubview:btn];
    [_loginIV addSubview:registerLab];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    if (!checkUpate) {
        [self checkUpdate];
        checkUpate = true;
    }
}
- (void) checkUpdate
{
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
                                         TransferWithRequestDic:@{@"version":kVERSION}
                                         requesId:VERSION
                                         prompt:@"version"
                                         replaceId:nil
                                         success:^(id obj) {
                                             if([[obj objectForKey:@"rs"]intValue] == 0){//更新
                                                 // 启动浏览器去更新程序
                                                 // 注：这种机制也没有完全要求用户一定要更新程序，完全可以从浏览器切换回项目再登录。
                                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL]];
                                                 
                                             }else if([[obj objectForKey:@"rs"]intValue] == 1){
                                                 // 无需更新
                                               //  [[LKTipCenter defaultCenter] postDownTipWithMessage:@"您的程序已是最新版本" time:2];
                                                   [SVProgressHUD showSuccessWithStatus:@"已是最新版本"];
                                                 if ([UserDefaults boolForKey:kAUTOLOGIN]) {
                                                     [self loginAction:nil];
                                                 }
                                             }
                                         } failure:^(NSString *errMsg) {
                                             
                                         }];
    [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在检查更新" completeBlock:^(NSArray *operations) {
        
    }];    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数


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
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return  NO;
    }
    return YES;
}

/**
 *  跳转到首页
 */
-(void)homeView
{
    
    UITabBarController *homeTabBarController = [[UITabBarController alloc]init];
    
    //给的图片高度不是按照标准ios tabbar高度裁的 需要先将图片缩放
    UIGraphicsBeginImageContext(CGSizeMake(320, 49));
	[[UIImage imageNamed:@"footer"] drawInRect:CGRectMake(0,0,320,49)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    [homeTabBarController.tabBar setBackgroundImage:newImage];
    
    HomeViewController *homeController = [[HomeViewController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeController];
    homeController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:nil tag:0];
    [homeController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scroll_icon_s_1"] withFinishedUnselectedImage:[UIImage imageNamed:@"scroll_icon_n_1"]];
    homeController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 3, 7, 3);
    
    FullTextSearchViewController *searchController = [[FullTextSearchViewController alloc]init];
    UINavigationController *searchNav = [[UINavigationController alloc]initWithRootViewController:searchController];
    searchController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"搜索" image:nil tag:0];
    [searchController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scroll_icon_s_2"] withFinishedUnselectedImage:[UIImage imageNamed:@"scroll_icon_n_2"]];
    searchController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 3, 7, 3);
    
    PersonalCenterViewController *personalCenterController = [[PersonalCenterViewController alloc]init];
    UINavigationController *personNav = [[UINavigationController alloc]initWithRootViewController:personalCenterController];
    personalCenterController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"个人中心" image:nil tag:0];
    [personalCenterController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scroll_icon_s_3"] withFinishedUnselectedImage:[UIImage imageNamed:@"scroll_icon_n_3"]];
    personalCenterController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 3, 7, 7);
    
    
    CollectViewController *testController = [[CollectViewController alloc]init];
    UINavigationController *colectNav = [[UINavigationController alloc]initWithRootViewController:testController];
    testController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的收藏" image:nil tag:0];
    [testController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scroll_icon_s_4"] withFinishedUnselectedImage:[UIImage imageNamed:@"scroll_icon_n_4"]];
    testController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 3, 7, 3);
    
    
    MoreViewController *moreController = [[MoreViewController alloc]init];
    UINavigationController *moreNav = [[UINavigationController alloc]initWithRootViewController:moreController];
    moreController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"更多" image:nil tag:0];
    [moreController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scroll_icon_s_5"] withFinishedUnselectedImage:[UIImage imageNamed:@"scroll_icon_n_5"]];
    moreController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 3, 7, 3);
    
    homeTabBarController.viewControllers = @[homeNav,searchNav,personNav,colectNav,moreNav];
    
    [self.navigationController pushViewController:homeTabBarController animated:YES];
}
#pragma mark-
#pragma mark--按钮点击
/**
 *  注册按钮被点击
 *
 *  @param sender 】
 */
-(IBAction)registervc:(id)sender {
        RegisterViewController *regViewController = [[RegisterViewController alloc]init];
        [self.navigationController pushViewController:regViewController animated:YES];
}

/**
 *  记住密码
 *
 *  @param sender
 */
-(IBAction)remeberAction:(id)sender{
    _isRember = !_isRember;
    if(_isRember){
        [_rememberPwdButton setImage:[UIImage imageNamed:@"select_button_s.png"] forState:UIControlStateNormal];
        
    }else{
        [_rememberPwdButton setImage:[UIImage imageNamed:@"select_button_n.png"] forState:UIControlStateNormal];
    }
}

/**
 *  自动登录
 *
 *  @param sender
 */
-(IBAction)autoLoginAction:(id)sender{
    _isAutoLogin = !_isAutoLogin;
    if(_isAutoLogin){
        [_autoLoginButton setImage:[UIImage imageNamed:@"select_button_s.png"] forState:UIControlStateNormal];
        [self disableRemeberPWD];
    }else{
        [_autoLoginButton setImage:[UIImage imageNamed:@"select_button_n.png"] forState:UIControlStateNormal];
        [_rememberPwdButton setEnabled:YES];
        [_rememberLabel setTextColor:[UIColor whiteColor]];
    }
    
}

/**
 *  忘记密码
 */
-(void)disableRemeberPWD{
    [_rememberLabel setTextColor:[UIColor lightGrayColor]];
    [_rememberPwdButton setImage:[UIImage imageNamed:@"select_button_s.png"] forState:UIControlStateNormal];
    [_rememberPwdButton setEnabled:NO];
    _isRember = YES;
    
}

/**
 *  登陆
 *
 *  @param sender
 */
-(IBAction)loginAction:(id)sender{
    if(![self checkValue]){
        return;
    }
    NSString *userName = [_userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //保存页面的信息
    [UserDefaults setObject:userName forKey:KUSERNAME];
    [UserDefaults setBool:_isAutoLogin forKey:kAUTOLOGIN];
    [UserDefaults setBool:_isRember forKey:kREMEBERPWD];
    if(_isRember){
        [UserDefaults setObject:password forKey:kPASSWORD];
    }else{
        [UserDefaults setObject:@"" forKey:kPASSWORD];
    }
    [UserDefaults synchronize];//保存到disk
    
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,KUSERNAME,password,kPASSWORD, nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]
       TransferWithRequestDic:requestDic
       requesId:LOGIN
       prompt:@"hello"
       replaceId:nil
       success:^(id obj) {
            [AppDataCenter sharedAppDataCenter].sid = [obj objectForKey:@"sid"];
            if([[obj objectForKey:@"rs"]intValue] == 1){
//                HomeViewController *homeViewController = [[HomeViewController alloc]init];
//                [self.navigationController pushViewController:homeViewController animated:YES];
                [self homeView];
            }else if([[obj objectForKey:@"rs"]intValue] == 0){
                [SVProgressHUD showErrorWithStatus:@"用户名或密码错误！"];
            }
    } failure:^(NSString *errMsg) {
        
    }];
    [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在登录..." completeBlock:^(NSArray *operations) {
        
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
}

@end
