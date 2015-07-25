//
//  SYShippingAddressViewController.m
//  MicroShop
//
//  Created by tongcheng on 15/7/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYShippingAddressViewController.h"
#import "SYShippingAddressTableViewCell.h"

@interface SYShippingAddressViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@end

@implementation SYShippingAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"地址管理";
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
     NSLog(@"-->ZIHUA点--------》%@",self.tableView);
//    [self requestShippingAddress];
    
    
}

#pragma make -- 请求收货地址

- (void)requestShippingAddress{
    
    NSString *key = [NSString stringWithFormat:@"&authcode=%@",UserToken];
    
    NSString *url = [NSString stringWithFormat:@"%@%@%@",HomeURL,@"&m=Address&a=addressList",key];

    [[NetworkInterface shareInstance] requestForGet:url complete:^(NSDictionary *result){
        [self didrequesShippingAddress:result];
        
    } error:^(NSError *error){
    
    }];

}

- (void)didrequesShippingAddress:(NSDictionary *)result{
     NSLog(@"-->ZIHUA点--------》%@",result);
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *ID = @"SYShippingAddressTableViewCell";
    SYShippingAddressTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] lastObject];
       
    }

    return cell;
}



@end
