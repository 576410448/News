//
//  DetailTabBarButton.m
//  News
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "DetailTabBarButton.h"

@implementation DetailTabBarButton

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake((contentRect.size.width - 41)/2, 5, 41, 30);
}


@end
