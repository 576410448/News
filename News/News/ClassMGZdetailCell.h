//
//  ClassMGZdetailCell.h
//  News
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface ClassMGZdetailCell : UITableViewCell
@property (nonatomic ,strong) MessageModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *litLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigLabel;
@end
