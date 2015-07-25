//
//  SYXYGoodsModel.h
//  MicroShop
//
//  Created by siyue on 15/5/7.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYXYGoodsModel : BaseModel

@property (strong,nonatomic)NSString *goods_name;
@property (strong,nonatomic)NSString *goods_description;
@property (strong,nonatomic)NSString *shop_goods_class_id;
@property (strong,nonatomic)NSString *goods_freight;
@property (strong,nonatomic)NSMutableArray *goods_imgList;
@property (strong,nonatomic)NSMutableArray *goods_attributeList;

@end
