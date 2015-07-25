//
//  MJExtensionConfig.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/22.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "SYAwardListModel.h"
#import "SYActivityAwardListModel.h"
#import "SYWinAddressModel.h"
#import "SYActiveListModel.h"
#import "SYGoodClassModel.h"

@implementation MJExtensionConfig
/**
 *  这个方法会在MJExtensionConfig加载进内存时调用一次
 */
+ (void)load
{
    [SYAwardListModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"activeId" : @"id",
                 };
    }];

    //award_id
    [SYActivityAwardListModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"award_id" : @"id",
                 };
    }];
    
    [SYWinAddressModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"address_id" : @"id",
                 };
    }];
    
    [SYActiveListModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"activeId" : @"id",
                 };
    }];
    
    [SYGoodClassModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"class_id" : @"id",
                 };
    }];

}
@end
