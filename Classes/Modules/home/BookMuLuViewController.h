//
//  BookMuLuViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-11-5.
//  Copyright (c) 2013年 zfht. All rights reserved.
//
/*----------------------------------------------------------------
 // Copyright (C) 2002 深圳四方精创资讯股份有限公司
 // 版权所有。
 //
 // 文件功能描述：图书列表页面
 
 // 创建标识：
 // 修改标识：
 // 修改日期：
 // 修改描述：
 //
 ----------------------------------------------------------------*/

#import "BaseViewController.h"

@interface BookMuLuViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSString *bookName;
@property (nonatomic,strong)UITableView *mytableView;

@property (nonatomic,strong)NSMutableArray *nodes;
@property (nonatomic,strong)NSMutableArray *displayArray;
@property (nonatomic)NSInteger indentation;


-(id) initWithBookName:(NSString *) bookName;


- (void)expandCollapseNode:(NSNotification *)notification;

- (void)fillDisplayArray;
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray;

- (void)fillNodesArray;


- (IBAction)expandAll:(id)sender;
- (IBAction)collapseAll:(id)sender;


- (NSArray *)fillChildrenForNode:(NSInteger)nodelevel  parentName:(NSString *)pname;

@end
