//
//  CHCountDown.m
//  MicroShop
//
//  Created by siyue on 15/6/3.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "CHCountDown.h"

@interface CHCountDown()

@property(strong,nonatomic)UILabel *hLabel;
@property(strong,nonatomic)UILabel *mLabel;
@property(strong,nonatomic)UILabel *sLabel;

@property(nonatomic)NSInteger stamp;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation CHCountDown

+(id)sharedManager
{
    static CHCountDown *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[CHCountDown alloc] init];
    });
    return sharedManager;
}


- (NSTimer *)setCountDownWithHourLabel:(UILabel *)hLabel withMinLabel:(UILabel *)mLabel withSecLabel:(UILabel *)sLabel withtimestamp:(NSInteger)stamp
{
    self.hLabel = hLabel;
    self.mLabel = mLabel;
    self.sLabel = sLabel;
    self.stamp = stamp;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    return self.timer;
}

- (void)timerFired:(NSTimer *)timer
{
    self.stamp--;
    
    NSInteger hour = self.stamp/3600;
    NSInteger min = self.stamp%3600/60;
    NSInteger sec = self.stamp%3600%60;
    self.hLabel.text = [NSString stringWithFormat:@"%li",(long)hour];
    self.mLabel.text = [NSString stringWithFormat:@"%li",(long)min];
    self.sLabel.text = [NSString stringWithFormat:@"%li",(long)sec];
}


@end
