//
//  SYNewUserModel.h
//  MicroShop
//
//  Created by siyue on 15/4/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYNewUserModel : BaseModel

@property (strong,nonatomic)NSString *userName; //昵称
@property (strong,nonatomic)NSString *uuserName; //用户名
@property (strong,nonatomic)NSString *joinTime;
@property (strong,nonatomic)NSString *imgURL;

@property (strong,nonatomic)NSString *shareMoney;
@property (strong,nonatomic)NSString *remainMoney;

@end
