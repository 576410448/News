//
//  MessageCell.m
//  News
//
//  Created by qianfeng on 15/8/28.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MessageCell.h"
#import "UIImageView+WebCache.h"
@implementation MessageCell

- (void)awakeFromNib {
    CGRect frame = _newsImage.bounds;
    frame.origin.x = - 3 ;
    frame.origin.y = - 3 ;
    frame.size.width = _newsImage.frame.size.width + 6 ;
    frame.size.height = _newsImage.frame.size.height + 6 ;
    
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:frame];
    [imgv setImage:[UIImage imageNamed:@"缺省图阴影"]];
    [_newsImage addSubview:imgv];
}

-(void)setModel:(MessageModel *)model{
    _model = model;
    
    _backImageV.image = [UIImage imageNamed:@"微话题列表底_1.png"];
    _newsContent.text = model.desc;
    _newsTitle.text = model.title;
    _newsTime.text = model.pub_time;
    _magazineLabel.text = [NSString stringWithFormat:@"%@年第%@期  %@",model.year,model.vol_year,model.pub_time];
    _magazineLabel.font = [UIFont systemFontOfSize:12];
    
    if ([model.titleStr isEqualToString:@"资讯"]) {
        _magazineLabel.hidden = YES;
        [_newsImage setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"缺省图"]];
    }else{
        _littleTimeImageV.hidden = YES;
        _newsTime.hidden = YES;
//         图片偏大，需要优化
        [_newsImage setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"缺省图"]];
    }
    
    
    
}

@end
