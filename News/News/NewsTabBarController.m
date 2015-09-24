//
//  NewsTabBarController.m
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "NewsTabBarController.h"
#import "MessageViewController.h"
#import "MicroblogViewController.h"
#import "PictureViewController.h"

@interface NewsTabBarController ()
{
    UIImageView *_NewsTabBar;
}
@end

@implementation NewsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建视图
    [self createViewController];
    
    // 创建标签栏
    [self createTableBar];
    
    // 创建标签
    [self createTabs];
    
}


-(void)createViewController{
    
    
    NSArray *viewConts = @[@"MicroblogViewController",
                           @"MessageViewController",
                           @"MessageViewController",
                           @"PictureViewController"];
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 4; i ++) {
        ViewController *vc = [[NSClassFromString(viewConts[i]) alloc] init];
        vc.vcType = i;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:navi];
    }
    self.viewControllers = vcs;
    
}


-(void)createTableBar{
    
    _NewsTabBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    _NewsTabBar.image = [UIImage imageNamed:@"TabBarBackground"];
    _NewsTabBar.clipsToBounds = YES;
    
    _NewsTabBar.userInteractionEnabled = YES;
    [self.tabBar addSubview:_NewsTabBar];
    
}


-(void)createTabs{
    
    NSArray *tabBarimg = @[@"头条_1",@"资讯_1",@"杂志_1",@"酷图_1"];
    NSArray *tabBarSelectimg = @[@"头条_2",@"资讯_2",@"杂志_2",@"酷图_2"];
    
    for (int i = 0; i < 4; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 取消btn高亮状态
        [btn setShowsTouchWhenHighlighted:YES];
        CGFloat weight = _NewsTabBar.frame.size.width/4;
        
        btn.frame = CGRectMake(i * weight, 0, weight, weight*55.00/80.00);
        btn.tag = 100 + i;
        [btn setImage:[UIImage imageNamed:tabBarimg[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:tabBarSelectimg[i]] forState:UIControlStateSelected];
        btn.contentMode = UIViewContentModeScaleAspectFill;
        if (i == 0) {
            btn.selected = YES;
        }
        [_NewsTabBar addSubview:btn];
        
        [btn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)tapAction:(UIButton *)btn{
    
    NSInteger index = btn.tag - 100;
    self.selectedIndex = index;
    
    for (UIButton *btn in _NewsTabBar.subviews) {
        btn.selected = NO;
    }
    
    //设置selected属性
    btn.selected = YES;
}




@end
