//
//  DY_ShopListCell.m
//  SanCai
//
//  Created by SongChang on 2018/4/16.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_ShopListCell.h"

@interface DY_ShopListCell ()

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *scoresLabel;

@end

@implementation DY_ShopListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-25);
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
            make.height.mas_equalTo(20);
        }];
        
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

-(UILabel *)scoresLabel
{
    
    if (!_scoresLabel) {
        UILabel *scoresLabel = [[UILabel alloc] init];
        [scoresLabel dy_configure];
        scoresLabel.textColor = [UIColor redColor];
        scoresLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:scoresLabel];
        
        [scoresLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(20);
        }];
        
        _scoresLabel = scoresLabel;
    }
    return _scoresLabel;
}


- (void)setListModel:(DY_ShopListModel *)listModel {
    _listModel = listModel;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:listModel.imageUrl] placeholderImage:DY_PlaceholderImage];
    
    self.titleLabel.text = listModel.mallGoodsName;
    self.scoresLabel.text = [NSString stringWithFormat:@"%@%@",DYLocalizedString(@"Price:", nil),listModel.priceScores];
    
}


@end
