//
//  Photos.h
//  News
//
//  Created by qianfeng on 15/9/21.
//  Copyright © 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Photos : UIViewController

@property (nonatomic ,assign) NSInteger currentPage;

@property (nonatomic ,strong) NSString *icon;

@property (nonatomic ,strong) void(^callback)();

@end
