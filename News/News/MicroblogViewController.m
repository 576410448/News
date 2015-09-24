//
//  MicroblogViewController.m
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MicroblogViewController.h"
#import "DetailsViewController.h"

@interface MicroblogViewController ()
{
    UIView *_window ;
    UIButton *_upButton;
    UIBarButtonItem *_customerBarButton;
}
@end

@implementation MicroblogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    self.titleStr = @"头条";
    
    self.urlForStr = @"http://appapi.kxt.com/data/jianwen?markid=0&num=%d&tagid=0";
    
    self.cellForString = @"HeadlineCell";
    
    self.cellForHeight = 90;
    
    self.modelForStirng = @"HeadlineModel";
    
    self.isXib = YES;
    
    self.page = 10;
    
    [self startConfig];
    
    [self reFresh];
    
#pragma mark -- 当设置设置按键按下，产生抽屉效果后，在本页面设计全屏的点击事件返回
    
    _window = self.navigationController.tabBarController.view.superview;
    
    _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _upButton.frame = self.view.bounds;
    _upButton.backgroundColor = [UIColor clearColor];
    _upButton.hidden = YES;
    [_window addSubview:_upButton];
    
    [_upButton addTarget:self action:@selector(clouseCustomer) forControlEvents:UIControlEventTouchUpInside];
    
    [self createCustomerBarButton];
    self.navigationItem.leftBarButtonItem = _customerBarButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveWinToRight) name:@"favoriteChangeRight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveWinToLeft) name:@"favoriteChangeLeft" object:nil];

}

#pragma mark -- 自定义设置barButton

-(void)createCustomerBarButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 35, 35);
    
    [btn setImage:[UIImage imageNamed:@"设置_1"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"设置_2"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(customerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _customerBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

/*-----接收 处理改变window的frame通知-----*/
#pragma mark -- 关闭customer界面

-(void)clouseCustomer{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changCustomer" object:nil];
    
    
    [UIView animateWithDuration:0.48 animations:^{
        
        _window.center = CGPointMake(self.view.center.x, [UIScreen mainScreen].bounds.size.height/2);
        _window.transform = CGAffineTransformScale(_window.transform, 1.0/0.8, 1.0/0.8);
    }];
    
    _upButton.hidden= YES;
    
}

#pragma mark -- 资讯界面 设置 打开Customer界面

- (void)customerAction:(UIButton *)btn{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changCustomer" object:nil];
    
    _upButton.hidden = NO;
    
    [UIView animateWithDuration:0.48 animations:^{
        
        _window.center = CGPointMake(340, [UIScreen mainScreen].bounds.size.height/2);
        _window.transform = CGAffineTransformScale(_window.transform, 0.8, 0.8);
    }];
}

#pragma mark -- 将window移动到最右边

-(void)moveWinToRight{
    
    [UIView animateWithDuration:0.48 animations:^{
        
        _window.center = CGPointMake(self.view.frame.size.width * 3 /2, [UIScreen mainScreen].bounds.size.height/2);
    }];
    
}

#pragma mark -- 将window移回左边抽屉样式

-(void)moveWinToLeft{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _window.center = CGPointMake(340, [UIScreen mainScreen].bounds.size.height/2);
    }];
    
}
/*-EDN----接收 处理改变window的frame通知-----*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.row == self.dataArray.count) {
        return;
    }else{
        DetailsViewController *detvc = [[DetailsViewController alloc] init];
        detvc.hidesBottomBarWhenPushed = YES;
        detvc.modelArray = self.dataArray;
        detvc.numOfRow = indexPath.row;
        detvc.isHeadModel = YES;
        [self.navigationController pushViewController:detvc animated:YES];
    }
    
}

/**
 
 CGRect webFrame = [UIScreen mainScreen].bounds;
 webFrame.size.height = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height;
 _webView = [[UIWebView alloc] initWithFrame:webFrame];

 NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http:www.vistastory.com"]];

 _webView.delegate = self;

 [self.view addSubview:_webView];

 [_webView loadRequest:request];
*
*/


// http://appapi.kxt.com/data/jianwen?markid=0&num=10&tagid=0
// http://appapi.kxt.com/index.php/page/article_app/id/%@
@end
