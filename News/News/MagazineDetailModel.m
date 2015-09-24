//
//  MagazineDetailModel.m
//  News
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MagazineDetailModel.h"

@implementation MagazineDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

+(NSMutableArray *)parsreMessage:(NSData *)data titleStr:(NSString *)titleStr{
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arr = ((NSDictionary *)res)[@"cats"];
    
    if (arr.count != 0) {
        
        for (NSDictionary *dic in arr) {
            
            MagazineDetailModel *model = [[MagazineDetailModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [mutArr addObject:model];
        }
    }
    return mutArr;
}

@end
