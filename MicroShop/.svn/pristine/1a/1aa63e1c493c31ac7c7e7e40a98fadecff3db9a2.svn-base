//
//  CHTabScrollView.m
//  xTableView
//
//  Created by siyue on 15/5/27.
//  Copyright (c) 2015年 siyue. All rights reserved.
//

#import "CHTabScrollView.h"

#define HeadTableViewTag 0
#define MainTableViewTag 1

@interface CHTabScrollView() <UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *tabBgImgView_;
    NSInteger page_;    //当前页
    BOOL isDraging_;    //判断是否为手动拖动scrollView
    float lastContentOffset_;

}
@property(strong,nonatomic)UITableView *headTableView;
@property(strong,nonatomic)UITableView *mainTableView;

@property(strong,nonatomic)NSMutableArray *headWidthList;

@end

@implementation CHTabScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame withHeadLeftSpace:0];
    return self;
}

- (id)initWithFrame:(CGRect)frame withHeadLeftSpace:(CGFloat)headleftSpace
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.headHeight = 44;
        self.headFontSize = 14;
        self.headBackColor = [UIColor redColor];
        self.fontColor = [UIColor blackColor];
        self.tabBgImgName = @"tab_bg";
        isDraging_ = YES;
        self.headNum = 0;
        
        //头部
        self.headTableView = [[UITableView alloc] init];
        self.headTableView.frame = CGRectMake(0, 0, self.frame.size.width-headleftSpace, self.headHeight);
        self.headTableView.showsVerticalScrollIndicator = NO;
        self.headTableView.tag = HeadTableViewTag;
        self.headTableView.delegate = self;
        self.headTableView.dataSource = self;
        CGRect frame1 = self.headTableView.frame;
        self.headTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.headTableView.frame = frame1;
        self.headTableView.tableFooterView = [[UIView alloc] init];
        self.headTableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.headTableView];
        
        //主视图
        self.mainTableView = [[UITableView alloc] init];
        self.mainTableView.frame = CGRectMake(0, self.headHeight, self.frame.size.width, self.frame.size.height-self.headHeight);
        self.mainTableView.showsVerticalScrollIndicator = NO;
        self.mainTableView.tag = MainTableViewTag;
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        frame1 = self.self.mainTableView.frame;
        self.mainTableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
        self.mainTableView.frame = frame1;
        self.mainTableView.tableFooterView = [[UIView alloc] init];
        self.mainTableView.separatorColor = [UIColor clearColor];
        self.mainTableView.pagingEnabled = YES;
        [self addSubview:self.mainTableView];
    }
    return self;

}

#pragma  mark - init

- (void)setHeadNameList:(NSMutableArray *)headNameList
{
    _headNameList = headNameList;
    self.headWidthList = [[NSMutableArray alloc] init];
    
    for (NSString *headName in _headNameList) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:self.headFontSize];
        label.text = headName;
        [label sizeToFit];
        CGFloat width = label.frame.size.width+20;
        if (self.headNum>0) {
            width = self.headTableView.frame.size.width/self.headNum;
        }
        NSNumber *widthNum = [NSNumber numberWithFloat:width];
        [self.headWidthList addObject:widthNum];
    }
    
    NSNumber *widthNum = self.headWidthList[0];
    CGFloat width = widthNum.floatValue;
    tabBgImgView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.tabBgImgName]];
    //因为tableView经过旋转所以坐标要转换
    tabBgImgView_.frame = [self convertRect:CGRectMake(0, self.headHeight-2, width, 2)];
    [self.headTableView addSubview:tabBgImgView_];
    [self.headTableView reloadData];
    
}

- (void)setViewList:(NSMutableArray *)viewList
{
    _viewList = viewList;
    [self.mainTableView reloadData];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == HeadTableViewTag) {
        return self.headNameList.count;
    }
    else if (tableView.tag == MainTableViewTag) {
        return self.viewList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == HeadTableViewTag) {
        static NSString *cellIdentifier=@"tableViewCellIdentify";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger row = indexPath.row;
        
        NSNumber *widthNum = self.headWidthList[row];
        CGFloat width = widthNum.floatValue;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, self.headHeight)];
        label.text = self.headNameList[row];
        label.font = [UIFont systemFontOfSize:self.headFontSize];
        label.textColor = self.fontColor;
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        return cell;

    }
    else if (tableView.tag == MainTableViewTag) {
        static NSString *cellIdentifier=@"tableMainViewCellIdentify";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger row = indexPath.row;
        
        UIView *view = self.viewList[row];
        if (view!=nil) {
            [cell.contentView addSubview:view];
            
            //普通布局
            //view.frame = CGRectMake(0, 0, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height);
            
            //自动布局
            view.translatesAutoresizingMaskIntoConstraints = NO;
            NSDictionary *views = NSDictionaryOfVariableBindings(cell.contentView,view);
            NSDictionary *metrics = @{@"space":@0};
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-space-[view]-space-|" options:0 metrics:metrics views:views]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[view]-space-|" options:0 metrics:metrics views:views]];
        }
        
        
        return cell;

    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == HeadTableViewTag) {
        NSInteger row = indexPath.row;
        NSNumber *widthNum = self.headWidthList[row];
        CGFloat width = widthNum.floatValue;
        return width;
    }
    else if (tableView.tag == MainTableViewTag) {
        return self.frame.size.width;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==HeadTableViewTag) {
        isDraging_ = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGRect currentHeadFrame = [self.headTableView rectForRowAtIndexPath:indexPath];//当前页对应的head1
        
        CGRect frame = tabBgImgView_.frame;
        frame.origin.y = currentHeadFrame.origin.y;
        frame.size.height = currentHeadFrame.size.height;
        
        tabBgImgView_.frame = frame;
        
        
        
        [UIView commitAnimations];
        
        NSInteger select = indexPath.row;
        [self.mainTableView setContentOffset:CGPointMake(0, select*self.frame.size.width) animated:YES];

    }
    
}

#pragma mark - scrollView delegete

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset_ = scrollView.contentOffset.y;
    isDraging_ = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==HeadTableViewTag) {
        return;
    }
    CGFloat x = self.mainTableView.contentOffset.y;
    if (!isDraging_) {
        return;
    }
    
    page_ = (x+self.frame.size.width/2)/self.frame.size.width;//取得当前页1，滑过一半算是下一页
    NSInteger page = x/self.frame.size.width;  //取得当前页2，滑完全部才算下一页
    
    //NSIndexPath *currentHeadIndexPath = [NSIndexPath indexPathForRow:page_ inSection:0];
    //CGRect currentHeadFrame = [self.headTableView rectForRowAtIndexPath:currentHeadIndexPath];//当前页对应的head1
    
    NSIndexPath *headIndexPath = [NSIndexPath indexPathForRow:page inSection:0];
    CGRect headFrame = [self.headTableView rectForRowAtIndexPath:headIndexPath];//当前页对应的head2
    
    CGFloat pageBtnWidth = headFrame.size.height;//当前head的宽

    
    NSInteger scrollDirection;
    if (lastContentOffset_ < scrollView.contentOffset.y) {//向上滚动,上拉
        scrollDirection = 0;
    }else{
        scrollDirection = 1;
    }
    
    CGRect frame = tabBgImgView_.frame;
    frame.size.height = headFrame.size.height; //此处坐标很乱，不知道以后还能不能看懂
    CGFloat pageX = headFrame.origin.y;
    
    CGFloat offsetYForHead = tabBgImgView_.frame.origin.y-self.headTableView.contentOffset.y;
    CGFloat adjustHeadOffset = 0;
    BOOL isNeedSetHeadOffset = NO;
    
    if (offsetYForHead>120&&scrollDirection==0) {//保证滑块在视图范围内
        adjustHeadOffset = self.headTableView.contentOffset.y+headFrame.size.height;
        if (adjustHeadOffset>=0&&adjustHeadOffset<=self.headTableView.contentSize.height-(self.headTableView.frame.size.width)) {

            isNeedSetHeadOffset = YES;
        }
        if (adjustHeadOffset>self.headTableView.contentSize.height-(self.headTableView.frame.size.width)) {
            adjustHeadOffset = self.headTableView.contentSize.height-(self.headTableView.frame.size.width);
            isNeedSetHeadOffset = YES;
        }
    }
    if (offsetYForHead<120&&scrollDirection==1) {
        adjustHeadOffset = self.headTableView.contentOffset.y-headFrame.size.height;
        if (adjustHeadOffset>=0&&adjustHeadOffset<=self.headTableView.contentSize.height-(self.headTableView.frame.size.width)) {
            isNeedSetHeadOffset = YES;
        }
        if (adjustHeadOffset<0) {
            adjustHeadOffset = 0;
            isNeedSetHeadOffset = YES;
        }
    }
    
    //调整背景滚动条的frame
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    frame.origin.y = pageX+(x-page*self.frame.size.width)/self.frame.size.width*pageBtnWidth;
    tabBgImgView_.frame = frame;
    if (isNeedSetHeadOffset) {
        [self.headTableView setContentOffset:CGPointMake(0, adjustHeadOffset)];
    }
    [UIView commitAnimations];
    
    
}

#pragma mark - Click

- (CGRect)convertRect:(CGRect)frame
{
    CGRect converFrame;
    converFrame.origin.x = frame.origin.x;
    converFrame.origin.y = self.headHeight-frame.origin.y;
    converFrame.size.width = frame.size.height;
    converFrame.size.height = frame.size.width;
    return converFrame;
}

@end
