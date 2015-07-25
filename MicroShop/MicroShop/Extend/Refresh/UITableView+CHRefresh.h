//
//  UITableView+CHRefresh.h
//  MicroShop
//
//  Created by siyue on 15/6/23.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadBlock)();
typedef void(^FootBlock)();

@interface UITableView (CHRefresh)

- (void)addHeaderWithCallback:(HeadBlock)headBlock;
- (void)addFooterWithCallback:(FootBlock)footBlock;
- (void)headerBeginRefreshing;
- (void)endRefreshing;
- (void)loadAll;

@end
