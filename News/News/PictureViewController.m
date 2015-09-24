//
//  PictureViewController.m
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "PictureViewController.h"
#import "UIButton+WebCache.h"
#import "AFNetworking.h"
#import "ClassPictureButton.h"
#import "PictureShow.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "CacheManager.h"

@interface PictureManager : NSObject

@end

@implementation PictureManager


@end

@interface PictureViewController ()<MBProgressHUDDelegate>
{
    
    UIScrollView *_scrollView;
    NSMutableArray *_pictureArray;
    MBProgressHUD *HUD;
    BOOL _isLoading;
    UIBarButtonItem *_leftBarButton;
    
    NSMutableArray *_gidArray;
    UIAlertView *_alertView;
    
    BOOL _isCache;
}
@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"酷图";
    
    [self prepareData];
    
    [self createScrollerView];
    
    if (_isCache) { // 如果是缓存数据 则在创建所有控件后再创建Button
        [self createPrograma];
    }
    
    [self testAction];
    
    [self reFresh];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(NSString *)getUrl{
    return @"http://ktx.cms.palmtrends.com/api_v2.php?action=piclist&sa=&uid=13886383&mobile=unkowniphone&offset=0&count=9&&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i";
    
}

-(void)prepareData{
    
    if ([[CacheManager cacheManager] isCacheName:self.navigationItem.title]) {
        
        _isCache = YES;
        _pictureArray = [[NSMutableArray alloc] init];
        _model = [[MessageModel alloc] init];
        
        NSData *data = [[CacheManager cacheManager] getCacheForName:self.navigationItem.title];
        _pictureArray = [MessageModel parsreMessage:data titleStr:self.navigationItem.title];
        
    }else{
        [self preparePictureData];
    }
    
}

-(void)preparePictureData{
    
    _isLoading = YES;
    _pictureArray = [[NSMutableArray alloc] init];
    _model = [[MessageModel alloc] init];
    
    NSString *url = [self getUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_pictureArray addObjectsFromArray:[MessageModel parsreMessage:responseObject titleStr:nil]];
        [self createPrograma]; // 异步加载数据 会先加载完其他控件  等数据加载完后再加载赋值控件
        _isLoading = NO;
        
        [[CacheManager cacheManager] saveCache:responseObject forName:self.navigationItem.title];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _isLoading = NO;
        [_alertView show];
    }];
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
    
    _scrollView.backgroundColor = [UIColor brownColor];
    
    _alertView = [[UIAlertView alloc] initWithTitle:@"加载数据失败了哟~" message:@"亲~网络开小差咯，检查网络后再下拉试试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [self.view addSubview:_alertView];
}

-(void)createPrograma{ // 102 * 115
    _gidArray = [[NSMutableArray alloc] init];
    
    CGFloat weight = (self.view.frame.size.width - 22)/3 ;
    CGFloat height = weight *115/102;
    
    CGFloat lastHeight = 0.0;
    for (int i = 0; i < _pictureArray.count; i ++) {
        
        _model = _pictureArray[i];
        [_gidArray addObject:_model.gid];
        ClassPictureButton *btn = [ClassPictureButton buttonWithType:UIButtonTypeCustom];
        
        btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"酷图底1"]];
        
        if (i % 3 == 0) {
            
            btn.frame = CGRectMake(10, 10 + (15 + height)* i/3, weight, height);
            
            [btn setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
            [btn setTitle:_model.title forState:UIControlStateNormal];
            lastHeight = 10 + (15 + height)* i/3;
        }else if (i % 3 == 1){
            
            btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"酷图底2"]];
            
            btn.frame = CGRectMake(11 + weight, lastHeight, weight, height);
            
            [btn setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
            [btn setTitle:_model.title forState:UIControlStateNormal];
            
        }else{
            
            btn.frame = CGRectMake(12 + 2 * weight , lastHeight, weight, height);
            [btn setImageWithURL:[NSURL URLWithString:_model.icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
            [btn setTitle:_model.title forState:UIControlStateNormal];
        }
        [_scrollView addSubview:btn];
        btn.tag = 550 + i;
        [btn addTarget:self action:@selector(goinAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGFloat contentHeight = lastHeight + height + 10;
    if (contentHeight > _scrollView.frame.size.height) {
        _scrollView.contentSize = CGSizeMake(0, contentHeight);
    }else{
        _scrollView.contentSize = CGSizeMake(0, _scrollView.frame.size.height + 10);
    }
}

-(void)goinAction:(UIButton *)btn{
    NSInteger num = btn.tag - 550;
    
    PictureShow *ps = [[PictureShow alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ps];
    ps.modalTransitionStyle = 2;
    ps.gidArray = _gidArray;
    ps.numPage = num;
    [self presentViewController:nav animated:YES completion:nil];
    
}

// 下拉刷新
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
    
    [self preparePictureData];
}

@end
