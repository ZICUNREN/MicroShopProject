//
//  SYActiveListTableViewCell.h
//  MicroShop
//
//  Created by siyue on 15/6/11.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYActiveListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplyLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *isStartLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@end
