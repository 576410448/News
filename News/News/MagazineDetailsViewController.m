//
//  MagazineDetailsViewController.m
//  News
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MagazineDetailsViewController.h"
#import "MagazineDetailModel.h"
#import "MagazineDetailCell.h"
#import "MBProgressHUD.h"
#import "DetailsViewController.h"
#import "AFNetworking.h"
#import "CacheManager.h"

@interface MagazineDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSInteger _cellOfHeight;
    NSInteger _height;
    MBProgressHUD *HUD;
    BOOL _isLoading;
    
    UIBarButtonItem *_leftBarButton;
    
    UIAlertView *_alertView;
}
@end

@implementation MagazineDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"第%@期",_messModel.vol_year];
    
    [self prepareData];
    
    [self uiConfig];
    
    [self testAction];
    
    [self creatLeftBarButton];
    
    self.navigationItem.leftBarButtonItem = _leftBarButton;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
}

-(NSString *)getUrl{
    NSString *url = [NSString stringWithFormat:@"http://ktx.cms.palmtrends.com/api_v2.php?action=get_mags_detail&sa=&uid=13886383&mobile=unkowniphone&offset=0&count=1000&magid=%@&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i",_messModel.id];
    return url;
}

-(void)prepareData{
    
    if ([[CacheManager cacheManager] isCacheName:self.navigationItem.title]) {
        
        NSData *data = [[CacheManager cacheManager] getCacheForName:self.navigationItem.title];
        _dataArray = [MagazineDetailModel parsreMessage:data titleStr:self.navigationItem.title];
        
    }else{
        [self prepareMagazineDetailData];
    }
    
}

-(void)prepareMagazineDetailData{
    _isLoading = YES;
    
    _model = [[MagazineDetailModel alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    
    NSString *url = [self getUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_dataArray addObjectsFromArray: [MagazineDetailModel parsreMessage:responseObject titleStr:self.navigationItem.title]];
        
        [_tableView reloadData];
        _isLoading = NO;
        
        [[CacheManager cacheManager] saveCache:responseObject forName:self.navigationItem.title];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"数据请求失败");
        _isLoading = NO;
        [_alertView show];
    }];
}

-(void)uiConfig{
    CGRect frame = self.view.bounds;
    frame.size.height -= (64 + 49);
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 去掉cell分隔线
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    // 设置tableView背景图片  -- cell背景颜色选择clearColer
    [_tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"资讯背景底"]]];
    
    // 创建数据加载失败时候的alertView
    _alertView = [[UIAlertView alloc] initWithTitle:@"加载数据失败了哟~" message:@"亲~网络开小差咯，检查网络后再加载试试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [self.view addSubview:_alertView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    MagazineDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        if (indexPath.row == 0) {            
            
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MagazineDetailCell" owner:self options:nil]firstObject];
            
            [cell setCallback:^(NSInteger height){
                _cellOfHeight = height;
            }];
            
            [cell setMessModel:_messModel];
           
        }
        
#pragma mark -- 自定义其余cell
        else{
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MagazineDetailCell" owner:self options:nil]lastObject];
            [cell setCallBack:^(NSInteger h) {
                _height = h;
            }];
            cell.model=_dataArray[indexPath.row - 1];
            
            __block NSString *dtlT = [[NSString alloc] init];
            [cell setCallbackAction:^(NSString *ID,NSString *detailT) {
                NSString *idStr = ID;
                dtlT = detailT;
                [self pushAction:idStr detailT:detailT];
            }];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row == 0 ? _cellOfHeight : _height;
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

#pragma mark -- 进入WebView
-(void)pushAction:(NSString *)ID detailT:(NSString *)detailT{
    DetailsViewController *detvc = [[DetailsViewController alloc] init];
    detvc.hidesBottomBarWhenPushed = YES;
    detvc.ID = ID;
    detvc.dtlTitle = detailT;
    [self.navigationController pushViewController:detvc animated:YES];
}

#pragma mark -- 自定义leftBarButton

-(void)creatLeftBarButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 55, 32);
    
    [btn setImage:[UIImage imageNamed:@"返回_1"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"返回_2"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    _leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
