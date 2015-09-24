//
//  FavoriteNewsModel.h
//  News
//
//  Created by qianfeng on 15/9/21.
//  Copyright © 2015年 LiJiangTao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteNewsModel : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nullable, nonatomic, retain) NSString *newsImage;
@property (nullable, nonatomic, retain) NSString *newsTitle;
@property (nullable, nonatomic, retain) NSString *newsUrl;
@property (nullable, nonatomic, retain) NSNumber *isImage;

@end

NS_ASSUME_NONNULL_END

