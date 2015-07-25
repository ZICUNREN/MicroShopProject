//
//  SYAwardListModel.h
//  MicroShop
//
//  Created by siyue on 15/6/2.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYAwardListModel : BaseModel

@property (copy,nonatomic)NSString *activeId;
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *remarks;
@property (copy,nonatomic)NSString *start_countdown; //开始倒计时ms
@property (copy,nonatomic)NSString *surplus_time;//剩余时间ms
@property (copy,nonatomic)NSString *pic;
@property (copy,nonatomic)NSString *surplus_win;//剩余名额
@property (copy,nonatomic)NSString *is_start;//是否已经开始

@end
