//
//  SYActivityListModel.h
//  MicroShop
//
//  Created by siyue on 15/6/8.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYIndexActivityListModel : BaseModel

@property (copy,nonatomic)NSString *activity_id;
@property (copy,nonatomic)NSString *img;
@property (copy,nonatomic)NSString *index_pop_img;
@property (copy,nonatomic)NSString *order;
@property (copy,nonatomic)NSString *url;

@end
