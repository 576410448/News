//
//  ClassMagazineVC.m
//  News
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "ClassMagazineVC.h"
#import "ClassMagazineModel.h"
#import "AFNetworking.h"
#import "ClassMagazineButton.h"
#import "MessageViewController.h"
#import "CacheManager.h"
#import "MBProgressHUD.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"


@interface ClassMagazineVCManager : NSObject

-(NSString *)getUrl;

@end

@implementation ClassMagazineVCManager

-(NSString *)getUrl{
    return @"http://ktx.cms.palmtrends.com/api_v2.php?action=get_article_list_by_cat&sa=&uid=13886383&mobile=unkowniphone&offset=%@&count=15&cat_id=%@&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i";
    
}

@end


@interface ClassMagazineVC ()<UIScrollViewDelegate,MBProgressHUDDelegate>
{
    ClassMagazineVCManager *_cmVCmagazine;
    
    UIScrollView *_scrollView;
    NSMutableArray *_dataArray;
    MBProgressHUD *HUD;
    BOOL _isLoading;
    UIBarButtonItem *_leftBarButton;
    UIAlertView *_alertView;
    
    BOOL _isCache;
}
@end

@implementation ClassMagazineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"杂志分类";
    
    [self prepareClassData];  // 请求数据
    
    [self createScrollerView];// 创建scrollerView
    
    [self creatLeftBarButton];
    
//    [self createPrograma]; // 创建分类 （数据异步加载 在数据加载完成之后调用）
    if (_isCache) {
        [self createPrograma];
    }
    
    [self testAction];
    
    [self reFresh];
    
    self.navigationItem.leftBarButtonItem = _leftBarButton;
    

}

#pragma mark -- 自定义leftBarButton

-(void)creatLeftBarButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 35, 35);
    [btn setImage:[UIImage imageNamed:@"切换_1"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    _leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}
#pragma mark -- 自定义POP PUSH 翻页动画

-(void)backAction{
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

-(NSString *)getUrl{
    return @"http://ktx.cms.palmtrends.com/api_v2.php?action=get_cats&sa=&uid=13886383&mobile=unkowniphone&offset=0&count=15&&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i";
    
}

-(void)prepareClassData{
    
    if ([[CacheManager cacheManager] isCacheName:self.navigationItem.title]) {
        
        _isCache = YES;
        
        _cmVCmagazine = [[ClassMagazineVCManager alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        _model = [[ClassMagazineModel alloc] init];
        
        NSData *data = [[CacheManager cacheManager] getCacheForName:self.navigationItem.title];
        _dataArray = [ClassMagazineModel parsreMessage:data titleStr:nil];
    }else{
        
        _isCache = NO;
        _isLoading = YES;
        _cmVCmagazine = [[ClassMagazineVCManager alloc] init];
        _dataArray = [[NSMutableArray alloc] init];
        _model = [[ClassMagazineModel alloc] init];
        
        NSString *url = [self getUrl];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [_dataArray addObjectsFromArray:[ClassMagazineModel parsreMessage:responseObject titleStr:nil]];
            
            [self createPrograma];
            _isLoading = NO;
            
            [[CacheManager cacheManager] saveCache:responseObject forName:self.navigationItem.title];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _isLoading = NO;
            [_alertView show];
        }];
        
    }
    
    
}

-(void)testAction{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"页面加载中...";
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1);
    if (_isLoading) {
        [self myTask];
    }
}

-(void)createScrollerView{
    
    CGRect frame = self.view.frame;
    frame.size.height -= (64 + 49);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:_scrollView];
    
    _scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"资讯背景底"]];
    
    _alertView = [[UIAlertView alloc] initWithTitle:@"加载数据失败了哟~" message:@"亲~网络开小差咯，检查网络后再下拉试试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [self.view addSubview:_alertView];
}

-(void)createPrograma{ // 270* 164 135 * 82
    
    CGFloat weight = self.view.frame.size.width/2 - 25;
    CGFloat height = weight *100/135;
    
    CGFloat lastHeight = 0.0;
    for (int i = 0; i < 12; i ++) {
        
        _model = _dataArray[i];
        ClassMagazineButton *btn = [ClassMagazineButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"图片底框"]];
        
        if (i % 2 == 0) {
            
            btn.frame = CGRectMake(20, 10 + (15 + height)* i/2, weight, height);
            
            [btn setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:[UIImage imageNamed:@"缺省图"]];
            [btn setTitle:_model.title forState:UIControlStateNormal];
            lastHeight = 10 + (15 + height)* i/2;
        }else{
            
            btn.frame = CGRectMake(30 + weight , lastHeight, weight, height);
            [btn setImageWithURL:[NSURL URLWithString:_model.cover] placeholderImage:[UIImage imageNamed:@"缺省图"]];
            [btn setTitle:_model.title forState:UIControlStateNormal];
        }
        [_scrollView addSubview:btn];
        btn.tag = 450 + i;
        [btn addTarget:self action:@selector(goinAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    _scrollView.contentSize = CGSizeMake(0, lastHeight + height + 10);
}

-(void)goinAction:(UIButton *)btn{
    NSInteger index = btn.tag - 450;
    MessageViewController *mvc = [[MessageViewController alloc] init];
    _model = _dataArray[index];
    mvc.tString = _model.title;
    mvc.uString = [NSString stringWithFormat:[_cmVCmagazine getUrl],@"%d",_model.id];
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:mvc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}

-(void)reFresh{
    _scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self refreshData];
            NSLog(@"--------------");
            [_scrollView.header endRefreshing];
        });
    }];
}

-(void)refreshData{
    
    [self testAction];
    
    [self prepareClassData];
}

@end
