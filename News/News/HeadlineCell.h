//
//  HeadlineCell.h
//  News
//
//  Created by qianfeng on 15/9/11.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadlineModel.h"

@interface HeadlineCell : UITableViewCell

@property (nonatomic ,strong) HeadlineModel *model;


@property (weak, nonatomic) IBOutlet UIImageView *iconImgv;

@property (weak, nonatomic) IBOutlet UILabel *titlab;

@end
