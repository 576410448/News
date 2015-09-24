//
//  DetailsViewController.m
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "DetailsViewController.h"
#import "PictureViewController.h"
#import "DetailTabBarButton.h"
#import "CacheManager.h"
#import "CoreDataManager.h"

@interface DetailsViewC : NSObject

@property (nonatomic ,copy) NSString *id;

-(NSString *) getUrl;

@end

@implementation DetailsViewC

-(NSString *) getUrl{
    return [NSString stringWithFormat:@"http://ktx.cms.palmtrends.com/api_v2.php?action=article&uid=13886383&id=%@&mobile=unkowniphone&e=0229e7fd20959df148a1077d9e517faa&fontsize=s",_id];
}

@end


@interface DetailsViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>
{
    DetailsViewC *dtVC; //子类
    UIWebView *_webView; //
    MBProgressHUD *HUD;
    NSString *_urlStr;
    UIImageView *_tabBar;
    BOOL _isLoading;
    NSTimer *_timer;
    
    UIBarButtonItem *_leftBarButton;
    
    int fontsize;
    NSString *_urlColor;
    
    UIAlertView *_alertView;
}
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  区分‘头条’ 与其他试图控制器push进来的所传的数据
    if (_isHeadModel) { // 所传数据是 头条
        
        _headModel = _modelArray[_numOfRow];
        _webUrl = _headModel.weburl;
        _urlStr = _webUrl;
    }else if (_isFavorite){ //  数据是 收藏
        
        _urlStr = _webUrl;
        
    }else{ // 其他页面数所穿数据
        
        _model = _modelArray[_numOfRow];
        dtVC = [[DetailsViewC alloc] init];
        
        if (_ID == nil) {
            dtVC.id = _model.id;
        }else{
            dtVC.id = _ID;
        }
        _urlStr = [dtVC getUrl];
    }
    
    [self creatAlertView];
    
    [self creatLeftBarButton];
    
    self.navigationItem.leftBarButtonItem = _leftBarButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isLoading = YES;
    [self testAction];// 页面开始加载的时候 loading开始
    
    [self.view bringSubviewToFront:self.navigationController.navigationBar];
    
    // 延迟一秒开始加载控件
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uiConfig) userInfo:nil repeats:NO];
    
    // 从导航栏左下角开始计算坐标
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 将导航栏放置到最上层
    [self.view bringSubviewToFront:self.navigationController.navigationBar];
    
}

-(void)uiConfig{
    CGRect webFrame = [UIScreen mainScreen].bounds;
    webFrame.size.height -= (64 + 41);
    _webView = [[UIWebView alloc] initWithFrame:webFrame];
    [self.view addSubview:_webView];
    
    NSString *content = [[NSString alloc] init];
    
    // 判断 htmlResponseStr 缓存文件是否存在  存在的话从缓存中取 否则加载
    if ([[CacheManager cacheManager] isExistWebCache:_urlStr]) {
        content = [[CacheManager cacheManager] gethHtmlResPonseStrforWebUrl:_urlStr];
    }else{
        //  获取HTML 属性
        content=[NSString stringWithContentsOfURL:[NSURL URLWithString:_urlStr] encoding:NSUTF8StringEncoding error:nil];
        
        // 当content 等于nil时  alertView显示
        if (!content) {
            _isLoading = NO;
            [_alertView show];
            return;
        }
        
        [[CacheManager cacheManager] saveWebCache:content forWebUrl:_urlStr];
    }
    
    // 当 
    
    
    NSNumber *font =  [[NSUserDefaults standardUserDefaults] valueForKey:@"font"];
    fontsize = font == nil ? 15 : font.intValue;
    
    NSString *color = [[NSUserDefaults standardUserDefaults] valueForKey:@"textColor"];
    _urlColor = color == nil? @"#000000":color;
    
    //  改变html里面所有p标签 修改p标签段落属性
    content=[content stringByReplacingOccurrencesOfString:@"<p>" withString:[NSString stringWithFormat:@"<p style='font-size:%dpx;line-height:%dpx;color:%@;width:%lfpx;word-break:break-all;word-wrap:break-word;} img{padding-left:-10px;'> ", fontsize,fontsize+2,_urlColor,_webView.bounds.size.width-20]];
    
    /** 拼接html最后 修改p标签属性（优先级较低）
     
     *[content stringByAppendingString:[NSString stringWithFormat:@"<style type=text/css> p{font-size:%dpx;line-height:%dpx;color:%@;width:%lfpx;word-break:break-all;word-wrap:break-word;} img{padding-left:-10px;}</style>",fontsize,fontsize+2,_urlColor,_webView.bounds.size.width-20]];
     */
    
    
    
    
    [_webView loadHTMLString:content baseURL:nil];
    
    _webView.delegate = self;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = frame.size.height - 64 - 41;
    frame.size.height = 41;
    
    _tabBar = [[UIImageView alloc] initWithFrame:frame];
    [_tabBar setImage:[UIImage imageNamed:@"ad_title_bg"]];
    _tabBar.userInteractionEnabled = YES;
    [self.view addSubview:_tabBar];
    
    NSArray *arr = @[@"上一章_1",@"收藏",@"内页转发_1",@"下一章_1"];
    NSArray *selectedArr = @[@"上一章_2",@"",@"内页转发_2",@"下一章_2"];
    for (int i = 0; i < 4; i ++) {
        DetailTabBarButton *btn = [[DetailTabBarButton alloc] init];
        btn.frame = CGRectMake(_tabBar.frame.size.width /4 * i, 0, _tabBar.frame.size.width /4, 41);
        btn.tag = 100 + i;
        
        if (_numOfRow <= 0 && i == 0) {
            btn.userInteractionEnabled = NO;
            [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            btn.highlighted = YES;
        }else if ((_numOfRow >= _modelArray.count - 1 || _modelArray == nil) && i == 3){
            btn.userInteractionEnabled = NO;
            [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            btn.highlighted = YES;
        }else{
            [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selectedArr[i]] forState:UIControlStateHighlighted];
        }
        
        [btn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBar addSubview:btn];
    }
}

-(void)selectedAction:(UIButton *)btn{
    NSInteger index = btn.tag - 100;
    switch (index) {
        case 0:
        {
            if (_numOfRow <= 0) {
                
                return;
            }
            _numOfRow --;
            [_webView removeFromSuperview];
            _isLoading = YES;
            [self viewDidLoad];
        }
            break;
        case 1:
        {
            // 写入数据库
            __block NSString *alertStr = [[NSString alloc] init];
            __block BOOL sucs;
            NSMutableArray *molArr = [[NSMutableArray alloc] init];
            
            if (_isHeadModel) {
                [molArr addObject:_headModel.title];
            }else{
                if (!_model.title) { // model.title 没有数据 则取直接传值的 _dtlTitle
                    [molArr addObject:_dtlTitle];
                }else{
                    [molArr addObject:_model.title];
                }
            }
            [molArr addObject:@0];
            [molArr addObject:_urlStr];
            
            [[CoreDataManager sharedCoreDataManager] saveCoreData:molArr callBack:^(BOOL success, NSString *msg) {
                sucs = success;
                alertStr = msg;
            }];
            
            UIAlertView *favAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            
            [favAlertView show];
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            if (_numOfRow >= _modelArray.count - 1) {
                
                return;
            }
            _numOfRow ++;
            [_webView removeFromSuperview];
            _isLoading = YES;
            [self viewDidLoad];
        }
            break;
            
        default:
            break;
    }
}

-(void)testAction{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _isLoading = NO;
}
- (void)viewDidAppear:(BOOL)animated{
    _isLoading = NO;
    
}

-(void)creatAlertView{
    
    _alertView = [[UIAlertView alloc] initWithTitle:@"网络请求失败" message:@"检查网络后再来看看~" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    
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
    [_timer invalidate];
    _timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}




@end
