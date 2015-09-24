//
//  PhotosViewC.m
//  News
//
//  Created by qianfeng on 15/9/21.
//  Copyright © 2015年 LiJiangTao. All rights reserved.
//

#import "PhotosViewC.h"
#import "Photos.h"

@interface PhotosViewC ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@end

@implementation PhotosViewC
{
    UIPageViewController *_pageViewController;
    NSMutableArray *_vcArray;
    Photos *_photos;
    
}

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [super viewDidLoad];
    
    [self prepareData];
    
    [self createPageView];
    
}

-(void)prepareData{
    
    _vcArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _phoArr.count; i ++) {
        _photos = [[Photos alloc] init];
        _photos.currentPage = i;
        _photos.icon = _phoArr[i];
        
        __unsafe_unretained PhotosViewC *weakself = self;
        [_photos setCallback:^{
            [weakself backVC];
        }];
        
        [_vcArray addObject:_photos];
    }
    
}

-(void)createPageView{
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    [_pageViewController setViewControllers:@[_vcArray[_page]] direction:0 animated:YES completion:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    _pageViewController.view.frame = self.view.bounds;
    [self.view addSubview:_pageViewController.view];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    Photos *photo = (Photos *)viewController;
    NSInteger index = photo.currentPage;
    index --;
    if (index < 0) {
        return nil;
    }
    return _vcArray[index];
    
}


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    Photos *photo = (Photos *)viewController;
    NSInteger index = photo.currentPage;
    index ++;
    if (index >= _phoArr.count) {
        return nil;
    }
    return _vcArray[index];
    
}

-(void)backVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
