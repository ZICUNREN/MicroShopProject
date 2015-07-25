//
//  SYStoryModel.m
//  MicroShop
//
//  Created by siyue on 15/4/24.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYStoryModel.h"
#import "SYShareModel.h"

@implementation SYStoryModel

- (id)init {
    self = [super init];
    if (self) {
        self.imgURL = @"";
        self.storyName = @"";
        self.commentNum = @"";
        self.scanNum = @"";
        self.article_id = @"";
        self.shareModel = [[SYShareModel alloc] init];
    }
    return self;
}

@end
