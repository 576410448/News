//
//  MagazineDetailButton.m
//  News
//
//  Created by qianfeng on 15/9/2.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MagazineDetailButton.h"

@implementation MagazineDetailButton

- (instancetype)initWithFrame:(CGRect)f
{
    self = [super initWithFrame:f];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor colorWithRed:0.24f green:0.55f blue:0.95f alpha:1.00f] forState:UIControlStateSelected];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(25, contentRect.size.height - 25, self.frame.size.width - 25, 20);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, contentRect.size.height - 20, 10, 10);
}

@end
