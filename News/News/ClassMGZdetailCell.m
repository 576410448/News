//
//  ClassMGZdetailCell.m
//  News
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "ClassMGZdetailCell.h"
#import "UIImageView+WebCache.h"

@implementation ClassMGZdetailCell

- (void)awakeFromNib {
    CGRect frame = _iconImage.bounds;
    frame.origin.x = - 3 ;
    frame.origin.y = - 3 ;
    frame.size.width = _iconImage.frame.size.width + 6 ;
    frame.size.height = _iconImage.frame.size.height + 6 ;
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:frame];
    [imgv setImage:[UIImage imageNamed:@"缺省图"]];
    [_iconImage addSubview:imgv];
}

-(void)setModel:(MessageModel *)model{
    
    _model = model;
    
//    _backImage.image = [UIImage imageNamed:@"微话题列表底_1.png"];
    
    _titleLabel.text = model.title;
    _litLabel.text = model.author;
    [_iconImage setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
    _bigLabel.text = model.desc;
    
}
@end
