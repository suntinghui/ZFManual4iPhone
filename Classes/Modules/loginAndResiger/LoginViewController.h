//
//  LoginViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-18.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：登陆页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UIAlertViewDelegate>

@property (nonatomic,strong) UITextField *userTF;           //用户名输入框
@property (nonatomic,strong) UITextField *pwdTF;            //密码输入框
@property (nonatomic,strong) UIButton *rememberPwdButton;
@property (nonatomic,strong) UILabel *rememberLabel;
@property (nonatomic,strong) UIButton *autoLoginButton;
@property (nonatomic,strong) UIImageView *loginIV;

@property (nonatomic,assign)BOOL isRember;                  //是否记住密码
@property (nonatomic,assign)BOOL isAutoLogin;               //是否自动登录

@end
