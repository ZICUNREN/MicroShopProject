//
//  ViewController.h
//  MicroShop
//
//  Created by bladeapp on 15/3/9.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "EGORefreshTableHeaderView.h"


@interface ViewController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) JSContext *context;


@end

