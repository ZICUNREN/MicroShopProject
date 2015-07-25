//
//  UITableView+CHRefresh.m
//  MicroShop
//
//  Created by siyue on 15/6/23.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "UITableView+CHRefresh.h"
#import "MJRefresh.h"

@implementation UITableView (CHRefresh)

- (void)addHeaderWithCallback:(HeadBlock)headBlock
{
    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (headBlock!=nil) {
            headBlock();
        }
    }];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.header;
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}

- (void)addFooterWithCallback:(FootBlock)footBlock
{
    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        if (footBlock!=nil) {
            footBlock();
        }
    }];
    
    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.footer;
    footer.refreshingTitleHidden = YES;
}

- (void)headerBeginRefreshing
{
    [self.header beginRefreshing];
}

- (void)endRefreshing
{
    [self.header endRefreshing];
    [self.footer endRefreshing];
}

- (void)loadAll
{
    [self.footer noticeNoMoreData];
}

@end
