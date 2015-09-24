//
//  MagazineDetailCell.h
//  News
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineDetailModel.h"
#import "MessageModel.h"


@interface MagazineDetailCell : UITableViewCell
@property (nonatomic ,strong) MagazineDetailModel *model;
@property (nonatomic ,strong) MessageModel *messModel;

@property (nonatomic ,strong) void(^callback)(NSInteger cellOfHeight);

@property (nonatomic ,strong) void(^callBack)(NSInteger cellOfHeight);

@property (nonatomic ,strong) void(^callbackAction)(NSString *ID,NSString *detailT);

@end
