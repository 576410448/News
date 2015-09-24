//
//  ImageShow.m
//  News
//
//  Created by qianfeng on 15/9/5.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "ImageShow.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "MessageModel.h"
#import "CacheManager.h"

@interface ImageShow ()
{
    NSMutableArray *_array;
    NSString *_url;
}
@end

@implementation ImageShow

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidAction:) name:@"changHidden" object:nil];
}

#pragma mark -- 加载每个PageViewContrller的数据
-(void)prepareData{
    
    
    _array = [[NSMutableArray alloc] init];
    _url = [self getUrl];
        
    if ([[CacheManager cacheManager] isCacheName:_url]) {
        
        _isCache = YES;
        NSData *data = [[CacheManager cacheManager] getCacheForName:_url];
        [_array addObjectsFromArray:[MessageModel parsreMessage:data titleStr:nil]];
        
    }else{
        _isCache = NO;
        [self prepareImageData];
    }
    
}

-(void)cacheUI{
    
    // 创建所有控件
    if (!_imgv) {
        [self createUiImageView];
        [self createTextView];
        [self createPartitionLabel];
    }
    
    // PictureShow return对应的PageViewcontroller
    if (_callbackPageViewController) {
        _callbackPageViewController(1,@[[(MessageModel *)_array[0] title],
                                        @1,
                                        [(MessageModel *)_array[0] icon]]);
    }
}

-(void)prepareImageData{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:_url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_array addObjectsFromArray:[MessageModel parsreMessage:responseObject titleStr:nil]];
        
        [self createUiImageView];
        [self createTextView];
        [self createPartitionLabel];
        
        if (_callbackPageViewController) {
            _callbackPageViewController(1,@[[(MessageModel *)_array[0] title],
                                            @1,
                                            [(MessageModel *)_array[0] icon]]);
        }
        
        [[CacheManager cacheManager] saveCache:responseObject forName:_url];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_callbackPageViewController) {
            _callbackPageViewController(0,@[@"",@"",@""]);
        }
    }];
}

-(void)createUiImageView{
    
    _imgv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    
    [self.view insertSubview:_imgv atIndex:0];
    
    UIImage *img = [[SDWebImageManager  sharedManager]imageWithURL:[NSURL URLWithString:[(MessageModel *)_array[0] small_icon]]];
    
    [_imgv setImageWithURL:[NSURL URLWithString:[(MessageModel *)_array[0] icon]] placeholderImage:img];
    
    _imgv.contentMode = UIViewContentModeScaleAspectFit;
        
}

-(void)createTextView{
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 141, self.view.frame.size.width, 100)];
    _textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明黑28"]];
    _textView.editable = NO;
    [self.view addSubview:_textView];
    _textView.textColor = [UIColor whiteColor];
    _textView.text = [(MessageModel *)_array[0] des];
    
    if (self.isNavHidden == YES) {
        _textView.alpha = 0.0;
        _textView.hidden = YES;
        CGRect frame = _textView.frame;
        frame.origin.y = self.view.frame.size.height;
        _textView.frame = frame;
    }
}

-(void)createPartitionLabel{
    
    _partitionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 176, self.view.frame.size.width, 35)];
    _partitionLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"透明黑"]];
    [self.view addSubview:_partitionLabel];
    _partitionLabel.textColor = [UIColor whiteColor];
    _partitionLabel.text = [(MessageModel *)_array[0] title];
    
    if (self.isNavHidden == YES) {
        _partitionLabel.alpha = 0.0;
        _partitionLabel.hidden = YES;
        CGRect frame = _partitionLabel.frame;
        frame.origin.y = self.view.frame.size.height;
        _partitionLabel.frame = frame;
    }
    
}

-(NSString *)getUrl{
    NSString *urlStr = @"http://ktx.cms.palmtrends.com/api_v2.php?action=picture&sa=&uid=13886383&mobile=unkowniphone&offset=0&count=15&gid=%@&moblie=unkowniphone&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i";
    return [NSString stringWithFormat:urlStr,_gidArray[_currentPage]];
}


-(void)hidAction:(NSNotification *)tap{
    
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat labelHeight = _partitionLabel.frame.size.height;
    CGFloat textHeight = _textView.frame.size.height;
    CGFloat tabHeight = 41;
    
    __block CGRect textViewFrame = _textView.frame;
    __block CGRect labelFrame = _partitionLabel.frame;
    
    [UIView animateWithDuration:0.24 animations:^{
        if (_textView.alpha == 1.0 ) {
            _partitionLabel.alpha = 0.0;
            _textView.alpha = 0.0;
            
            textViewFrame.origin.y = viewHeight;
            _textView.frame = textViewFrame;
            labelFrame.origin.y = viewHeight;
            _partitionLabel.frame = labelFrame;
            
        }else{
            _textView.hidden = NO;
            _partitionLabel.hidden = NO;
            
            textViewFrame.origin.y = viewHeight-textHeight - tabHeight;
            _textView.frame = textViewFrame;
            
            labelFrame.origin.y = viewHeight- labelHeight - textHeight - tabHeight;
            _partitionLabel.frame = labelFrame;
            
            _partitionLabel.alpha = 1.0;
            _textView.alpha = 1.0;
        }
        
    } completion:^(BOOL finished) {
        if (_textView.alpha == 0.0) {
            _partitionLabel.hidden = YES;
            _textView.hidden = YES;
        }
        
    }];
    
}


// 将点击事件回传
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changHidden" object:nil];
    
    if (_callbackTap) {
        _callbackTap();
    }
    
}


@end
