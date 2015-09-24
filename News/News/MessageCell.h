//
//  MessageCell.h
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageCell : UITableViewCell
@property (nonatomic ,strong) MessageModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *backImageV;

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsContent;
@property (weak, nonatomic) IBOutlet UILabel *newsTime;
@property (weak, nonatomic) IBOutlet UILabel *magazineLabel;

@property (weak, nonatomic) IBOutlet UIImageView *littleTimeImageV;
@end
