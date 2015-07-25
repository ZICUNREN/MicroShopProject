//
//  UIViewController+Share.h
//  SYProject
//
//  Created by siyue on 14/12/6.
//  Copyright (c) 2014年 com.siyue.liuxn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>

@interface UIViewController (Share)
- (void) shareAllButtonClickHandler:(NSString *) content withTitle:(NSString *)title url:(NSString *) urlStr image:(id<ISSCAttachment>)image withId:(NSString *)id;

- (void) shareAllButtonClickHandler:(NSString *) content withTitle:(NSString *)title url:(NSString *) urlStr image:(id<ISSCAttachment>)image withId:(NSString *)articleId isActive:(BOOL)isActive;

- (void)shareLoginWithType:(ShareType)type result:(void(^)(NSDictionary *result))resultBlock;//第三方登录
- (void)shareCancelAuthWithType:(ShareType)type;//第三方注销

- (void)refreshWeb;

@end
