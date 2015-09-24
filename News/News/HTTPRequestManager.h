//
//  HTTPRequestManager.h
//  News
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequestManager : NSObject

+(id)manager;

-(void)GET:(NSString *)urlStr complete:(void(^)(BOOL success ,NSData *data))callback;

-(void)GET:(NSString *)urlStr complete:(void (^)(BOOL success, NSData *))callback isCache:(BOOL)chche;

//-(void)GET:(NSString *)urlStr complete:(void (^)(BOOL success, NSData *))callback isCache:(BOOL)chche

@end
