//
//  SYActivityScrollView.m
//  MicroShop
//
//  Created by siyue on 15/6/8.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYActivityScrollView.h"
#import "SYIndexActivityListModel.h"

@interface SYActivityScrollView ()

@end

@implementation SYActivityScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self!=nil) {
        self.pagingEnabled = YES;
        NSInteger num = self.activityList.count;
        self.contentSize = CGSizeMake(ScreenWidth*num, frame.size.height);
         self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)setActivityList:(NSArray *)activityList
{
    _activityList = activityList;
    NSInteger num = _activityList.count;
    self.contentSize = CGSizeMake(ScreenWidth*num, self.frame.size.height);
    
    for (NSInteger i=0;i<_activityList.count;i++) {
        SYIndexActivityListModel *activityListModel = _activityList[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, self.frame.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:activityListModel.img] placeholderImage:[UIImage imageNamed:@"pic_defualt"]];
        [self addSubview:imageView];
        
        //button
        UIButton *button = [[UIButton alloc] initWithFrame:imageView.frame];
        button.tag = i;
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    self.pageControl.numberOfPages = num;
}

- (void)btnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSInteger row = button.tag;
    if (self.didSelect!=nil) {
        self.didSelect(row);
    }
}

-(void)timerFired:(NSTimer *)timer{
    CGFloat x = self.contentOffset.x+self.frame.size.width;
    if (x>self.contentSize.width-self.frame.size.width) {
        x=0;
    }
    [self setContentOffset:CGPointMake(x, self.contentOffset.y) animated:YES];
    
    self.pageControl.currentPage = x/self.frame.size.width;
}

@end
