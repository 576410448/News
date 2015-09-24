//
//  PictureShow.m
//  News
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "PictureShow.h"
#import "DetailTabBarButton.h"
#import "ImageShow.h"
#import "AFNetworking.h"
#import "MessageModel.h"
#import "MBProgressHUD.h"
#import "CoreDataManager.h"

@interface PictureShow ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,MBProgressHUDDelegate>
{
    UIPageViewController *_pageViewController;
    UIImageView *_navigationBar;
    UIImageView *_tabBar;
    ImageShow *imgvc;
    
    BOOL _isloading;
    MBProgressHUD *HUD;
    
    NSMutableArray *_vcArray;  // PageViewController数据
    NSInteger _BA;             // 控制加载数据
    BOOL _isButton;            // 区分滑动与Button指令翻页
    
    UIAlertView *_alertView;
    BOOL _imgvSelected; // 记录pageViewController在一轮滑动中是否被选择 以此选择加载数据 或不加载数据
    
    NSArray *_blockArr;
}
@end

@implementation PictureShow

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self uiConfig];
    
    [self.navigationController.navigationBar addSubview:_navigationBar];
    
    [self preparePageViewData];
    
    if (imgvc.isCache) { // 使用本地缓存数据时 需要将调用pageViewController里的UI控件生成
        
        [imgvc cacheUI];
    }
    
    
    
}

#pragma mark -- 创建页面所有控件

-(void)uiConfig{
    
    [self createController];
    
    [self createNavigationBar];
    
    [self createTabBar];
    
    [self creatPageView];
}

#pragma mark -- 加载PageViewController数据

-(void)preparePageViewData{
    
    imgvc = _vcArray[_numPage];
    imgvc.isNavHidden = self.isNavHidden;
    if (imgvc.isSelected == YES) {
        _imgvSelected = YES;
        return; // 当pageViewController被查看时 读取自带的缓存 不需重新加载数据
    }
    
    [self testAction];
    _isloading = YES;
    
    imgvc.currentPage = _numPage;
    imgvc.gidArray = _gidArray;
    imgvc.isSelected = YES;
    _imgvSelected = NO;
        
    [imgvc prepareData];
    
    __unsafe_unretained PictureShow *weakself = self;
    __unsafe_unretained UIAlertView *weakAlertView = _alertView;
    _blockArr = [[NSArray alloc] init];
    
    [imgvc setCallbackPageViewController:^(BOOL success,NSArray *arr) {
        
        _blockArr = arr;
        _isloading = NO;
        if (success == 1) {
            [weakself uiData];
        }else{
            [weakAlertView show];
        }
        
    }];
    
    [imgvc setCallbackTap:^{
        [weakself beginAvtion];
    }];
}

#pragma mark -- TouchBegin 点击事件回传

-(void)beginAvtion{
    
    __unsafe_unretained PictureShow *weakself = self;
    __block CGRect navFrame = self.navigationController.navigationBar.frame;
    __block CGRect tabFrame = _tabBar.frame;
    CGFloat navHeight =  self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = _tabBar.frame.size.height;
    CGFloat viewHeight = self.view.frame.size.height;
    
    [UIView animateWithDuration:0.24 animations:^{
        if (_tabBar.alpha == 1.0 ) {
            _tabBar.alpha = 0.0;
            weakself.navigationController.navigationBar.alpha = 0.0;
            
            navFrame.origin.y = -navHeight;
            weakself.navigationController.navigationBar.frame = navFrame;
            
            tabFrame.origin.y = viewHeight;
            _tabBar.frame = tabFrame;
            
        }else{
            
            weakself.navigationController.navigationBar.hidden = NO;
            _tabBar.hidden = NO;
            
            navFrame.origin.y = 20;
            weakself.navigationController.navigationBar.frame = navFrame;
            
            tabFrame.origin.y = viewHeight - tabBarHeight;
            _tabBar.frame = tabFrame;
            
            weakself.navigationController.navigationBar.alpha = 1.0;
            _tabBar.alpha = 1.0;
        }
        
    } completion:^(BOOL finished) {
        if (_tabBar.alpha == 0) {
            weakself.navigationController.navigationBar.hidden = YES;
            _tabBar.hidden = YES;
            self.isNavHidden = YES;
        }else{
            self.isNavHidden = NO;
        }
    }];
}

-(void)createController{
    
    _vcArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _gidArray.count; i ++) {
        imgvc = [[ImageShow alloc] init];
        imgvc.currentPage = i;
        [_vcArray addObject:imgvc];
    }
    
    _alertView = [[UIAlertView alloc] initWithTitle:@"图片加载失败了~" message:@"可能网络开小差了,检查网络后再来看看~" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
}

-(void)createNavigationBar{
    
    _navigationBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _navigationBar.userInteractionEnabled = YES;
    [_navigationBar setImage:[UIImage imageNamed:@"ad_title_bg"]];
    [self.view addSubview:_navigationBar];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 6, 55, 32);
    
    [button setImage:[UIImage imageNamed:@"返回2_1"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回2_2"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:button];
    
}

-(void)createTabBar{
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - 41;
    frame.size.height = 41;
    
    _tabBar = [[UIImageView alloc] initWithFrame:frame];
    _tabBar.userInteractionEnabled = YES;
    [_tabBar setImage:[UIImage imageNamed:@"ad_title_bg"]];
    [self.view addSubview:_tabBar];
    
    NSArray *arr = @[@"上一章_1",@"酷图转发_1",@"收藏",@"下一章_1"];
    NSArray *selectedArr = @[@"上一章_2",@"酷图转发_2",@"",@"下一章_2"];
    for (int i = 0; i < 4; i ++) {
        DetailTabBarButton *btn = [[DetailTabBarButton alloc] init];
        btn.frame = CGRectMake(_tabBar.frame.size.width /4 * i, 0, _tabBar.frame.size.width /4, 41);
        btn.tag = 650 + i;
        
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedArr[i]] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBar addSubview:btn];
    }
    
}

-(void)creatPageView{
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    _pageViewController.view.frame = self.view.bounds;
    [self.view insertSubview:_pageViewController.view atIndex:0];
}

#pragma mark -- 加载数据后重新给UI控件赋值

-(void)uiData{
    
    if (!_isButton) {
        [_pageViewController setViewControllers:@[imgvc] direction:0 animated:YES completion:nil];
    }
}

#pragma mark -- _alertView返回事件

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [self dismissAction];
        }
            break;
        default:
            break;
    }
}


#pragma mark -- PageViewController Datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    ImageShow *pvc = (ImageShow *)viewController;
    NSInteger index = pvc.currentPage;
    index --;
    _BA ++;
    
    if (_BA%2 == 1 && _BA != 1) {
        _numPage --;
        if (_numPage < 0) {
            _numPage = _gidArray.count - 1;
        }
        [self preparePageViewData];
        
        if (imgvc.isCache && !_imgvSelected) {
            // 给PageViewController发送通知
            [imgvc cacheUI];
        }
    }
    if (index < 0) {
        index = _gidArray.count - 1;
    }
    
    return _vcArray[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    ImageShow *pvc = (ImageShow *)viewController;
    NSInteger index = pvc.currentPage;
    
    index ++;
    _BA ++;
    
    if (_BA%2 == 1 && _BA != 1) {
        _numPage ++;
        if (_numPage > _gidArray.count - 1) {
            _numPage = 0;
        }
        [self preparePageViewData];
        if (imgvc.isCache && !_imgvSelected) {
            // 给PageViewController发送通知
            [imgvc cacheUI];
        }
    }
    if (index > _gidArray.count - 1) {
        index = 0;
    }
    
    return _vcArray[index];
}

#pragma mark -- 当动画停止的时候调用

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    _isButton = YES;
    _BA = 2;
}

-(void)dismissAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 伪标签栏Button点击事件

-(void)tap:(UIButton *)btn{
    NSInteger index = btn.tag - 650;
    switch (index) {
            
            // 上一页点击事件
        case 0:
        {
            _BA = 0;
            _isButton = YES;
            NSInteger index = imgvc.currentPage;
            index --;
            if (index < 0) {
                index = _gidArray.count - 1;
            }
            [_pageViewController setViewControllers:@[_vcArray[index]] direction:1 animated:YES completion:nil];
            
            _numPage --;
            if (_numPage < 0) {
                _numPage = _gidArray.count - 1;
            }
            [self preparePageViewData];
            if (imgvc.isCache && !_imgvSelected) {
                // 给PageViewController发送通知
                [imgvc cacheUI];
            }
            
        }
            break;
            
        case 1:
        {
            
        }
            break;
        case 2:
        {
            // 写入数据库
            __block NSString *alertStr = [[NSString alloc] init];
            __block BOOL sucs;
            
            [[CoreDataManager sharedCoreDataManager] saveCoreData:_blockArr callBack:^(BOOL success, NSString *msg) {
                sucs = success;
                alertStr = msg;
            }];
            
            UIAlertView *favAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            
            [favAlertView show];
        }
            break;
            // 下一页点击事件
        case 3:
        {
            _BA = 0;
            _isButton = YES;
            NSInteger index = imgvc.currentPage;
            index ++;
            if (index >= _gidArray.count) {
                index = 0;
            }
            [_pageViewController setViewControllers:@[_vcArray[index]] direction:0 animated:YES completion:nil];
            _numPage ++;
            if (_numPage > _gidArray.count - 1) {
                _numPage = 0;
            }
            [self preparePageViewData];
            if (imgvc.isCache && !_imgvSelected) {
                // 调用当前PageViewController创建控件
                [imgvc cacheUI];
            }
        }
            break;
            
        default:
            break;
    }

}

#pragma mark -- 加载提示
-(void)testAction{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"loading...";
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1);
    if (_isloading) {
        [self myTask];
    }
}

@end
