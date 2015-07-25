//
//  SYRegisterViewController.h
//  MicroShop
//
//  Created by siyue on 15/5/30.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseViewController.h"

@interface SYRegisterViewController : UIViewController

@property (strong,nonatomic)void (^didRegister)(NSString *userName,NSString *password);
@property (strong,nonatomic)void (^didBack)();

@end
