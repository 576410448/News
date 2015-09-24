//
//  MessageModel.h
//  News
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

@interface MessageModel : NewsModel

@property (nonatomic ,copy) NSString *titleStr;

@property (nonatomic ,copy) NSString *desc; // 简介

@property (nonatomic ,copy) NSString *icon; // 资讯图片

@property (nonatomic ,copy) NSString *cover; // 杂志图片

@property (nonatomic ,copy) NSString *title; // 标题

@property (nonatomic ,copy) NSString *pub_time; // 更新时间

@property (nonatomic ,copy) NSString *id; // 新闻编号

@property (nonatomic ,copy) NSString *author; // 作者

@property (nonatomic ,copy) NSString *vol_year; // 期数

@property (nonatomic ,copy) NSString *year; // 杂志年数

@property (nonatomic ,copy) NSString *timestamp; //--酷图

@property (nonatomic ,copy) NSString *gid;// --酷图

@property (nonatomic ,copy) NSString *des;// --酷图

@property (nonatomic ,copy) NSString *small_icon;// --酷图

@end
