//
//  ImageShow.h
//  News
//
//  Created by qianfeng on 15/9/5.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageShow : UIViewController

@property (nonatomic ,strong) UIImageView *imgv;
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UILabel *partitionLabel;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic,assign) BOOL isSelected; //  当前页面被查看以后，在不退出的情况下 下次读取PageViewController自带缓存

@property (nonatomic ,copy) NSArray *gidArray;

@property (nonatomic,strong) void(^callbackPageViewController)(BOOL success,NSArray *arr);

@property (nonatomic,strong) void(^callbackTap)();

@property (nonatomic,assign) BOOL isNavHidden;

@property (nonatomic,assign) BOOL isCache;

-(void)prepareData;

-(void)cacheUI;

@end
