//
//  SYNewUserModel.m
//  MicroShop
//
//  Created by siyue on 15/4/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYNewUserModel.h"

@implementation SYNewUserModel

- (id)init {
    self = [super init];
    if (self) {
        self.imgURL = @"";
        self.userName = @"";
        self.uuserName = @"";
        self.joinTime = @"";
        self.shareMoney = @"";
        self.remainMoney = @"";
    }
    return self;
}

@end
