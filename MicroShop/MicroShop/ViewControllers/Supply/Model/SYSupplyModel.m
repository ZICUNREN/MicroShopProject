//
//  SYSupplyModel.m
//  MicroShop
//
//  Created by siyue on 15/4/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYSupplyModel.h"

@implementation SYSupplyModel

- (id)init {
    self = [super init];
    if (self) {
        self.storeName = @"";
        self.sellNum = @"";
        self.imgURL = @"";
        self.storeId = @"";
    }
    return self;
}

@end
