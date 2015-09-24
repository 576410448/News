//
//  CacheManager.m
//  News
//
//  Created by qianfeng on 15/8/29.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "CacheManager.h"
#import "NSString+MD5Addition.h"
#import "CustomerVC.h"

@implementation CacheManager
{
    NSFileManager *_fileManager;
    NSString *_baesPath;
}

+(id)cacheManager{
    static CacheManager *_c = nil;
    if (!_c) {
        _c = [[CacheManager alloc] init];
    }
    return _c;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 定义缓存文件位置
        _fileManager = [NSFileManager defaultManager];
        _baesPath = [[NSHomeDirectory()
                     stringByAppendingPathComponent :@"Documents"]
                     stringByAppendingPathComponent :@"ifreeNews"];
        // 如果文件不存在 则创建缓存文件
        if (![_fileManager fileExistsAtPath:_baesPath]) {
            [_fileManager createDirectoryAtPath:_baesPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

-(BOOL)isCacheName:(NSString *)title{
    // 判断文件中是否存在title的缓存文件
    return [_fileManager fileExistsAtPath:[self cacheNameWithString:title]];
}

-(NSData *)getCacheForName:(NSString *)title{
    return [NSData dataWithContentsOfFile:[self cacheNameWithString:title]];
}

-(void)saveCache:(NSData *)data forName:(NSString *)title{
    // 获取文件名
    NSString *path = [self cacheNameWithString:title];
    // 将data数据写入到对应文件中
    [data writeToFile:path atomically:NO];
    // 当缓存数据发生改变时 发送通知给Customer作出相应改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changSizeShow" object:nil];
    
    NSLog(@"----------path%@",path);
}

-(void)saveCache:(NSData *)data forName:(NSString *)title page:(NSInteger)page{
/**
 *  头条首页page为10  每翻一页+10
 *  其他首页page为0  没翻一页 +15
 *  so 10 表示头条首页 0 表示其他首页
 */
    if (page == 10 || page == 0) {
        [self saveCache:data forName:title];
        return;
    }
    
    // 初始化所有可能用到的
    NSArray *oldArr = [[NSArray alloc] init];
    NSArray *newArr = [[NSArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSDictionary *dic = [[NSDictionary alloc] init];
    NSData *regroupData = [[NSData alloc] init];
    
    if ([title isEqualToString:@"头条"]) {
        
        newArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        regroupData = [NSJSONSerialization dataWithJSONObject:newArr options:NSJSONWritingPrettyPrinted error:nil];
        
    }else if([title hasPrefix:@"第"] || [title isEqualToString:@"杂志分类"]){
        
        oldArr = [NSJSONSerialization JSONObjectWithData:[self getCacheForName:title] options:NSJSONReadingMutableContainers error:nil][@"cats"];
        newArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil][@"cats"];
        
        [arr addObjectsFromArray:oldArr];
        [arr addObjectsFromArray:newArr];
        
        dic = @{@"cats":arr};
        
        regroupData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    }else{
        
        if ([self getCacheForName:title]) {
            oldArr = [NSJSONSerialization JSONObjectWithData:[self getCacheForName:title] options:NSJSONReadingMutableContainers error:nil][@"list"];
            [arr addObjectsFromArray:oldArr];
        }
        
        newArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil][@"list"];
        
        
        [arr addObjectsFromArray:newArr];
        
        dic = @{@"list":arr};
        
        regroupData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    }
    
    [self saveCache:regroupData forName:title];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(page) forKey:title];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 * 处理webView中数据 存与取
 */

-(BOOL)isExistWebCache:(NSString *)webUrl{
    return [_fileManager fileExistsAtPath:[self cacheNameWithString:webUrl]];
}


-(void)saveWebCache:(NSString *)htmlResPonseStr forWebUrl:(NSString *)webUrl{
    
    NSLog(@"正在存");
    NSString *path = [self cacheNameWithString:webUrl];
    
    [htmlResPonseStr writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"已经存");
    NSLog(@"----------path%@",path);
    // 当缓存数据发生改变时 发送通知给Customer作出相应改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changSizeShow" object:nil];
}

-(NSString *)gethHtmlResPonseStrforWebUrl:(NSString *)webUrl{
    
    return [NSString stringWithContentsOfFile:[self cacheNameWithString:webUrl] encoding:NSUTF8StringEncoding error:nil];
}


// 将title进行串码后创建文件
-(NSString *)cacheNameWithString:(NSString *)title{
    NSString *MD5_Str = [title stringFromMD5];
    return [_baesPath stringByAppendingPathComponent :MD5_Str];
}

@end
