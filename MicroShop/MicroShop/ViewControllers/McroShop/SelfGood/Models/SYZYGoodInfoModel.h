//
//  SYZYGoodInfoModel.h
//  MicroShop
//
//  Created by siyue on 15/7/17.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYZYGoodInfoModel : BaseModel

@property (copy,nonatomic)NSString *attr_name;
@property (copy,nonatomic)NSString *cover;
@property (copy,nonatomic)NSString *goods_id;
@property (copy,nonatomic)NSString *goods_name;
@property (copy,nonatomic)NSString *goods_price;
@property (copy,nonatomic)NSString *goods_sales;
@property (copy,nonatomic)NSString *goods_storages;
@property (copy,nonatomic)NSString *store_id;

@end
