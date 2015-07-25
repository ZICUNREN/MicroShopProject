//
//  SYGettingWebURLData.m
//  MicroShop
//
//  Created by siyue on 15/4/29.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYGettingWebURLData.h"

@implementation SYGettingWebURLData

+(id)sharedManager
{
    static SYGettingWebURLData *sharedManager;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        sharedManager = [[SYGettingWebURLData alloc] init];
    });
    return sharedManager;
}

-(SYWebURLModel *)getWebURLData
{
    SYWebURLModel *webURLModel = [[SYWebURLModel alloc] init];
    NSDictionary *webURLData = [[NSUserDefaults standardUserDefaults] objectForKey:@"webURLData"];
    if ([webURLData isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    //微店
    webURLModel.micro_shopIndex_URL = [NSString stringWithFormat:@"%@",webURLData[@"shop_index"]];
    webURLModel.micro_goodsClass_URL = [NSString stringWithFormat:@"%@",webURLData[@"index_goods_class"]];
    webURLModel.micro_statistics_URL = [NSString stringWithFormat:@"%@",webURLData[@"index_statistics"]];
    webURLModel.micro_spread_URL = [NSString stringWithFormat:@"%@",webURLData[@"index_spread"]];
    webURLModel.micro_income_URL = [NSString stringWithFormat:@"%@",webURLData[@"index_income"]];
    webURLModel.micro_mySelf_URL = [NSString stringWithFormat:@"%@",webURLData[@"index_mySelf"]];
    webURLModel.micro_orderSelf_URL = [NSString stringWithFormat:@"%@",webURLData[@"index_order_self"]];
    webURLModel.micro_sellGoods_URL = [NSString stringWithFormat:@"%@",webURLData[@"my_sell_goods"]];
    webURLModel.micro_orderIndex_URL = [NSString stringWithFormat:@"%@",webURLData[@"order_index"]];
    
    //货源
    webURLModel.supply_brand_List = [NSString stringWithFormat:@"%@",webURLData[@"good_source_brand"]];
    webURLModel.supply_By_product = [NSString stringWithFormat:@"%@",webURLData[@"good_source_goods"]];
    
    //首页
    webURLModel.Index_UserCenter_URL = [NSString stringWithFormat:@"%@",webURLData[@"member_index"]];
    webURLModel.Index_Help_URL = [NSString stringWithFormat:@"%@",webURLData[@"index_help"]];
    
    //推广
    webURLModel.Spread_Good_Detail = [NSString stringWithFormat:@"%@",webURLData[@"good_source_goodsDetails"]];
    
    return webURLModel;
}

@end
