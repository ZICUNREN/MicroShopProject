//
//  SYSelfGoodListViewController.h
//  MicroShop
//
//  Created by siyue on 15/7/16.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseViewController.h"

@interface SYSelfGoodListViewController : BaseViewController

@property (nonatomic,strong)NSString *state; //商品状态 默认为1即正常，0为下架
@property (nonatomic,strong)NSString *goodclass; //店铺商品分类 默认为0即全部

@end
