//
//  DYWinningCell.m
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYWinningCell.h"

@interface DYWinningCell ()

@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *descLabel;

@property (nonatomic,strong)UILabel *statusLabel;


@end


@implementation DYWinningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initSubviews];
    }
    return self;
}

-(void)_initSubviews {
    
}


-(UIImageView *)imgView
{
    if (!_imgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self.contentView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-4);
            make.top.mas_equalTo(4);
            make.left.mas_equalTo(12);
            make.width.equalTo(imageView.mas_height).multipliedBy(1);
        }];
        
        _imgView = imageView;
    }
    return _imgView;
}

-(UILabel *)titleLabel
{
    
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel dy_configure];
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_top);
            make.left.equalTo(self.imgView.mas_right).offset(4);
            make.height.mas_equalTo(20);
        }];
        
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}


-(UILabel *)descLabel
{
    
    if (!_descLabel) {
        UILabel *descLabel = [[UILabel alloc] init];
        [descLabel dy_configure];
        descLabel.numberOfLines = 3;
        descLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.titleLabel.mas_left);
            make.right.mas_equalTo(-12);
            make.bottom.equalTo(self.contentView).offset(-4);
        }];
        
        _descLabel = descLabel;
    }
    return _descLabel;
}


-(UILabel *)statusLabel
{
    
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        [statusLabel dy_configure];
        statusLabel.font = [UIFont systemFontOfSize:12];
        [statusLabel.layer setCornerRadius:3];
        [statusLabel.layer setBorderWidth:0.5];
        [self.contentView addSubview:statusLabel];
        
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(8);
            make.height.top.equalTo(self.titleLabel);
        }];
        
        _statusLabel = statusLabel;
    }
    return _statusLabel;
}

-(void)setWinModel:(DYWinningModel *)winModel {
    _winModel = winModel;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:winModel.goodsImageUrl] placeholderImage:DY_PlaceholderImage];
    self.titleLabel.text = winModel.goodsName;
    self.descLabel.text = winModel.goodsDes;
    
    if ([NSString isEmptyString:winModel.address]) {
        self.statusLabel.text = @"未领取";
        [_statusLabel.layer setBorderColor:[UIColor redColor].CGColor];
        _statusLabel.textColor = [UIColor redColor];

    } else {
        self.statusLabel.text = @"已领取";
        [_statusLabel.layer setBorderColor:[UIColor greenColor].CGColor];
        _statusLabel.textColor = [UIColor greenColor];
    }
    
    
}



@end
