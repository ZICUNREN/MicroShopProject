//
//  CHDropTableView.m
//  SYProject
//
//  Created by siyue on 15-3-19.
//  Copyright (c) 2015年 com.siyue.liuxn. All rights reserved.
//

#import "CHDropTableView.h"

@implementation CHDropTableView

#pragma setting

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        //cell分割线设置
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    //self.separatorColor = [UIColor clearColor];
    [self setSeparatorInset:UIEdgeInsetsZero];
    if (self.delegate==nil) {
        self.delegate = self;
    }
    if (self.dataSource==nil) {
        self.dataSource = self;
    }
    [self reloadData];
}

- (void)setTableColor:(UIColor *)tableColor
{
    _tableColor = tableColor;
    self.backgroundColor = _tableColor;
}

- (void)setCellColor:(UIColor *)cellColor
{
    _cellColor = cellColor;
    [self reloadData];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"tableViewCellIdentify";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    NSInteger row = indexPath.row;

    //箭头
    if (self.subItemNums.count>row) {
        if ([self.subItemNums[row] integerValue]>0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.000];
    NSString *categoryName = self.items[row];
    cell.textLabel.text = categoryName;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.525 alpha:1.000];
    cell.contentView.backgroundColor = self.cellColor;
    cell.backgroundColor = self.cellColor;
    
    //横线
    //[layout drawLineIn:cell.contentView withRect:CGRectMake(0, cell.contentView.frame.size.height-1, ScreenWidth, 0.5) withColor:[UIColor colorWithWhite:0.7 alpha:1.000]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelect!=nil) {
        self.didSelect(indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //分割线的设置
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
