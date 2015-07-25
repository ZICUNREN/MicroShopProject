//
//  SYWinAddressModel.h
//  MicroShop
//
//  Created by siyue on 15/6/9.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYWinAddressModel : BaseModel

@property (copy,nonatomic)NSString *address;
@property (copy,nonatomic)NSString *name;
@property (copy,nonatomic)NSString *member_id;
@property (copy,nonatomic)NSString *address_id;
@property (copy,nonatomic)NSString *tel;

@end
