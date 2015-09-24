//
//  DetailsViewController.h
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "HeadlineModel.h"
#import "FavoriteNewsModel.h"

@interface DetailsViewController : UIViewController

@property (nonatomic ,strong) MessageModel *model;
@property (nonatomic ,strong) HeadlineModel *headModel;
@property (nonatomic ,strong) FavoriteNewsModel *fvModel;

@property (nonatomic ,strong) NSArray *modelArray;

@property (nonatomic ,assign) NSInteger numOfRow;

@property (nonatomic ,copy) NSString *ID;

@property (nonatomic ,copy) NSString *dtlTitle;

@property (nonatomic ,assign) BOOL isHeadModel; // 判断传进来的数据 是否为头条数据

@property (nonatomic ,assign) BOOL isFavorite; // 判断所传数据 是否为收藏数据

@property (nonatomic ,copy) NSString *webUrl;

@end
