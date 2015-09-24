//
//  MagazineDetailModel.h
//  News
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "NewsModel.h"

@interface MagazineDetailModel : NewsModel


@property (nonatomic ,copy) NSString *cat_name; // 标题

//@property (nonatomic ,copy) NSString *id; // 编号

//@property (nonatomic ,copy) NSString *title; //进入标题

@property (nonatomic ,strong) NSArray *list;

@end
