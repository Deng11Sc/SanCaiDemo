//
//  DY_MovieListCell.m
//  SanCai
//
//  Created by SongChang on 2018/4/17.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_MovieListCell.h"

#import "NSString+Common.h"

@interface DY_MovieListCell ()

@property (nonatomic,strong)UIImageView *leftImageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *releaseTimeLabel;

@property (nonatomic,strong)UILabel *languageLabel;

@property (nonatomic,strong)UILabel *typeLabel;

@property (nonatomic,strong)UILabel *descLabel;


@end


@implementation DY_MovieListCell

+ (CGFloat)cellHeight {
    return 140.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initSubview];
    }
    return self;
}

- (void)_initSubview
{
    UIImageView *leftImageView = [[UIImageView alloc] init];
    [leftImageView dy_configure];
    leftImageView.clipsToBounds = YES;
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:leftImageView];
    _leftImageView = leftImageView;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel dy_configure];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *releaseTimeLabel = [[UILabel alloc] init];
    [releaseTimeLabel dy_configure];
    [self.contentView addSubview:releaseTimeLabel];
    _releaseTimeLabel = releaseTimeLabel;
    
    UILabel *languageLabel = [[UILabel alloc] init];
    [languageLabel dy_configure];
    [self.contentView addSubview:languageLabel];
    _languageLabel = languageLabel;

    
    UILabel *typeLabel = [[UILabel alloc] init];
    [typeLabel dy_configure];
    [self.contentView addSubview:typeLabel];
    _typeLabel = typeLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel dy_configure];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.numberOfLines = 6;
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:descLabel];
    _descLabel = descLabel;
    
    
    [self _setLayoutSubviews];
}

- (void)_setLayoutSubviews {
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.height.mas_equalTo([DY_MovieListCell cellHeight]-16);
        make.width.equalTo(_leftImageView.mas_height).multipliedBy(0.8);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.height.mas_equalTo(20);
    }];
    
    [_releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.height.mas_equalTo(20);
    }];
    
    [_languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_releaseTimeLabel.mas_top);
        make.left.equalTo(_releaseTimeLabel.mas_right).offset(8);
        make.height.mas_equalTo(20);
    }];

    
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_releaseTimeLabel.mas_bottom);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.height.mas_equalTo(20);
    }];
    
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeLabel.mas_bottom);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
    }];
    
}

-(void)setDescModel:(DY_MovieDescModel *)descModel
{
    _descModel = descModel;
    
    NSString *url = [NSString isEmptyString:descModel.imageUrl]?descModel.movieImg:descModel.imageUrl;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:CC_PlaceholderImage];
    
    self.titleLabel.text = descModel.movieName;
    
    self.releaseTimeLabel.text = descModel.releaseTime;

    self.languageLabel.text = descModel.language;

    self.typeLabel.text = descModel.movieType;
    
    self.descLabel.text = [descModel.movieDesc getSubTitle];
}


@end
