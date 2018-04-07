//
//  DYExpectedItem.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYExpectedItem.h"

@interface DYExpectedItem ()

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation DYExpectedItem


-(UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-15);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
        }];
        
        
        _imageView = imageView;
    }
    return _imageView;
}

-(UILabel *)titleLabel
{
    
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel dy_configure];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(30);
        }];
        
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(void)setListModel:(dy_expected_list *)listModel
{
    _listModel = listModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:listModel.imageView] placeholderImage:DY_PlaceholderImage];
    
    self.titleLabel.text = listModel.title;
}

@end
