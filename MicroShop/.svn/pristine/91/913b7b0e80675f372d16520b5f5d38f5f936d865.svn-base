//
//  CHTextShow.m
//  MicroShop
//
//  Created by siyue on 15/6/12.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "CHTextShow.h"
#import "CHLayout.h"

@implementation CHTextShow
{
    UIView *view_;
}

+(id)sharedManager
{
    static CHTextShow *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[CHTextShow alloc] init];
    });
    return sharedManager;
}

- (void)showBtnText:(NSString *)content withImage:(UIImage *)image inView:(UIView *)view delay:(NSInteger)sec
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, ScreenWidth-20, (ScreenWidth-20))];
    imageView.image = image;
    //imageView.backgroundColor = [UIColor yellowColor];
    [backView addSubview:imageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imageView.frame.size.height+imageView.frame.origin.y, view.frame.size.width-20, 100)];
    label.font = [UIFont boldSystemFontOfSize:24];
    label.backgroundColor = [UIColor whiteColor];
    label.text = content;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    [backView addSubview:label];
    [[CHLayout sharedManager] fitsize:label];
    
    [view addSubview:backView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [backView addSubview:button];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self performSelector:@selector(deleteView:) withObject:backView afterDelay:sec];
    
    view_ = backView;
}

- (void)deleteView:(UIView *)view
{
    [view removeFromSuperview];
    if (self.didClick!=nil) {
        self.didClick();
    }
}

- (void)btnClick:(id)sender
{
    if (self.didClick!=nil) {
        self.didClick();
    }
    [view_ removeFromSuperview];
}


@end
