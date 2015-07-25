//
//  CHLayout.m
//  lib
//
//  Created by siyue on 14-10-24.
//  Copyright (c) 2014年 siyue. All rights reserved.
//

#import "CHLayout.h"

@implementation CHLayout

+(CHLayout *)sharedManager
{
    static CHLayout *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[CHLayout alloc] init];
    });
    return sharedManager;
}

//移动x和y的距离
- (CGRect)modifyFrame:(CGRect)frame withX:(CGFloat)x withY:(CGFloat)y
{
    frame.origin.x = frame.origin.x + x;
    frame.origin.y = frame.origin.y + y;
    return frame;
}

//往水平方向移动x距离
- (CGRect)modifyFrame:(CGRect)frame withX:(CGFloat)x
{
    frame.origin.x = frame.origin.x + x;
    return frame;
}

//往垂直方向移动y的距离
- (CGRect)modifyFrame:(CGRect)frame withY:(CGFloat)y
{
    frame.origin.y = frame.origin.y + y;
    return frame;
}

//改变frame长宽
- (CGRect)modifyFrame:(CGRect)frame withWidth:(CGFloat)width withHeight:(CGFloat)height
{
    frame.size.width = frame.size.width + width;
    frame.size.height = frame.size.height + height;
    if (frame.size.width<0) {
        frame.size.width = 0;
    }
    if (frame.size.height<0) {
        frame.size.height = 0;
    }
    return frame;
}

//创建label
- (UILabel *)createLabelIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withText:(NSString *)text withTag:(NSInteger)tag
{
    CGRect frame;
    frame.origin = point;
    frame.size = size;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.tag = tag;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [view addSubview:label];
    return label;
}

//创建button
- (UIButton *)createButtonIn:(UIView *)view  withOrigin:(CGPoint)point withSize:(CGSize)size withTitle:(NSString *)title withBackImg:(NSString *)imgName withTag:(NSInteger)tag
{
    CGRect frame;
    frame.origin = point;
    frame.size = size;
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (!([imgName isEqualToString:@""]||imgName==nil)) {
        UIImage *image = [UIImage imageNamed:imgName];
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    button.tag = tag;
    [view addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    return button;
}

//创建view
- (UIView *)createViewIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = point;
    frame.size = size;
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    [view addSubview:tempView];
    return tempView;
}

//创建imageView
- (UIImageView *)createImageViewIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withBackImg:(NSString *)imgName
{
    CGRect frame;
    frame.origin = point;
    frame.size = size;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (!([imgName isEqualToString:@""]||imgName==nil)) {
        imageView.image = [UIImage imageNamed:imgName];
    }
    [view addSubview:imageView];
    return imageView;
}

//创建textView
- (UITextView *)createTextViewIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withText:(NSString *)text withTag:(NSInteger)tag
{
    CGRect frame;
    frame.origin = point;
    frame.size = size;
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.tag = tag;
    textView.text = text;
    [view addSubview:textView];
    return textView;
}

//创建textField
- (UITextField *)createTextFieldIn:(UIView *)view withOrigin:(CGPoint)point withSize:(CGSize)size withText:(NSString *)text withTag:(NSInteger)tag
{
    CGRect frame;
    frame.origin = point;
    frame.size = size;
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.tag = tag;
    textField.text = text;
    [view addSubview:textField];
    return textField;

}

//view根据子视图自适应
- (void)viewToFit:(UIView *)view withSpaceX:(CGFloat)spaceX withSpaceY:(CGFloat)spaceY
{
    CGFloat x= 0;
    CGFloat y = 0;
    for (UIView *subView in view.subviews) {
        if (subView.frame.origin.x+subView.frame.size.width>x) {
            x = subView.frame.origin.x+subView.frame.size.width;
        }
        if (subView.frame.origin.y+subView.frame.size.height>y) {
            y = subView.frame.origin.y+subView.frame.size.height;
        }
    }
    CGRect frame = view.frame;
    frame.size.width = x + spaceX;
    frame.size.height = y + spaceY;
    view.frame = frame;
}

//label根据文字自适应
- (void)fitsize:(UILabel *)textLabel
{
    [textLabel setNumberOfLines:0];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = CGSizeMake(textLabel.frame.size.width, MAXFLOAT);
    
    
    
    
    
    //CGSize labelsize = [textLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:textLabel.font} context:nil].size;
    
    //NSMutableAttributedString *attributedStr = [self attributedStringWithStr:textLabel.text withFont:textLabel.font withLineSpacing:10];
    CGSize labelsize = [textLabel.attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    CGRect frame = textLabel.frame;
    frame.size.height = labelsize.height;
    textLabel.frame = frame;
}

- (NSMutableAttributedString *)attributedStringWithStr:(NSString *)string withFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName:font}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //[paragraphStyle setLineSpacing:lineSpacing];
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    return attributedStr;
}

//label水平方向适应文字
- (void)fitWidth:(UILabel *)textLabel
{
    CGRect frame = textLabel.frame;
    [textLabel sizeToFit];
    frame.size.width = textLabel.frame.size.width;
    textLabel.frame = frame;
}

//画线
- (void)drawLineIn:(UIView *)view withRect:(CGRect)frame color:(UIColor *)color imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    if (!([imageName isEqualToString:@""]||imageName==nil)) {
         imageView.image = [UIImage imageNamed:imageName];
    }
    if (color == NULL) {
        imageView.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        imageView.backgroundColor = color;
    }
    [view addSubview:imageView];
}

//给view设置圆角
- (void)setView:(UIView *)view withCornerRadius:(CGFloat)r
{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = r;
}

//实线
- (void)drawLineIn:(UIView *)view withRect:(CGRect)frame withColor:(UIColor *)color
{
    [self drawLineIn:view withRect:frame withColor:color withLengths:nil withLengthNum:0];
}
//虚线
- (void)drawDashLineIn:(UIView *)view withRect:(CGRect)frame withColor:(UIColor *)color withSolidWidth:(CGFloat)solidwidth withHollowWidth:(CGFloat)hollowWidth
{
    CGFloat lengths[] = {solidwidth,hollowWidth};
    [self drawLineIn:view withRect:frame withColor:color withLengths:lengths withLengthNum:2];
}

- (void)drawLineIn:(UIView *)view withRect:(CGRect)frame withColor:(UIColor *)color withLengths:(CGFloat [])lengths withLengthNum:(NSInteger)num
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [view addSubview:imageView];
    float lineWidth;
    float beginX;
    float beginY;
    float endX;
    float endY;
    if (frame.size.width>frame.size.height) {
        lineWidth = frame.size.height;
        beginX = 0;
        beginY = lineWidth/2;
        endX = frame.size.width;
        endY = beginY;
    }
    else {
        lineWidth = frame.size.width;
        beginX = lineWidth/2;
        beginY = 0;
        endX = beginX;
        endY = frame.size.height;
    }
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineWidth);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    if (lengths!=nil) {
        CGContextSetLineDash(UIGraphicsGetCurrentContext(), 0, lengths, num);
        
    }
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),beginX, beginY);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endX, endY);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - animation

- (void)addAnimationForView:(UIView *)view withType:(NSString *)type withSubType:(NSString *)subType withDuration:(CFTimeInterval)time
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:time];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setType:type];
    [animation setSubtype: subType];
    [view.layer addAnimation:animation forKey:@"Reveal"];
}

- (NSString*) getUUIDString

{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
    
}

@end
