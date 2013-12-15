//
//  HomeViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-10-30.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：手册列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *mytableView;
@property (nonatomic,strong) NSMutableArray *myarray;

@property (nonatomic,strong) UITableView *booktableView;
@property (nonatomic,strong) NSMutableArray *bookarray;

@property (nonatomic,strong) UIImageView *imageView;

@end
