//
//  CollectViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-12-10.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：我的收藏
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/
#import "BaseViewController.h"
@class ContentModel;

@interface CollectViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) ContentModel *model;
@property (nonatomic) BOOL isCollect;

@property (nonatomic,strong) UITableView *mytableView;
@property (nonatomic,strong) NSMutableArray *myarray;




-(id) initWithFile:(ContentModel *) model;

@end
