//
//  SYAllDynamicTableViewCell.h
//  MicroShop
//
//  Created by siyue on 15/4/27.
//  Copyright (c) 2015年 App. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYAllDynamicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *disImgView2;
@property (weak, nonatomic) IBOutlet UIImageView *disImgView3;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UIButton *transmitBtn;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *goodsView;

@end
