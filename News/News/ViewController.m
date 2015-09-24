//
//  ViewController.m
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "ViewController.h"
#import "NewsModel.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "CacheManager.h"

@interface ViewController ()
{
    MBProgressHUD *HUD;
    
    BOOL _isLast;
    UIAlertView *_alertView;
    UIAlertView *_lastAlert;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"index_topbar"]forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //所有控件坐标从导航栏左下角坐标开始算
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view bringSubviewToFront:self.navigationController.navigationBar];
}
-(void)startConfig{
    
    self.navigationItem.title = self.titleStr;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self testAction];
    
    // 启动加载数据前判断是否存在缓存数据
    if ([[CacheManager cacheManager] isCacheName:self.titleStr]) {
        [self prepareCache];
        
    }else{
        [self prepareData];
    }
    
    [self uiConfig];
}


// 下拉刷新
-(void)reFresh{
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self refreshData];
            NSLog(@"--------------");
            [_tableView.header endRefreshing];
        });
    }];
    
}

-(void)refreshData{
    if ([self.titleStr isEqualToString:@"头条"]) {
        _page = 10;
    }else{
        _page = 0;
    }
    _isFresh = YES;
    [self testAction];
    [self prepareData];
}

-(NSString *)getUrl{
    
    return [NSString stringWithFormat:_urlForStr,_page];
}

-(void)loadMore{
    if ([self.titleStr isEqualToString:@"头条"]) {
        _page += 10;
    }else{
        _page += 15;
    }
    
    [self testAction];
    [self prepareData];
}

// 读取缓存数据
-(void)prepareCache{
    
    NSData *data = [[CacheManager cacheManager] getCacheForName:self.titleStr];
    
    if ([self.titleStr isEqualToString:@"头条"]) { // 头条数据需要使其他方法获取所有缓存
        _dataArray = [NSClassFromString(_modelForStirng) parsreCache:data titleStr:_titleStr];
    }else{
        _dataArray = [NSClassFromString(_modelForStirng) parsreMessage:data titleStr:_titleStr];
    }
    
    self.page = [[[NSUserDefaults standardUserDefaults] valueForKey:self.titleStr]intValue];
    [_tableView reloadData];
}

-(void)prepareData{
    _isLoading = YES;
    
    NSString *url = [self getUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //必须指定返回结果的类型:data,json,xml
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (_isFresh) {
            _dataArray = [NSClassFromString(_modelForStirng) parsreMessage:responseObject titleStr:_titleStr];

        }
        else{
            
            NSInteger count = _dataArray.count;
            [_dataArray addObjectsFromArray: [NSClassFromString(_modelForStirng) parsreMessage:responseObject titleStr:_titleStr]];
            if (count == _dataArray.count) {// 当数据全部请求完成时 再加载数据个数为0 此时隐藏加载更多选项
                [_lastAlert show];
                _isLast = YES;
            }
        }
        // 加载数据完成后，根据title缓存数据
        [[CacheManager cacheManager] saveCache:responseObject forName:self.titleStr page:self.page];
        
        _isLoading = NO;
        _isFresh = NO;
        [_tableView reloadData];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"数据请求失败");
        _isLoading = NO;
        [_alertView show];
    }];

}

-(void)uiConfig{
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (64 + 49);
    
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 去掉cell分隔线
    if (![self.titleStr isEqualToString:@"头条"]) {
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 设置tableView背景图片  -- cell背景颜色选择clearColer
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"资讯背景底"]]];
    
    // cell注册 当cell从缓存池中取出为空时 调用这里创建cell
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"loadmore"];
    
    if (_isXib) {
        [_tableView registerNib:[UINib nibWithNibName:_cellForString bundle:nil] forCellReuseIdentifier:@"cellid"];
    }
    else
    {
        [_tableView registerClass:NSClassFromString(_cellForString) forCellReuseIdentifier:@"cellid"];
    }
    
    // 创建数据加载失败时候的alertView
    _alertView = [[UIAlertView alloc] initWithTitle:@"加载数据失败了哟~" message:@"亲~网络开小差咯，检查网络后再加载试试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [self.view addSubview:_alertView];
    
    //  创建全部数据加载完成时候的alertView
    _lastAlert = [[UIAlertView alloc] initWithTitle:@"这里没有更多可以阅读的咯~" message:@"快看看其他栏目吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [self.view addSubview:_lastAlert];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count + (_dataArray.count > 0) - (_isLast);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArray.count == indexPath.row) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadmore" forIndexPath:indexPath];
        cell.textLabel.text = @"加载更多";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    [cell setValue:_dataArray[indexPath.row] forKey:@"model"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == _dataArray.count && !_isLoading) {
        [self loadMore];
        return;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row == _dataArray.count ? 40:_cellForHeight;
}

-(void)testAction{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"Loading...";
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(1);
    if (_isLoading) {
        [self myTask];
    }
}

@end
