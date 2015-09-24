//
//  CacheManager.h
//  News
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

/**
 * 加载ViewController数据
 */

+(id)cacheManager;

-(BOOL)isCacheName:(NSString *)title; // 根据title判断当前页面是否有缓存数据

-(void)saveCache:(NSData *)data forName:(NSString *)title; // 根据data与title存数据

-(void)saveCache:(NSData *)data forName:(NSString *)title page:(NSInteger)page; // 根据data与title存数据，并保存当前页数

-(NSData *)getCacheForName:(NSString *)title; // 根据title获取当前所有缓存数据

/**
 * 加载webView数据
 */
-(BOOL)isExistWebCache:(NSString *)webUrl;

-(void)saveWebCache:(NSString *)htmlResPonseStr forWebUrl:(NSString *)webUrl;

-(NSString *)gethHtmlResPonseStrforWebUrl:(NSString *)webUrl;

@end
