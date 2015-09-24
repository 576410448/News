//
//  ClassPictureButton.m
//  News
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "ClassPictureButton.h"

@implementation ClassPictureButton

- (instancetype)initWithFrame:(CGRect)fr
{
    self = [super initWithFrame:fr];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(3, 5, self.frame.size.width - 6, self.frame.size.height - 40);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(2, self.frame.size.height - 39, self.frame.size.width - 6, 25);
}

@end
