//
//  DY_FilmReviewCell.m
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import "DY_FilmReviewCell.h"

#import "UIView+CommonView.h"

@interface DY_FilmReviewCell ()

@property (nonatomic,strong)UIImageView *leftImageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *movieNameLabel;

@property (nonatomic,strong)UILabel *typeLabel;

@property (nonatomic,strong)UILabel *descLabel;

@property (nonatomic,strong)UIButton *scoresBtn;


@end

@implementation DY_FilmReviewCell

+ (CGFloat)cellHeight {
    return 112.f;
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
    [self.contentView addSubview:leftImageView];
    _leftImageView = leftImageView;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel dy_configure];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UILabel *movieNameLabel = [[UILabel alloc] init];
    [movieNameLabel initTagsViewWithColor:[UIColor redColor]];
    [self.contentView addSubview:movieNameLabel];
    _movieNameLabel = movieNameLabel;
    
    UILabel *typeLabel = [[UILabel alloc] init];
    [typeLabel initTagsViewWithColor:kUIColorFromRGB(0x2aa515)];
    [self.contentView addSubview:typeLabel];
    _typeLabel = typeLabel;
    
    UIButton *scoresBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scoresBtn dy_configure];
    [scoresBtn setTitleColor:[UIColor blackColor] forState:0];
    scoresBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [scoresBtn setBackgroundColor:[UIColor clearColor]];
    [scoresBtn setImage:[UIImage imageNamed:@"icon_scores_small"] forState:0];
    [self.contentView addSubview:scoresBtn];
    
    _scoresBtn = scoresBtn;
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel dy_configure];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.numberOfLines = 3;
    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:descLabel];
    _descLabel = descLabel;

    [self _setLayoutSubviews];
}

- (void)_setLayoutSubviews {
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.width.height.mas_equalTo([DY_FilmReviewCell cellHeight]-16);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(20);
    }];

    [_movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(4);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.height.mas_equalTo(16);
    }];

    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_movieNameLabel);
        make.left.equalTo(_movieNameLabel.mas_right).offset(4);
        make.height.mas_equalTo(16);
    }];
    
    [_scoresBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_movieNameLabel.mas_bottom).offset(4);
        make.left.equalTo(_movieNameLabel);
        make.height.mas_equalTo(16);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scoresBtn.mas_bottom).offset(4);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.bottom.lessThanOrEqualTo(_leftImageView.mas_bottom);
    }];

    
}





- (void)setFilmModel:(DY_FilmReviewModel *)filmModel {
    _filmModel = filmModel;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:filmModel.movieImgUrl] placeholderImage:CC_PlaceholderImage];;
    self.titleLabel.text = filmModel.title;
    self.movieNameLabel.text = [NSString stringWithFormat:@" %@ ",filmModel.movieName];
    self.typeLabel.text = [NSString stringWithFormat:@" %@ ",filmModel.commentType];
    self.descLabel.text = filmModel.movieDesc;
    
    [self.scoresBtn setTitle:[NSString stringWithFormat:@" +%@",filmModel.scores] forState:0];
}


@end
