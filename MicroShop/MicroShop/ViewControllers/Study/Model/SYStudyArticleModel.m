//
//  SYStudyArticleModel.m
//  MicroShop
//
//  Created by siyue on 15/4/29.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYStudyArticleModel.h"

@implementation SYStudyArticleModel

- (id)init {
    self = [super init];
    if (self) {
        self.content_url = @"";
        self.article_title = @"";
        self.inputtime = @"";
        self.commentCount = @"";
    }
    return self;
}

@end
