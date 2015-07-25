//
//  BaseModel.h
//  MicroShop
//
//  Created by siyue on 15/4/23.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

-(NSArray *)formatArray:(NSArray *)array;
- (NSDictionary *)formatDic:(id)obj;

@end
