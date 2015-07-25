//
//  SYWebURLModel.m
//  MicroShop
//
//  Created by siyue on 15/4/29.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYWebURLModel.h"

@implementation SYWebURLModel

- (id)init {
    self = [super init];
    if (self) {
        //微店
        self.micro_shopIndex_URL = @"";
        self.micro_goodsClass_URL = @"";
        self.micro_statistics_URL = @"";
        self.micro_spread_URL = @"";
        self.micro_income_URL = @"";
        self.micro_mySelf_URL = @"";
        self.micro_orderSelf_URL = @"";
        self.micro_sellGoods_URL = @"";
        self.micro_orderIndex_URL = @"";
        
        //货源
        self.supply_brand_List = @"";
        self.supply_By_product = @"";
        
        //首页
        self.Index_UserCenter_URL = @"";
        self.Index_Help_URL = @"";
        
        //推广
        self.Spread_Good_Detail = @"";
    }
    return self;
}


@end
