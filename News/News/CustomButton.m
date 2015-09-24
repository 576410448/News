//
//  CustomButton.m
//  News
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tintColor = [UIColor whiteColor];
    }
    return self;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(45, 7, self.frame.size.width - 70, 30);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(5, 6, 30, 30);
}

@end
