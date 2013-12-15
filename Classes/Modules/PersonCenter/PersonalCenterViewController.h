//
//  PersonalCenterViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-11-3.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：个人中心页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "BaseViewController.h"

@interface PersonalCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) BOOL isLeft;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)NSMutableArray *rightArray;
@property (nonatomic,strong)UIImageView *leftView;
@property (nonatomic,strong)UITableView *rightTView;

@property (nonatomic,strong) UITextField *userTF;
@property (nonatomic,strong) UITextField *pwdTF;
@property (nonatomic,strong) UITextField *pwd2TF;

@property (nonatomic,strong)UILabel *grzlLab;
@property (nonatomic,strong)UIImageView *imagev;
@property (nonatomic,strong)UILabel *grzlLabr;
@property (nonatomic,strong)UIImageView *imagevr;

@property (nonatomic) int firstcount;


@end
