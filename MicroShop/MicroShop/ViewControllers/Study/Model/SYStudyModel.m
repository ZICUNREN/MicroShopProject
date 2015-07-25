//
//  SYStudyModel.m
//  MicroShop
//
//  Created by siyue on 15/4/27.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "SYStudyModel.h"

@implementation SYStudyModel

- (id)init {
    self = [super init];
    if (self) {
        self.userName = @"";
        self.imgURL = @"";
        self.timeStr = @"";
        self.commentNum = @"";
        self.text_id = @"";
    }
    return self;
}

@end
