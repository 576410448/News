//
//  ClassMagazineModel.m
//  News
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "ClassMagazineModel.h"

@implementation ClassMagazineModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+(NSMutableArray *)parsreMessage:(NSData *)data titleStr:(NSString *)titleStr{
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arr = ((NSDictionary *)res)[@"cats"];
    
    for (NSDictionary *dic in arr) {
        ClassMagazineModel *model = [[ClassMagazineModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [mutArr addObject:model];
    }
    return mutArr;
}

@end
