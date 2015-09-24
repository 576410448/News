//
//  FavoriteVC.m
//  News
//
//  Created by qianfeng on 15/9/16.
//  Copyright © 2015年 LiJiangTao. All rights reserved.
//

#import "FavoriteVC.h"
#import "CoreDataManager.h"
#import "FavoriteNewsModel.h"
#import "DetailsViewController.h"
#import "PhotosViewC.h"
#import "UIButton+WebCache.h"
#import "Masonry.h"

#define angelToRandian(x)  ((x)/180.0*M_PI)

@interface FavoriteVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *deleteImgv;

@property (nonatomic, strong) NSMutableArray *dataArr; // 新闻收藏
@property (nonatomic, strong) NSMutableArray *imageArray;// 图片收藏
@property (nonatomic, strong) CoreDataManager *manager;
@property (nonatomic, assign) NSInteger deleteIndex;

@end

@implementation FavoriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.tableView.rowHeight = 70;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"新闻",@"图片"]];
    self.navigationItem.titleView = seg;
    seg.selectedSegmentIndex = 0;
    
    // 添加seg选择事件
    [seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    [self prepareData]; // 先加载数据
    [self createScrollerView]; // 创建滑动控件
    [self createPrograma]; // 创建点击控件
    
    self.scrollView.hidden = YES;
    
    // 自定义leftBarButton
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 55, 32);
    
    [btn setImage:[UIImage imageNamed:@"返回2_1"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"返回2_2"] forState:UIControlStateHighlighted];
    
    [btn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
}

- (void)prepareData{
    
    _dataArr = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    _manager = [CoreDataManager sharedCoreDataManager];
    
    NSArray *fetchResult = [_manager showAllObjInCoreDataisImage:NO];
    NSArray *imageArr = [_manager showAllObjInCoreDataisImage:YES];
    
    [self.dataArr removeAllObjects];
    [self.imageArray removeAllObjects];
    
    [self.dataArr addObjectsFromArray:fetchResult];
    [self.imageArray addObjectsFromArray:imageArr];
    
    [self.tableView reloadData];
}

-(void)segmentAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    
    if (index == 0) {
        self.scrollView.hidden = YES;
        self.tableView.scrollEnabled = YES;
    }else{
        self.scrollView.hidden = NO;
        self.tableView.scrollEnabled = NO;
    }
    
}

-(void)popAction{
    // 通知将抽屉打开
    // 在Headline 视图控制器中接受通知
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favoriteChangeLeft" object:nil];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
    }
    
    FavoriteNewsModel *model = [_dataArr objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"收藏夹"];
    cell.textLabel.text = model.newsTitle;
    cell.detailTextLabel.text = model.newsUrl;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _model = [_dataArr objectAtIndex:indexPath.row];
    
    DetailsViewController *detailVC = [[DetailsViewController alloc] init];
    detailVC.isFavorite = YES;
    detailVC.dtlTitle = _model.newsTitle;
    detailVC.webUrl = _model.newsUrl;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 移除收藏
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    _model = [_dataArr objectAtIndex:indexPath.row];
    
    // 从数据库中删除
    [[CoreDataManager sharedCoreDataManager] deleteFromeCoreData:_model];
    
    // 从数据源中删除
    [_dataArr removeObject:_model];
    
    // 删除cell
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)createScrollerView{
    
    CGRect frame = self.view.bounds ;
    frame.size.height -= 64;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO; // 不显示scrollView竖直方向滚动条
    // 使用手动约束时。ScrollerView的contentSize无法在外面进行确定，只能通过scrollereView中的控件约束进行
}

-(void)createPrograma{ // 270* 164 135 * 82
    
    __block CGFloat weight = self.view.frame.size.width/2 - 25;
    __block CGFloat height = weight *100/135;
    
    UIButton *lastBtn;
    for (int i = 0; i < _imageArray.count; i ++) {
        
        FavoriteNewsModel *model = _imageArray[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor greenColor];
        [btn setImageWithURL:[NSURL URLWithString:model.newsUrl] placeholderImage:[UIImage imageNamed:@"缺省图"]];
        _deleteImgv = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -5, 20, 20)];
        _deleteImgv.image = [UIImage imageNamed:@"Login_Close"];
        _deleteImgv.userInteractionEnabled = YES;
        
        _deleteImgv.hidden = YES;
        _deleteImgv.tag = 130 + i;
        
        [btn addSubview:_deleteImgv];
        [_scrollView addSubview:btn];
        
        UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] init];
        [_deleteImgv addGestureRecognizer:deleteTap];
        [deleteTap addTarget:self action:@selector(deleteGest:)];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            
            if (i == 0) {
                make.left.equalTo(@20);
                make.top.equalTo(@10);
                make.height.equalTo(@(height));
                make.width.equalTo(@(weight));
            }else if (i % 2 == 1){
                make.left.equalTo(lastBtn.mas_right).offset(10);
                make.right.equalTo(@-20);
                make.top.equalTo(lastBtn);
                make.bottom.equalTo(lastBtn.mas_bottom);
                make.size.equalTo(lastBtn);
            }else{
                make.left.equalTo(@20);
                make.top.equalTo(lastBtn.mas_bottom).offset(15);
                make.size.equalTo(lastBtn);
            }
            // 根据scrollerView中的控件确定scrollerView的contentSize
            if (i == _imageArray.count - 1) {
                make.bottom.equalTo(@-10);
            }
        }];
        lastBtn = btn;
        
        btn.tag = 450 + i;
        [btn addTarget:self action:@selector(showBigPicture:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] init];
        [btn addGestureRecognizer:longGest];
        
        [longGest addTarget:self action:@selector(longGest)];
    }
}

-(void)showBigPicture:(UIButton *)button{
    
    NSInteger index = button.tag - 450;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (FavoriteNewsModel *model in _imageArray) {
        [arr addObject:model.newsUrl];
    }
    
    PhotosViewC *pvc = [[PhotosViewC alloc] init];
    pvc.page = index;
    pvc.phoArr = arr;
    [self presentViewController:pvc animated:YES completion:nil];
}

#pragma mark -- 显示删除按钮 模拟系统APP颤抖效果
- (void)longGest{
    
    for (int i = 0; i < _imageArray.count; i ++) {
        NSInteger index = 130 + i;
        _deleteImgv = (UIImageView *)[self.view viewWithTag:index];
        _deleteImgv.hidden = NO;
        
        CAKeyframeAnimation* anim=[CAKeyframeAnimation animation];
        anim.keyPath=@"transform.rotation";
        anim.values=@[@(angelToRandian(-7)),@(angelToRandian(7)),@(angelToRandian(-7))];
        anim.repeatCount=MAXFLOAT;
        anim.duration=0.2;
        [_deleteImgv.layer addAnimation:anim forKey:nil];
        
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:450 + i];
        
        CAKeyframeAnimation* anim2=[CAKeyframeAnimation animation];
        anim2.keyPath=@"transform.rotation";
        anim2.values=@[@(angelToRandian(-1)),@(angelToRandian(1)),@(angelToRandian(-1))];
        anim2.repeatCount=MAXFLOAT;
        anim2.duration=0.2;
        [btn.layer addAnimation:anim2 forKey:nil];
    }
    
}

#pragma mark -- alertView显示 确认删除？
- (void)deleteGest:(UITapGestureRecognizer *)tap{
    
    _deleteIndex = tap.view.tag - 130;
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"删除图片" message:@"删除后将会从收藏中移除" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"取消", nil];
    
    [deleteAlert show];
}

#pragma mark -- alertView选择
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"删除");
            _model = [_imageArray objectAtIndex:_deleteIndex];
            
            // 从数据库中删除
            [[CoreDataManager sharedCoreDataManager] deleteFromeCoreData:_model];
            
            // 从数据源中删除
            [_imageArray removeObject:_model];
            
            // 删除buton
            
            UIView *view = self.scrollView.subviews[_deleteIndex];
            
            [UIView animateWithDuration:0.24 animations:^{
                view.alpha = 0.0;
            } completion:^(BOOL finished) {
                view.hidden = YES;
            }];
            
            // 删除后刷新界面及数据
            [self noAction];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    for (int i = 0; i < _imageArray.count; i ++) {
        NSInteger index = 130 + i;
        _deleteImgv = (UIImageView *)[self.view viewWithTag:index];
        _deleteImgv.hidden = YES;
    }
}

#pragma mark -- 数据及界面变更后刷新
-(void)noAction{
    [self prepareData];
    
    for (int i = (int)self.scrollView.subviews.count - 1; i >= 0; i --) {
        UIView *view = self.scrollView.subviews[i];
        [view removeFromSuperview];
    }
    
    [self createPrograma];
}

@end
