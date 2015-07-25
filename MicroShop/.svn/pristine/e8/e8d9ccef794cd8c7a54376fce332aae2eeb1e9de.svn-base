//
//  CHDropView.h
//  SYProject
//
//  Created by siyue on 15-3-19.
//  Copyright (c) 2015年 com.siyue.liuxn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDropModel.h"
@class CHDropTableView;

@interface CHDropView : UIView

@property (nonatomic,strong)NSArray *dropModelList;

@property (nonatomic,strong)void (^didSelect)(NSInteger,NSInteger);

//可选参数
@property (nonatomic,assign)CGRect topDropTableViewFrame;
@property (nonatomic,assign)CGRect secDropTableViewFrame;
@property (nonatomic,assign)NSInteger defaultTopSelect;
@property (nonatomic,assign)NSInteger defaultSecSelect;
@property (nonatomic,strong)UIColor *topBackGroundColor; //一级菜单背景颜色
@property (nonatomic,strong)UIColor *secBackGroundColor; //二级菜单背景颜色

@end
