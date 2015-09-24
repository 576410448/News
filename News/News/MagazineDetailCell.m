//
//  MagazineDetailCell.m
//  News
//
//  Created by qianfeng on 15/8/30.
//  Copyright (c) 2015年 LiJiangTao. All rights reserved.
//

#import "MagazineDetailCell.h"
#import "MagazineDetailsViewController.h"
#import "MagazineDetailButton.h"
#import "DetailsViewController.h"

@implementation MagazineDetailCell
{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UITextView *_textView;
    
    NSMutableArray *_idArray;
    NSMutableArray *_detailTitleArray;
    
}

- (void)awakeFromNib {
    
}

#pragma mark -- 调节图片大小为ImageView大小

- (UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]; // 个角度20像素不变形
    
    [image drawInRect:CGRectMake(10, 10, size.width - 20, size.height - 20)];
    
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
    
}

- (void)setMessModel:(MessageModel *)messModel{
    
    //  标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, self.frame.size.width - 50, 28)];
    [self addSubview:_titleLabel];
    
    // 时间Label
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 36, self.frame.size.width - 50, 20)];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_timeLabel];
    
    // 详情Label
    _textView = [[UITextView alloc] init];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.scrollEnabled = NO;        // 禁止TextView滚动效果
    _textView.editable = NO;             // 禁止textView键盘输入
    _textView.text = messModel.desc;
    [self addSubview:_textView];
    
#pragma mark -- 根据详情Label取cell高度
    
    CGSize size = CGSizeMake(320,2000);  //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: _textView.font};
    
    CGSize labelSize = [_textView.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    
    _textView.frame = CGRectMake(25, 55, self.frame.size.width - 50, labelSize.height + 30);
    
    CGRect frame = self.frame;
    frame.size.height = _textView.frame.size.height + 60.00;
    NSInteger cellOfHeight = frame.size.height;
    self.frame = frame;
    
#pragma mark -- 将cell高度callBack
    if (_callback) {
        _callback(cellOfHeight);
    }
    
    // cell背景图片
    UIImageView *backImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIImage *image = [UIImage imageNamed:@"微话题列表底_11.png"];
    UIImage *img = [self OriginImage:image scaleToSize:backImgv.frame.size];
    backImgv.image = img;
    [self insertSubview:backImgv atIndex:0];
    
    _titleLabel.text = messModel.title;
    _timeLabel.text = messModel.pub_time;
    
}

-(void)setModel:(MagazineDetailModel *)model{
    
    _idArray = [[NSMutableArray alloc] init];
    _detailTitleArray = [[NSMutableArray alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, self.frame.size.width - 50, 18)];
    label.text =  model.cat_name;
    [self addSubview:label];
    
    
    NSInteger height = 0;
    if (![model.list isEqual:[NSNull null]]&&![model.list isEqual:@""]){
        for (int i = 0; i < model.list.count ; i ++) {
            
            MagazineDetailButton *btn = [MagazineDetailButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(25, 33 + 28 * i, self.frame.size.width - 50, 28);
            btn.tag = 350 + i;
            NSDictionary *dic = model.list[i];
            NSString *detailT = dic[@"title"];
            NSString *ID = dic[@"id"];
            [_idArray addObject:ID];
            [_detailTitleArray addObject:detailT];
            
            [btn setTitle:_detailTitleArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"五角星_2"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            UIImageView *lineImgv = [[UIImageView alloc] initWithFrame:CGRectMake(25, 55 + 29 * i, self.frame.size.width - 50, 2)];
            lineImgv.image = [UIImage imageNamed:@"内文评论分割线"];
            [self addSubview:lineImgv];
            
            height = height + btn.frame.size.height;
        }
    }
    CGRect frame = self.frame;
    frame.size.height = height + 50.00;
    height = frame.size.height;
    self.frame = frame;
    
    
    
    UIImageView *backImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIImage *image = [UIImage imageNamed:@"微话题列表底_11.png"];
    UIImage *img = [self OriginImage:image scaleToSize:backImgv.frame.size];
    backImgv.image = img;
    [self insertSubview:backImgv atIndex:0];
    
    if (_callBack) {
        _callBack(height);
    }
}

-(void)pushAction:(UIButton *)btn{
    NSInteger index = btn.tag - 350;
    NSString *ID = _idArray[index];
    NSString *detailT = _detailTitleArray[index];
    if (_callbackAction) {
        _callbackAction(ID,detailT);
    }
}

@end
