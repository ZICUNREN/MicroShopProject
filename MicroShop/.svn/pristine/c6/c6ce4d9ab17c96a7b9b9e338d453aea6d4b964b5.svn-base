//
//  CHTabScrollView.h
//  xTableView
//
//  Created by siyue on 15/5/27.
//  Copyright (c) 2015年 siyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTabScrollView : UIView

//可选参数
@property (nonatomic) float headHeight; //头部的高度
@property (nonatomic) float headFontSize; //头部的高度
@property (nonatomic,strong) UIColor *headBackColor; //头部底色
@property (nonatomic,strong) UIColor *fontColor;    //字体颜色
@property (nonatomic,strong) NSString *tabBgImgName;    //滚动条图标
@property (nonatomic)NSInteger headNum;//设置同时显示的标题数，设置这个值则默认每个标题宽度相等
- (id)initWithFrame:(CGRect)frame withHeadLeftSpace:(CGFloat)headleftSpace;

//必选参数
@property(nonatomic,strong)NSMutableArray *headNameList;//初始化头部(NSString)
@property(nonatomic,strong)NSMutableArray *viewList;//初始化主视图(view)

@end
