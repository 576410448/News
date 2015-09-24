//
//  MagazineDetailsViewController.h
//  News
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineDetailModel.h"
#import "MessageModel.h"

@interface MagazineDetailsViewController : UIViewController
@property (nonatomic ,strong) MagazineDetailModel *model;
@property (nonatomic ,strong) MessageModel *messModel;

@property (nonatomic ,copy) NSString *detailStr;


@end
