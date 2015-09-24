//
//  ClassMagazineModel.h
//  News
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

@interface ClassMagazineModel : NewsModel

@property (nonatomic ,copy) NSString *cover;

@property (nonatomic ,copy) NSString *id;

@property (nonatomic ,copy) NSString *title;

@end
