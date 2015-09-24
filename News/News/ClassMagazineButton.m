//
//  ClassMagazineButton.m
//  News
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "ClassMagazineButton.h"

@implementation ClassMagazineButton

- (instancetype)initWithFrame:(CGRect)fr
{
    self = [super initWithFrame:fr];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 20);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(2, self.frame.size.height - 20, self.frame.size.width - 4, 18);
}

@end
