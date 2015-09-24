//
//  CoreDataManager.h
//  CoreData
//
//  Created by Jone ji on 15/4/21.
//  Copyright (c) 2015年 Jone ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FavoriteNewsModel.h"

#define ManagerObjectModelFileName @"FavoriteNewsModel"

@interface CoreDataManager : NSObject
@property (nonatomic ,strong) FavoriteNewsModel *fvModel;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *perStoreCoordinator;

+ (instancetype) sharedCoreDataManager;

- (void)saveContext;

// 读取数据库中所有数据  // 添加参数判断是否为Image
- (NSArray *)showAllObjInCoreDataisImage:(BOOL)isImage;

// 数据库中是否存在
- (BOOL)isExistInCoredataFor:(NSArray *)molArr;

// 存入数据库
- (void)saveCoreData:(NSArray *)molArr callBack:(void(^)(BOOL success,NSString *msg))callback;

// 从数据库中删除
- (void)deleteFromeCoreData:(FavoriteNewsModel *)model;

@end