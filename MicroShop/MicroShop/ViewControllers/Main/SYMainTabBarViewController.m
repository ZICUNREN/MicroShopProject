//
//  SYMainTabBarViewController.m
//  MicroShop
//
//  Created by siyue on 15/4/22.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYMainTabBarViewController.h"
#import "SYStudyViewController.h"
#import "CHLayout.h"
#import "SYLoginViewController.h"

#define TITLECOLOR [UIColor colorWithRed:154.0/255.0 green:154.0/255.0 blue:154.0/255.0 alpha:1]
#define TITECOLORSELECT [UIColor colorWithRed:232.0/255.0 green:77.0/255.0 blue:18.0/255.0 alpha:1]
#define LINECOLOR [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1]

@interface SYMainTabBarViewController ()

@property (nonatomic, strong) UIImageView *tabBarView;
@property (nonatomic, strong) NSMutableArray *tabItems;
@property (nonatomic, strong) UIButton *selectTab;

@end

@implementation SYMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *key = [NSString stringWithFormat:@"&key=%@",UserToken];
    
    //NSLog(@"%@",key);
    
    [self initTabBarItem];
    
    /*if (UserToken) {
        [self initTabBarItem];
    }
    else {
        //[self initTabBarItem];
        [self gotoLogin];
    }*/
    
    //添加本地通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllView:) name:Notification_ReloadAllView object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoLogin {
    isLogout = YES;
    SYLoginViewController *loginVC = [[SYLoginViewController alloc] initWithNibName:@"SYLoginViewController" bundle:nil];
    loginVC.fatherNavigationController = self.navigationController;
    loginVC.fatherViewController = self;
    [self.view.window addSubview:loginVC.view];
    
    CGRect frame = loginVC.view.frame;
    frame.size.width = ScreenWidth;
    loginVC.view.frame = frame;
    
    
    loginVC.isLoginVC = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self addChildViewController:loginVC];
    self.tabBar.hidden = YES;
    loginVC.didLogin = ^(){
        self.tabBar.hidden = NO;
        [self initTabBarItem];
    };
}

- (void)initTabBarItem
{
    NSMutableArray *navArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.delegate = (id)self;
    for (UIView *view in self.tabBar.subviews) {
        [view removeFromSuperview];
    }
    self.navigationController.delegate = (id)self;
    
    //微店
    UIStoryboard *mcroShopStoryboard = [UIStoryboard storyboardWithName:@"McroShop" bundle:nil];
    BaseNavigationController *mcroShopNavVC = [mcroShopStoryboard instantiateViewControllerWithIdentifier:@"McroShopNavVC"];
    mcroShopNavVC.title = @"微店";
    [navArray addObject:mcroShopNavVC];
    
    //货源
    UIStoryboard *supplyStoryboard = [UIStoryboard storyboardWithName:@"Supply" bundle:nil];
    BaseNavigationController *supplyNavVC = [supplyStoryboard instantiateViewControllerWithIdentifier:@"SupplyNavVC"];
    supplyNavVC.title = @"货源";
    [navArray addObject:supplyNavVC];
    
    //首页
    UIStoryboard *indexStoryboard = [UIStoryboard storyboardWithName:@"Index" bundle:nil];
    BaseNavigationController *indexNavVC = [indexStoryboard instantiateViewControllerWithIdentifier:@"IndexNavVC"];
    indexNavVC.title = @"首页";
    [navArray addObject:indexNavVC];
    self.nav = indexNavVC;
    
    //推广
    UIStoryboard *studyStoryboard = [UIStoryboard storyboardWithName:@"Study" bundle:nil];
    BaseNavigationController *studyNavVC = [studyStoryboard instantiateViewControllerWithIdentifier:@"StudyNavVC"];
    studyNavVC.title = @"推广";
    [navArray addObject:studyNavVC];
    
    //动态
    UIStoryboard *spreadStoryboard = [UIStoryboard storyboardWithName:@"Spread" bundle:nil];
    BaseNavigationController *spreadNavVC = [spreadStoryboard instantiateViewControllerWithIdentifier:@"SpreadNavVC"];
    spreadNavVC.title = @"动态";
    [navArray addObject:spreadNavVC];
    
    
    self.viewControllers = navArray;
    
    //设置背景图片
    
    //设置背景图片
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabBg"];
    self.tabItems = [NSMutableArray arrayWithCapacity:navArray.count];
    self.tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    self.tabBarView.userInteractionEnabled = YES;
    [self.tabBar addSubview:self.tabBarView];

    
    NSArray *imgs = [NSArray arrayWithObjects:@"weidian_1",@"huoyuan_1",@"shouye_1",@"xuexi_1",@"tuiguang_1", nil];
    NSArray *imgs_on = [NSArray arrayWithObjects:@"weidian_2",@"huoyuan_2",@"shouye_2",@"xuexi_2",@"tuiguang_2", nil];
    
    //self.tabBarItem
    
    for (int i=0; i<self.viewControllers.count; i++) {
        //选中背景
        UIButton *tabView = [UIButton buttonWithType:UIButtonTypeCustom];
        tabView.frame = CGRectMake((ScreenWidth/self.viewControllers.count)*i, 0, (ScreenWidth/self.viewControllers.count), 49);
        [tabView addTarget:self action:@selector(onTabClick:) forControlEvents:UIControlEventTouchUpInside];
        tabView.tag = i;
        UIButton *img = [UIButton buttonWithType:UIButtonTypeCustom];
        img.userInteractionEnabled = NO;
        img.frame = CGRectMake((CGRectGetWidth(tabView.frame)-24)/2, 5, 24, 24);
        [img setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:imgs[i],i+1]] forState:UIControlStateNormal];
        [img setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:imgs_on[i],i+1]] forState:UIControlStateSelected];
        img.tag = 1001;
        UIButton *title = [UIButton buttonWithType:UIButtonTypeCustom];
        title.userInteractionEnabled = NO;
        title.frame = CGRectMake(0, 31, CGRectGetWidth(tabView.frame), 18);
        title.backgroundColor = [UIColor clearColor];
        title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        title.titleLabel.font = [UIFont systemFontOfSize:10];
        [title setTitleColor:TITLECOLOR forState:UIControlStateNormal];
        [title setTitleColor:TITECOLORSELECT forState:UIControlStateSelected];
        [title setTitle:((UIViewController*)self.viewControllers[i]).title forState:UIControlStateNormal];
        title.tag = 1002;
        //竖线
        tabView.backgroundColor = [UIColor whiteColor];
        [tabView addSubview:img];
        [tabView addSubview:title];
        [self.tabBar addSubview:tabView];
        [self.tabItems addObject:tabView];
    }
    
    self.selectedIndex = Defualt_Tab;
}

#pragma mark - Click

- (void)onTabClick:(id)sender{
    UIButton *button = (UIButton*)sender;
    NSInteger tag = button.tag;
    
    self.selectedIndex = tag;
}

#pragma mark - other

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    
    UIButton *tabView = self.tabItems[selectedIndex];
    [self setSelectTab:tabView];
}

-(void)setSelectTab:(UIButton *)selectTab{
    [self setTab:_selectTab selected:NO];
    [self setTab:selectTab selected:YES];
    
    _selectTab = selectTab;
}

- (void)setTab:(UIButton*)tabView selected:(BOOL)flag{
    UIButton *img = (UIButton*)[tabView viewWithTag:1001];
    UIButton *title = (UIButton*)[tabView viewWithTag:1002];
    tabView.selected = flag;
    img.selected = flag;
    title.selected = flag;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.tabBarView.frame = CGRectMake(0, ScreenHeight-49, ScreenWidth, 49);
    }
    else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.tabBarView.frame = CGRectMake(0, ScreenWidth-49, ScreenHeight, 49);
    }
}

#pragma mark - 消息中心

- (void)reloadAllView:(NSNotification *)aNotification
{
    [self initTabBarItem];
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
