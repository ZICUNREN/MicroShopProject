//
//  SYActiveHtmlViewController.h
//  MicroShop
//
//  Created by siyue on 15/6/8.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseViewController.h"

@interface SYActiveHtmlViewController : BaseViewController

@property(strong,nonatomic)NSString *url;
@property(strong,nonatomic)NSString *navTitle;

@property(nonatomic)BOOL isRegister;

@property (strong,nonatomic)void (^didLogin)(NSDictionary *result);
@property (strong,nonatomic)void (^didBack)();

@end
