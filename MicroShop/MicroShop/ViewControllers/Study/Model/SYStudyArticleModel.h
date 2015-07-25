//
//  SYStudyArticleModel.h
//  MicroShop
//
//  Created by siyue on 15/4/29.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseModel.h"

@interface SYStudyArticleModel : BaseModel
@property (strong,nonatomic)NSString *content_url;
@property (strong,nonatomic)NSString *article_title;
@property (strong,nonatomic)NSString *inputtime;
@property (strong,nonatomic)NSString *commentCount;
@end
