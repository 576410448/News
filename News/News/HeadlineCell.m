//
//  HeadlineCell.m
//  News
//
//  Created by qianfeng on 15/9/11.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "HeadlineCell.h"
#import "UIImageView+WebCache.h"

@implementation HeadlineCell
{
    UILabel *_tags;
}
- (void)awakeFromNib {
    _tags = [[UILabel  alloc] init];
}

-(void)setModel:(HeadlineModel *)model{
    _model = model;
    
    [_iconImgv setImageWithURL:[NSURL URLWithString:_model.thumb] placeholderImage:[UIImage imageNamed:@"缺省图"]];
    
    _titlab.text = _model.title;
    
    _tags.text = _model.tags;
    
    ////////////////
    if(_model.tags){
        _tags.layer.borderWidth = 0.5;
        _tags.layer.cornerRadius = 3;
        _tags.layer.borderColor = [UIColor blueColor].CGColor;
        _tags.textColor = [UIColor blueColor];
        _tags.textAlignment = NSTextAlignmentCenter;
        _tags.font = [UIFont systemFontOfSize:13];
        [self addSubview:_tags];
        
#pragma mark -- 根据文字内容获取label宽度
        CGSize size = CGSizeMake(320,2000);  //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: _tags.font};
        
        CGSize labelSize = [_tags.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        
        _tags.frame = CGRectMake(self.frame.size.width - labelSize.width - 15,
                                 self.frame.size.height - labelSize.height - 15, labelSize.width + 10, labelSize.height + 8);
    }else{ // tags 不存在的时候 隐藏Label
        _tags.hidden = YES;
    }
    
    

}
@end
