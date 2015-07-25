//
//  SYShopInfoModel.m
//  MicroShop
//
//  Created by siyue on 15/5/4.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYShopInfoModel.h"

@implementation SYShopInfoModel

- (id)init {
    self = [super init];
    if (self) {
        self.storeName = @"";
        self.iconURL = @"";
        self.storeDetail = @"";
        self.bigIconURL = @"";
        self.store_weixin = @"";
        self.store_qq = @"";
        self.store_tel = @"";
    }
    return self;
}

@end
