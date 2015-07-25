//
//  CHLayout.h
//  lib
//
//  Created by siyue on 14-10-24.
//  Copyright (c) 2014年 siyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHLayout : NSObject

//实现单例的函数
+(CHLayout *)sharedManager;
//移动x和y的距离
- (CGRect)modifyFrame:(CGRect)frame withX:(CGFloat)x withY:(CGFloat)y;
//往水平方向移动x距离
- (CGRect)modifyFrame:(CGRect)frame withX:(CGFloat)x;
//往垂直方向移动y的距离
- (CGRect)modifyFrame:(CGRect)frame withY:(CGFloat)y;
//改变frame长宽
- (CGRect)modifyFrame:(CGRect)frame withWidth:(CGFloat)width withHeight:(CGFloat)height;
//创建label
- (UILabel *)createLabelIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withText:(NSString *)text withTag:(NSInteger)tag;
//创建button
- (UIButton *)createButtonIn:(UIView *)view  withOrigin:(CGPoint)point withSize:(CGSize)size withTitle:(NSString *)title withBackImg:(NSString *)imgName withTag:(NSInteger)tag;
//创建view
- (UIView *)createViewIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size;
//创建imageView
- (UIImageView *)createImageViewIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withBackImg:(NSString *)imgName;
//创建textView
- (UITextView *)createTextViewIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withText:(NSString *)text withTag:(NSInteger)tag;
//创建textField
- (UITextField *)createTextFieldIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withText:(NSString *)text withTag:(NSInteger)tag;
//view根据子视图自适应
- (void)viewToFit:(UIView *)view withSpaceX:(CGFloat)spaceX withSpaceY:(CGFloat)spaceY;
//label根据文字自适应
- (void)fitsize:(UILabel *)textLabel;
//label水平方向适应文字
- (void)fitWidth:(UILabel *)textLabel;
//画线
- (void)drawLineIn:(UIView *)view withRect:(CGRect)frame color:(UIColor *)color imageName:(NSString *)imageName;
//给view设置圆角
- (void)setView:(UIView *)view withCornerRadius:(CGFloat)r;
//实线
- (void)drawLineIn:(UIView *)view withRect:(CGRect)frame withColor:(UIColor *)color;
//虚线
- (void)drawDashLineIn:(UIView *)view withRect:(CGRect)frame withColor:(UIColor *)color withSolidWidth:(CGFloat)solidwidth withHollowWidth:(CGFloat)hollowWidth;
- (void)drawLineIn:(UIView *)view withRect:(CGRect)frame withColor:(UIColor *)color withLengths:(CGFloat [])lengths withLengthNum:(NSInteger)num;
#pragma mark - animation
- (void)addAnimationForView:(UIView *)view withType:(NSString *)type withSubType:(NSString *)subType withDuration:(CFTimeInterval)time;

- (NSString*) getUUIDString;

@end
