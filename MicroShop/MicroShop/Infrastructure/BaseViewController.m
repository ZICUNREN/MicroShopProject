//
//  BaseViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseViewController.h"
#import "SYLoginViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setReturnButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    if (isLogout) {
        return;
    }
    
    if (self.isLoginVC) {
        return;
    }
    
    if (!UserToken) {
        [self gotoLogin];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setReturnButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}

- (void)gotoLogin {
    isLogout = YES;
    SYLoginViewController *loginVC = [[SYLoginViewController alloc] initWithNibName:@"SYLoginViewController" bundle:nil];
    loginVC.fatherNavigationController = self.navigationController;
    loginVC.isLoginVC = YES;
    self.isLoginVC = YES;
    loginVC.fatherViewController = self;
    
    /*if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }*/
    
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
    
    /*[self.view.window addSubview:loginVC.view];
    CGRect frame = loginVC.view.frame;
    frame.size.width = ScreenWidth;
    frame.size.height = ScreenHeight;
    loginVC.view.frame = frame;
    
    self.navigationController.navigationBar.hidden = YES;
    [self addChildViewController:loginVC];
    loginVC.didLogin = ^(){
        
    };*/
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
