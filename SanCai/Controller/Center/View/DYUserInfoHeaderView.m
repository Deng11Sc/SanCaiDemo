//
//  DYUserInfoHeaderView.m
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYUserInfoHeaderView.h"

#import "NSString+Common.h"

@interface DYUserInfoHeaderView ()

@property (nonatomic,strong)UIImageView *headBtn;

@property (nonatomic,strong)UILabel *nameLabel;

@end

@implementation DYUserInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubviews];
    }
    return self;
}

-(void)_initSubviews
{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"bg_image_header"];
    [self addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *headBtn = [[UIImageView alloc] init];
    [headBtn dy_configure];
    headBtn.image = DY_Default_Avatar;
    @weakify(self)
    [headBtn addClickedBlock:^(id obj) {
        @strongify(self)
        if (self.clickHeadBlk) {
            self.clickHeadBlk();
        }
    }];
    headBtn.clipsToBounds = YES;
    [self addSubview:headBtn];
    _headBtn = headBtn;
    
    headBtn.layer.cornerRadius = 32;
    [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-15);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel dy_configure];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headBtn.mas_bottom).offset(5);
        make.height.equalTo(@(25));
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
}

- (void)setUserInfo:(DYUserInfoModel *)userInfo
{
    _userInfo = userInfo;
    
    if (userInfo) {
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[userInfo.imageUrl getImageCompleteUrl]] placeholderImage:DY_Default_Avatar];
        self.nameLabel.text = userInfo.nickName;
    } else {
        self.headBtn.image = DY_Default_Avatar;
        self.nameLabel.text = DYLocalizedString(@"Login", @"登陆");
    }
    
}


@end
