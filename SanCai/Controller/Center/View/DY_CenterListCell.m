//
//  DY_CenterListCell.m
//  SanCai
//
//  Created by SongChang on 2018/4/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_CenterListCell.h"

@interface DY_CenterListCell ()

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation DY_CenterListCell


-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //initialize code...
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = CC_CustomColor_F5F4F3;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-1);
            make.height.equalTo(@1);
        }];
    }
    
    return self;
    
}




-(UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-10);
            make.width.height.mas_equalTo(32);
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

- (void)setImage:(UIImage *)image title:(NSString *)title
{
    self.imageView.image = image;
    self.titleLabel.text = title;
}

@end
