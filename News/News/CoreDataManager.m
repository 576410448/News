//
//  CoreDataManager.m
//  CoreData
//
//  Created by Jone ji on 15/4/21.
//  Copyright (c) 2015年 Jone ji. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager




@synthesize managedObjContext = _managedObjContext;
@synthesize managedObjModel = _managedObjModel;
@synthesize perStoreCoordinator = _perStoreCoordinator;

static CoreDataManager *coredataManager;

+ (instancetype) sharedCoreDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{   
        coredataManager = [[self alloc] init];
    });
    return coredataManager;
}

//被管理的对象模型
- (NSManagedObjectModel *)managedObjModel
{
    if (_managedObjModel != nil) {
        return _managedObjModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagerObjectModelFileName withExtension:@"momd"];
    NSLog(@"%@",modelURL);
    _managedObjModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjModel;
}

//被管理的上下文:操作实际内容
-(NSManagedObjectContext *)managedObjContext
{
    if (_managedObjContext != nil) {
        return _managedObjContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self perStoreCoordinator];
    if (coordinator != nil) {
        _managedObjContext = [[NSManagedObjectContext alloc] init];
        [_managedObjContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjContext;
}

//持久化存储助理:相当于数据库的连接器
-(NSPersistentStoreCoordinator *)perStoreCoordinator
{
    if (_perStoreCoordinator != nil) {
        return _perStoreCoordinator;
    }
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagerObjectModelFileName]];
    
    NSLog(@"path = %@",storeURL.path);
    NSError *error = nil;
    _perStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjModel]];
    if (![_perStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"your error domain" code:999 userInfo:dict];
        
        NSLog(@"error: %@,%@",error,[error userInfo]);
        abort();
    }
    return _perStoreCoordinator;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//保存数据
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark -- 显示数据库中所有数据
- (NSArray *)showAllObjInCoreDataisImage:(BOOL)isImage{
    
    //    创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FavoriteNewsModel" inManagedObjectContext:self.managedObjContext];
    //    设置请求实体
    [request setEntity:entity];
    
    //    指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"newsUrl" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    // 添加系那是条件 isImage
    request.predicate=[NSPredicate predicateWithFormat:@"isImage=%d",isImage];
    
    NSError *error = nil;
    //    执行获取数据请求，返回数组
    NSArray *fetchResult = [self.managedObjContext executeFetchRequest:request error:&error];
    if (!fetchResult)
    {
        NSLog(@"error:%@,%@",error,[error userInfo]);
    }
    
    return fetchResult;
}

#pragma mark -- 数据库中查找
- (BOOL)isExistInCoredataFor:(NSArray *)molArr{
    NSManagedObjectContext *context = [self managedObjContext];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:ManagerObjectModelFileName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (_fvModel in fetchedObjects) {
        
        if ([_fvModel.newsUrl isEqual:molArr.lastObject]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -- 写入数据库
- (void)saveCoreData:(NSArray *)molArr callBack:(void(^)(BOOL success,NSString *msg))callback{
    
    BOOL isExist = [self isExistInCoredataFor:molArr];
    if (isExist) {
        if (callback) {
            callback(NO,@"已收藏");
        }
        return;
    }
    
    _fvModel = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteNewsModel" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [_fvModel setNewsTitle:molArr.firstObject];
    [_fvModel setNewsUrl:molArr.lastObject];
    [_fvModel setIsImage:molArr[1]];
    
    NSError *error = nil;
    //          托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
        if (callback) {
            callback(NO,@"收藏失败~");
        }
    }else
    {
        NSLog(@"Save successFull");
        if (callback) {
            callback(YES,@"收藏成功!");
        }
    }
    
}

#pragma mark -- 从数据库中删除数据
- (void)deleteFromeCoreData:(FavoriteNewsModel *)model{
    
    [[CoreDataManager sharedCoreDataManager].managedObjContext deleteObject:model];

    NSError *error = nil;

    //    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else
    {
        NSLog(@"del successFull");
    }
    
}

@end
