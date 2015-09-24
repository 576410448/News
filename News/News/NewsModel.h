//
//  NewsModel.h
//  News
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

+(NSMutableArray *)parsreMessage:(NSData *)data titleStr:(NSString *)titleStr;

+(NSMutableArray *)parsreCache:(NSData *)data titleStr:(NSString *)titleStr;

@end
