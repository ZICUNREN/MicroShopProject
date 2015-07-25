//
//  SYLoginIconManage.h
//  MicroShop
//
//  Created by siyue on 15/4/30.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHFileManager.h"

@interface SYLoginIconManage : NSObject

+(id)sharedManager;
- (UIImage *)getUserIconWithUserName:(NSString *)userName;
- (void)saveUserIconWithURL:(NSString *)url withUserName:(NSString *)userName;

- (void)saveUserName:(NSString *)userName;
- (NSString *)getCurentUserName;

@end
