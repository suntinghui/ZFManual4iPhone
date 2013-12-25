//
//  FullTextSearchViewController.h
//  ZFManual4iphone
//
//  Created by zfht on 13-12-1.
//  Copyright (c) 2013年 zfht. All rights reserved.
//

#import "BaseViewController.h"

@interface FullTextSearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *mytableView;
@property (nonatomic,strong) NSMutableArray *myarray;
@property (nonatomic,strong) NSString *searchWord;
@property (nonatomic,retain) UISearchBar *mySearchBar;

@end
