//
//  ViewController.h
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>

@property (nonatomic ,assign) NSInteger vcType;

@property (nonatomic ,copy) NSString *titleStr;

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic ,copy) NSString *urlForStr;

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,copy) NSString *cellForString;

@property (nonatomic ,copy) NSString *modelForStirng;

@property (nonatomic ,assign) BOOL isXib;

@property (nonatomic ,assign) NSInteger cellForHeight;

@property (nonatomic ,assign) BOOL isLoading;

@property (nonatomic ,assign) BOOL isFresh;

@property (nonatomic ,assign) BOOL isSelected;

-(void)startConfig;

-(void)reFresh;

-(void)testAction;

@end

