//
//  RegisterViewController.m
//  ZFManual4iphone
//
//  Created by zfht on 13-10-26.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomeViewController.h"
#define TF_X   33
#define TF_W   20
#define FONT_W 30   

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize userTF = _userTF;
@synthesize pwdTF = _pwdTF;
@synthesize phoneTF = _phoneTF;
@synthesize regIV = _regIV;
@synthesize isAgree = _isAgree;
@synthesize agreeIB = _agreeIB;

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
    self.navigationItem.title = @"注 册";
    [ApplicationDelegate.rootNavigationController setNavigationBarHidden:YES animated:YES ];

    float height = 480.0f;
    float height_2 = 0.0f;
    if(iPhone5){
        height = 568.0f;
        height_2 = 20.0f;
    }
    _regIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320,height)];
    [_regIV setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"reg_bg.png"]]];
     [_regIV setUserInteractionEnabled:YES];
     [self.view addSubview:_regIV];
    
    UIImageView *username = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"username.png"]];
    [username setFrame:CGRectMake(TF_X,100, 257, 34)];
    [username setUserInteractionEnabled:YES];
    [_regIV addSubview:username];
    _userTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X+FONT_W, 100, 227, 34)];
    _userTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userTF.delegate = self;
    [_userTF setPlaceholder:@"请输入用户名"];
    [_userTF setFont:[UIFont boldSystemFontOfSize:15]];
    _userTF.returnKeyType = UIReturnKeyDone;
    [_regIV addSubview:_userTF];
    
    UIImageView *phoneIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone.png"]];
    [phoneIV setFrame:CGRectMake(TF_X,134+TF_W, 257, 34)];
    [phoneIV setUserInteractionEnabled:YES];
    [_regIV addSubview:phoneIV];
    _phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X+FONT_W,134+TF_W, 227, 34)];
    _phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneTF.delegate = self;
    [_phoneTF setPlaceholder:@"请输入电话号码"];
    [_phoneTF setFont:[UIFont boldSystemFontOfSize:15]];
    _phoneTF.returnKeyType = UIReturnKeyDone;
    [_regIV addSubview:_phoneTF];
    
    UIImageView *pwd = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password.png"]];
    [pwd setFrame:CGRectMake(TF_X,183+TF_W, 257, 34)];
    [pwd setUserInteractionEnabled:YES];
    [_regIV addSubview:pwd];
    _pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(TF_X+FONT_W, 183+TF_W, 227, 34)];
    _pwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdTF.delegate = self;
    [_pwdTF setPlaceholder:@"请输入密码"];
    [_pwdTF setSecureTextEntry:YES];
    [_pwdTF setFont:[UIFont boldSystemFontOfSize:15]];
    _pwdTF.returnKeyType = UIReturnKeyDone;
    [_regIV addSubview:_pwdTF];
    
    _agreeIB = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeIB setFrame:CGRectMake(TF_X, 234+TF_W, 17, 17)];
    if(_isAgree){
        [_agreeIB setImage:[UIImage imageNamed:@"select_button_s.png"] forState:UIControlStateNormal];
    }else{
        [_agreeIB setImage:[UIImage imageNamed:@"select_button_n.png"] forState:UIControlStateNormal];
    }
    [_agreeIB addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_regIV addSubview:_agreeIB];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(TF_X+20, 234+TF_W, 260, 17)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:@"同意《执法手册服务协议》"];
    [_regIV addSubview:label];
    
    UIButton *regbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [regbutton setFrame:CGRectMake(TF_X, 271+TF_W, 257, 34)];
    [regbutton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    [regbutton setTitle:@"注 册" forState:UIControlStateNormal];
    [regbutton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [_regIV addSubview:regbutton];
        
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    }else if([@"" isEqualToString:[_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]){
        [SVProgressHUD showErrorWithStatus:@"电话号码不能为空"];
        return  NO;
    }else if(!_isAgree){
        [SVProgressHUD showErrorWithStatus:@"请接受服务条款"];
        return  NO;
    }
    return YES;
}


#pragma mark-
#pragma mark--按钮点击事件

/**
 *  同意协议
 *
 *  @param sender
 */
-(IBAction)agreeAction:(id)sender{
    _isAgree = !_isAgree;
    if(_isAgree){
        [_agreeIB setImage:[UIImage imageNamed:@"select_button_s.png"] forState:UIControlStateNormal];
    }else{
        [_agreeIB setImage:[UIImage imageNamed:@"select_button_n.png"] forState:UIControlStateNormal];
    }
}

/**
 *  点击注册
 *
 *  @param sender 
 */
-(IBAction)registerAction:(id)sender{
    if(![self checkValue]){
        return;
    }
    NSString *userName = [_userTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_pwdTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     NSString *phone = [_phoneTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDictionary *requestDic = [[NSDictionary alloc]initWithObjectsAndKeys:userName,@"username",password,@"password", phone,@"phone",nil];
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer]TransferWithRequestDic:requestDic requesId:REGISTER prompt:nil replaceId:nil success:^(id obj) {
        [AppDataCenter sharedAppDataCenter].sid = [obj objectForKey:@"sid"];
        if([[obj objectForKey:@"rs"]intValue]== 1){
            HomeViewController *homeViewController = [[HomeViewController alloc]init];
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:homeViewController animated:YES];
        }else if([[obj objectForKey:@"rs"]intValue] == 0){
            [SVProgressHUD showErrorWithStatus:@"注册失败！"];
        }
    } failure:^(NSString *errMsg) {
        
    }];
    [[Transfer sharedTransfer]doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在注册..." completeBlock:^(NSArray *operations) {
        
    }];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    [_pwdTF resignFirstResponder];
}

@end
