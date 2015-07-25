//
//  SYStudyModel.h
//  MicroShop
//
//  Created by siyue on 15/4/27.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYStudyModel : BaseModel

@property (strong,nonatomic)NSString *userName;
@property (strong,nonatomic)NSString *imgURL;
@property (strong,nonatomic)NSString *timeStr;
@property (strong,nonatomic)NSString *commentNum;
@property (strong,nonatomic)NSString *text_id;

@end
