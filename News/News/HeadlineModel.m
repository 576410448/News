//
//  HeadlineModel.m
//  News
//
//  Created by qianfeng on 15/9/11.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "HeadlineModel.h"

@implementation HeadlineModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+(NSMutableArray *)parsreMessage:(NSData *)data titleStr:(NSString *)titleStr{
    
    NSMutableArray *headArr = [[NSMutableArray alloc] init];
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *result = res[@"data"];
    NSRange range=NSMakeRange(result.count-10, 10);
    
    result=[result subarrayWithRange:range];
    
    for (NSDictionary *dic in result) {
        HeadlineModel *model = [[HeadlineModel alloc] init];
        [model  setValuesForKeysWithDictionary:dic];
        NSArray *tagsArr = (NSArray *)dic[@"tags"];
        if (tagsArr.count != 0) {
            model.tags = tagsArr[0];
        }else{  // tagsArr 里面没有元素的时候，给model.tags赋值为nil 
            model.tags = nil;
        }
        [headArr addObject:model];
    }
    
    return headArr;
}

+(NSMutableArray *)parsreCache:(NSData *)data titleStr:(NSString *)titleStr{
    NSMutableArray *headArr = [[NSMutableArray alloc] init];
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSArray *result = res[@"data"];
    
    for (NSDictionary *dic in result) {
        HeadlineModel *model = [[HeadlineModel alloc] init];
        [model  setValuesForKeysWithDictionary:dic];
        NSArray *tagsArr = (NSArray *)dic[@"tags"];
        if (tagsArr.count != 0) {
            model.tags = tagsArr[0];
        }else{  // tagsArr 里面没有元素的时候，给model.tags赋值为nil
            model.tags = nil;
        }
        [headArr addObject:model];
    }
    
    return headArr;
}

@end
