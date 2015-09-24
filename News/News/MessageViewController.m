//
//  MessageViewController.m
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MessageViewController.h"
#import "DetailsViewController.h"
#import "MagazineDetailsViewController.h"
#import "ClassMagazineVC.h"

@interface MessageViewC : NSObject

@property (nonatomic ,assign) NSInteger vcType;

-(NSString *)getUrlStr;

-(NSString *)getTitle;

@end

@implementation MessageViewC

-(NSString *)getUrlStr{
    return @[
             @"",
             @"http://ktx.cms.palmtrends.com/api_v2.php?action=home_list&sa=&uid=13886383&mobile=unkowniphone&offset=%d&count=15&&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i",
             @"http://ktx.cms.palmtrends.com/api_v2.php?action=get_mags_list&sa=&uid=13886383&mobile=unkowniphone&offset=%d&count=15&&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i",
             @"http://ktx.cms.palmtrends.com/api_v2.php?action=piclist&sa=&uid=13886383&mobile=unkowniphone&offset=0&count=9&&e=0229e7fd20959df148a1077d9e517faa&uid=13886383&pid=10053&mobile=iphone5&platform=i"][_vcType];
}

-(NSString *)getTitle{
    return @[@"头条",@"资讯",@"杂志",@"酷图"][_vcType];
}

@end


@interface MessageViewController ()
{
    MessageViewC *_mvcConfig;
    UIBarButtonItem *_leftBarButton;
    
    
    
    
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mvcConfig = [[MessageViewC alloc] init];
    _mvcConfig.vcType = self.vcType;
    
    if (_tString != nil) {
        self.titleStr = _tString;
        self.urlForStr = _uString;
        self.cellForString = @"ClassMGZdetailCell";
    }else{
        self.titleStr = [_mvcConfig getTitle];
        self.urlForStr = [_mvcConfig getUrlStr];
        self.cellForString = @"MessageCell";
    }
    
    self.cellForHeight = 136;
    
    self.modelForStirng = @"MessageModel";
    
    self.isXib = YES;
    
    self.page = 0;
    
    [self startConfig];
    
    [self reFresh];
    
    if (![self.titleStr isEqualToString:@"资讯"]) {
        [self creatLeftBarButton];
        self.navigationItem.leftBarButtonItem = _leftBarButton;
    }
    
    
}

#pragma mark -- 自定义leftBarButton

-(void)creatLeftBarButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([self.titleStr isEqualToString:@"杂志"]) {
        
        btn.frame = CGRectMake(0, 0, 35, 35);
        
        [btn setImage:[UIImage imageNamed:@"切换_1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"切换_2"] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        btn.frame = CGRectMake(0, 0, 55, 32);
        
        [btn setImage:[UIImage imageNamed:@"返回_1"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"返回_2"] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
}




#pragma mark -- 自定义push 与 pop 动画
-(void)popViewController{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}


#pragma mark -- 杂志界面leftBarButton 点击
-(void)pushViewController{
    
    ClassMagazineVC *nextView=[[ClassMagazineVC alloc] init];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    [self.navigationController pushViewController:nextView animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.row == self.dataArray.count) {
        return;
    }else if(!self.isLoading && [self.titleStr isEqualToString:@"杂志"]){
        MagazineDetailsViewController *mgzVC = [[MagazineDetailsViewController alloc] init];
        mgzVC.messModel = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:mgzVC animated:YES];
    }else{
        
        DetailsViewController *detvc = [[DetailsViewController alloc] init];
        detvc.hidesBottomBarWhenPushed = YES;
        detvc.modelArray = self.dataArray;
        detvc.numOfRow = indexPath.row;
        [self.navigationController pushViewController:detvc animated:YES];
    }
}



@end
