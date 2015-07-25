//
//  SYWinAwardDetailHeadTableViewCell.h
//  MicroShop
//
//  Created by siyue on 15/6/9.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYWinAwardDetailHeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularLabel;

@property (weak, nonatomic) IBOutlet UIButton *getAardBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectedAddressLabel;
@end
