//
//  SYActiveListModel.h
//  MicroShop
//
//  Created by siyue on 15/6/11.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYActiveListModel : BaseModel

@property (copy,nonatomic)NSString *cover;
@property (copy,nonatomic)NSString *activeId;
@property (copy,nonatomic)NSString *starttime;
@property (copy,nonatomic)NSString *surplus_win;
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *remarks;
@property (copy,nonatomic)NSString *is_start;
@property (copy,nonatomic)NSString *is_over;

@end
