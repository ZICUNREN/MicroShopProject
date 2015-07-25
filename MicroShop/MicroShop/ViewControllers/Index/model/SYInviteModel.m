//
//  SYInviteModel.m
//  MicroShop
//
//  Created by siyue on 15/4/23.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYInviteModel.h"

@implementation SYInviteModel

- (id)init {
    self = [super init];
    if (self) {
        self.imgURL = @"";
        self.userName = @"";
        self.storeName = @"";
        self.visitorNum = @"";
        self.storeId = @"";
    }
    return self;
}

@end
