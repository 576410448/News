//
//  HeadlineModel.h
//  News
//
//  Created by qianfeng on 15/9/11.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "NewsModel.h"

@interface HeadlineModel : NewsModel

@property (nonatomic ,copy) NSString *thumb;

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSString *tags;

@property (nonatomic ,copy) NSString *weburl;

@end
