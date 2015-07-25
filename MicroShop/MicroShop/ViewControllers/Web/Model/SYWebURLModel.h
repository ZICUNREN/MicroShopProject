//
//  SYWebURLModel.h
//  MicroShop
//
//  Created by siyue on 15/4/29.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYWebURLModel : BaseModel

//微店
@property (strong,nonatomic)NSString *micro_shopIndex_URL;//预览店铺
@property (strong,nonatomic)NSString *micro_goodsClass_URL;//商品分类
@property (strong,nonatomic)NSString *micro_statistics_URL;//店铺统计
@property (strong,nonatomic)NSString *micro_spread_URL;//店铺推广
@property (strong,nonatomic)NSString *micro_income_URL;//收入明细
@property (strong,nonatomic)NSString *micro_mySelf_URL;//自营商品
@property (strong,nonatomic)NSString *micro_orderSelf_URL;//自营订单
@property (strong,nonatomic)NSString *micro_sellGoods_URL;//代销商品
@property (strong,nonatomic)NSString *micro_orderIndex_URL;//代销订单

//货源
@property (strong,nonatomic)NSString *supply_brand_List;//代销订单
@property (strong,nonatomic)NSString *supply_By_product;//按产品

//首页
@property (strong,nonatomic)NSString *Index_UserCenter_URL;//个人中心
@property (strong,nonatomic)NSString *Index_Help_URL;//新手帮助

//推广
@property (strong,nonatomic)NSString *Spread_Good_Detail;//查看产品（产品详情）

@end
