//
//  MessageModel.m
//  News
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+(NSMutableArray *)parsreMessage:(NSData *)data titleStr:(NSString *)titleStr{
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];     
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arr = ((NSDictionary *)res)[@"list"];
    
    for (NSDictionary *dic in arr) {
        MessageModel *model = [[MessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        model.titleStr = titleStr;
        [mutArr addObject:model];
    }
    
    return mutArr;
}

@end
