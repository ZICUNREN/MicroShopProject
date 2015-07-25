//
//  SYStudyDetialViewController.h
//  MicroShop
//
//  Created by siyue on 15/4/29.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import "BaseViewController.h"
@class SYShareModel;

@interface SYStudyDetialViewController : BaseViewController

@property (strong,nonatomic)NSString *textId;

@property (strong,nonatomic)SYShareModel *shareModel;

@property (strong,nonatomic)NSString *studyDetialURL;//空为推广

@end
