//
//  CustomerVC.m
//  News
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "CustomerVC.h"
#import "CustomButton.h"
#import "FavoriteVC.h"
#import "SDImageCache.h"

@interface CustomerVC ()<UIActionSheetDelegate>
{
    UIScrollView *_scrollView;
    NSArray *_titleArray;
    NSArray *_iconArray;
    UILabel *_titleLabel;
    
    UIView *_upView;
    UILabel *_textFont;
    UILabel *_textColor;
    UILabel *_sizeLabel;
    UIAlertView *_alertView;
    UIActionSheet *_sheet;
    
    NSArray *_urlColorarr;
    NSArray *_array;
    
    NSString *_baespath;
    NSFileManager *_file;
    
    NSString *_imgBasepath;
    NSString *_imgFile;
    CGFloat _size;
    
}
@end
// 18237905920
@implementation CustomerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBackGround"]];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self getData];
    
    [self scrollViewConfig];
    
    //  创建设置页标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, 44)];
    [self.navigationController.navigationBar addSubview:_titleLabel];
    
    self.tabBarItem.title = @"设置";
    _titleLabel.text = @"设置";
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(frameAction) name:@"changCustomer" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSize) name:@"changSizeShow" object:nil];
    
    [self litUIConfig];
    
    [self getSize];
    
}

// 动画  让_titleLabel在页面将要出现的时候显示
-(void)viewWillAppear:(BOOL)animated{
    _titleLabel.hidden = NO;
    [UIView animateWithDuration:0.24 animations:^{
        _titleLabel.alpha = 1.0;
    }];
}

-(void)litUIConfig{
    
    // 当页面关闭时使 View改整个ViewController
    _upView = [[UIView alloc] initWithFrame:self.view.bounds];
    _upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_upView];
    
    // 当缓存文件已经为空时  提示已经为空
    _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缓存文件为空" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [self.view addSubview:_alertView];
    
    // 当需要清楚缓存时 给出提示 是否清楚
    _sheet = [[UIActionSheet alloc] initWithTitle:@"将要清除所有缓存" delegate:self cancelButtonTitle:@"返回" destructiveButtonTitle:@"确认清除" otherButtonTitles:nil, nil];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            [_file removeItemAtPath:_baespath error:NULL];
            [self getSize];
        }
            break;
            
    }
}

#pragma mark -- 当设置页面没有弹出时，让它隐藏

-(void)frameAction{
    [UIView animateWithDuration:0.48 animations:^{
        
        if (_upView.hidden == NO) {
            _upView.alpha = 0.0;
            
        }else{
            _upView.hidden = NO;
            _upView.alpha = 1.0;
        }
        
        
    } completion:^(BOOL finished) {
        if (_upView.alpha == 0.0) {
            _upView.hidden = YES;
        }
        
    }];
}

-(void)getData{
    
    _titleArray = @[@"文章字号",@"字体颜色",@"收藏夹",@"分享设置",@"用户登录",@"推送通知",@"关于我们",@"应用程序推荐",@"清除缓存"];
    
    _iconArray = @[@"文章字号",@"文章字号",@"收藏夹",@"分享设置",@"用户登录",@"推送通知",@"关于我们",@"应用程序推荐",@"清除缓存"];
    
    // html上拼接字体颜色字符
    _urlColorarr = @[@"#000000",@"#FF2600",@"#808080",@"#C35900"];
    _array = @[[UIColor blackColor],[UIColor redColor],
                       [UIColor grayColor],
                       [UIColor colorWithRed:0.76f green:0.35f blue:0.00f alpha:1.00f]];
    
}

#pragma mark -- 获取缓存文件夹内多有文件大小 并给sizeLabel赋值

-(void)getSize{
    
    _baespath = [[NSHomeDirectory()
                  stringByAppendingPathComponent :@"Documents"]
                 stringByAppendingPathComponent :@"ifreeNews"];
    
    _file = [NSFileManager defaultManager];
    
    if (![_file fileExistsAtPath:_baespath]) {
        [_file createDirectoryAtPath:_baespath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDictionary *dict= [_file attributesOfItemAtPath: _baespath error:nil];
    
    _size = [[dict objectForKey:NSFileSize] floatValue]/1024  - 0.07;
    
    NSString *str = [NSString stringWithFormat:@"%.2fKB",_size];
    
    _sizeLabel.text = str;
    
    NSLog(@"size:%@",str);
    
}


-(void)scrollViewConfig{
    
    CGRect frame = self.view.bounds;
    frame.size.height = self.view.frame.size.height * 2/ 3;
    frame.size.width = self.view.frame.size.width * 2 / 3;
    frame.origin.y = 24;
    
    _scrollView  = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(0, 45*_titleArray.count + 10);
    
#pragma mark -- 定义字体大小 每次运行时先从NSUserDefailts中取 并设定初始值
    
    _textFont = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 60, 7, 30, 30)];
    _textFont.backgroundColor = [UIColor whiteColor];
    _textFont.textColor = [UIColor blackColor];
    _textFont.layer.cornerRadius = 5;
    _textFont.clipsToBounds=YES;
    _textFont.textAlignment = NSTextAlignmentCenter;
    
    NSNumber *num = [[NSUserDefaults standardUserDefaults] valueForKey:@"font"];
    num = num == nil? @15 : num;
    _textFont.font = [UIFont systemFontOfSize:num.intValue];
    if ([num  isEqual: @12]) {
        _textFont.text = @"小";
    }else if ([num  isEqual: @20]){
        _textFont.text = @"大";
    }else{
        _textFont.text = @"中";
    }
    
#pragma mark -- 定义字体颜色 每次运行时先从NSUserDefailts中取 并设定初始值
    
    _textColor = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 60, 7, 30, 30)];
    _textColor.layer.cornerRadius = 5;
    _textColor.clipsToBounds=YES;
    
    NSString *color = [[NSUserDefaults standardUserDefaults] valueForKey:@"textColor"];
    if ([color isEqualToString: _urlColorarr[1]]) {
        _textColor.backgroundColor = _array[1];
    }else if([color isEqualToString: _urlColorarr[2]]){
        _textColor.backgroundColor = _array[2];
    }else if([color isEqualToString: _urlColorarr[3]]){
        _textColor.backgroundColor = _array[3];
    }else{
        _textColor.backgroundColor = _array[0];
    }
    
#pragma mark -- 显示缓存大小KB的label
    
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 100, 7, 70, 30)];
    _sizeLabel.backgroundColor = [UIColor clearColor];
    _sizeLabel.textAlignment = NSTextAlignmentCenter;
    _sizeLabel.textColor = [UIColor whiteColor];
    _sizeLabel.font = [UIFont systemFontOfSize:12];
    
    for (int i = 0; i < _titleArray.count; i ++) {
        CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 45 * i, _scrollView.frame.size.width, 44);
        [_scrollView addSubview:btn];
        
        [btn setImage:[UIImage imageNamed:_iconArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:_iconArray[i]] forState:UIControlStateHighlighted];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - 25, 15, 15, 15)];
        imgv.image = [UIImage imageNamed:@"三角"];
        
        i != 4? [btn addSubview:imgv]:nil;
        
        i == 0? [btn addSubview:_textFont]:nil;
        // 选择字体 按下时出现字体选择
        i == 1? [btn addSubview:_textColor]:nil;
        
        i ==_titleArray.count - 1 ? [btn addSubview:_sizeLabel]:nil;
        
        
        btn.tag = 720 + i;
        [btn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)chooseAction:(UIButton *)btn{
    NSInteger index = btn.tag - 720;
    
    NSArray *arr = @[@"大",@"中",@"小"];
    switch (index) {
        case 0:
        {
            if([_textFont.text isEqualToString:arr[0]]){
                _textFont.text = arr[1];
                _textFont.font = [UIFont systemFontOfSize:15];
                [[NSUserDefaults standardUserDefaults] setValue:@15 forKey:@"font"];
                
            }else if([_textFont.text isEqualToString:arr[1]]){
                _textFont.text = arr[2];
                _textFont.font = [UIFont systemFontOfSize:12];
                [[NSUserDefaults standardUserDefaults] setValue:@12 forKey:@"font"];
                
            }else{
                _textFont.text = arr[0];
                _textFont.font = [UIFont systemFontOfSize:20];
                [[NSUserDefaults standardUserDefaults] setValue:@20 forKey:@"font"];
            }
        }
            break;
        case 1:
        {
            if (_textColor.backgroundColor == _array[0]) {
                _textColor.backgroundColor = _array[1];
                [[NSUserDefaults standardUserDefaults] setValue:_urlColorarr[1] forKey:@"textColor"];
            }else if (_textColor.backgroundColor == _array[1]){
                _textColor.backgroundColor = _array[2];
                [[NSUserDefaults standardUserDefaults] setValue:_urlColorarr[2] forKey:@"textColor"];
            }else if (_textColor.backgroundColor == _array[2]){
                _textColor.backgroundColor = _array[3];
                [[NSUserDefaults standardUserDefaults] setValue:_urlColorarr[3] forKey:@"textColor"];
            }else{
                _textColor.backgroundColor = _array[0];
                [[NSUserDefaults standardUserDefaults] setValue:_urlColorarr[0] forKey:@"textColor"];
            }
        }
            break;
        case 2:
        {
            // 初始化stroyBoard
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FavoriteVC" bundle:nil];
            FavoriteVC *fvc = [storyboard instantiateViewControllerWithIdentifier:@"FavoriteVC"];
            
            [self.navigationController pushViewController:fvc animated:YES];
            
            // 动画 让_titleLabel在页面跳转的时候隐藏
            [UIView animateWithDuration:0.24 animations:^{
                _titleLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                _titleLabel.hidden = YES;
            }];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"favoriteChangeRight" object:nil];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            if (_size <= 0) {
                [_alertView show];// 缓存为0
            }else{
                [_sheet showInView:self.view];// 是否 清楚缓存
            }
        }
            break;
            
        default:
            break;
    }
}
@end
