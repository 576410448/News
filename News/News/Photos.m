//
//  Photos.m
//  News
//
//  Created by qianfeng on 15/9/21.
//  Copyright © 2015年 LiJiangTao. All rights reserved.
//

#import "Photos.h"
#import "UIImageView+WebCache.h"

@interface Photos ()<UIGestureRecognizerDelegate>
{
    UIImageView *_imgv;
    UIScrollView *_scrollerView;
}
@end

@implementation Photos

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollerView.showsVerticalScrollIndicator = NO; // 不显示竖直方向滚动条
    _scrollerView.showsHorizontalScrollIndicator = NO; // 不显示水平方向滚动条
    
    [self.view addSubview:_scrollerView];
    
    _scrollerView.contentSize = CGSizeMake(0, 0);
    
    _imgv = [[UIImageView alloc]initWithFrame:_scrollerView.bounds];
    
    [_scrollerView addSubview:_imgv];
    
    [_imgv setImageWithURL:[NSURL URLWithString:_icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
    
    // 按原图显示
    _imgv.contentMode = UIViewContentModeScaleAspectFit;
    
    _imgv.userInteractionEnabled = YES;
    
#pragma mark -- 单击返回手势
    
    UITapGestureRecognizer *backtap = [[UITapGestureRecognizer alloc] init];
    
    backtap.numberOfTapsRequired = 1;
    
    [_imgv addGestureRecognizer:backtap];
    
    [backtap addTarget:self action:@selector(backtap)];
    
    backtap.delegate = self;
    
#pragma mark -- 双击放大手势
    
    UITapGestureRecognizer *bigtap = [[UITapGestureRecognizer alloc] init];
    
    bigtap.numberOfTapsRequired = 2;
    
    [_imgv addGestureRecognizer:bigtap];
    
    [bigtap addTarget:self action:@selector(bigtap)];
    
    bigtap.delegate = self;
    
#pragma mark -- UITapGestureRecognizer 代理方法，实现两个点击事件不干扰
    
    [backtap requireGestureRecognizerToFail:bigtap];

}

- (void)backtap{
    if (_callback) {
        _callback();
    }
}

- (void)bigtap{
    if (_scrollerView.contentSize.width == 0) {
        
        _scrollerView.contentSize = CGSizeMake(self.view.frame.size.width + 100, self.view.frame.size.height + 100);
        
        _imgv.frame = CGRectMake(0, 0, _scrollerView.frame.size.width + 100, _scrollerView.frame.size.height + 100);
    }else{
        
        _scrollerView.contentSize = CGSizeMake(0, 0);
        
        _imgv.frame = _scrollerView.bounds;
    }
    
}

@end
