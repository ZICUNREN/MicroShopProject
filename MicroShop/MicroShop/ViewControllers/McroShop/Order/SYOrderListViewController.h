//
//  SYOrderListViewController.h
//  MicroShop
//
//  Created by siyue on 15/7/15.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseViewController.h"

enum {
    all = 0,
    waitpay = 1,
    waitsend = 2,
    waitcom = 3
};

@interface SYOrderListViewController : BaseViewController

@property (assign,nonatomic)BOOL isMySelf;
@property (assign,nonatomic)NSInteger type;

@end
