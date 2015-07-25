//
//  SYAwardListTableViewCell.h
//  MicroShop
//
//  Created by siyue on 15/6/8.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYAwardListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isHaveGetLabel;

@end
