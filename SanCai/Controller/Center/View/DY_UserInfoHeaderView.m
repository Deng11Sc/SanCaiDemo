//
//  DY_UserInfoHeaderView.m
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_UserInfoHeaderView.h"

#import "NSString+Common.h"

@interface DY_UserInfoHeaderView ()

@property (nonatomic,strong)UIImageView *headBtn;

@property (nonatomic,strong)UILabel *nameLabel;

@end

@implementation DY_UserInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dy_initSubviews];
    }
    return self;
}

-(void)dy_initSubviews
{
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"bg_image_header"];
    [self addSubview:bgImageView];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *headBtn = [[UIImageView alloc] init];
    [headBtn dy_configure];
    headBtn.image = CC_Default_Avatar;
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
    
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trueBtn dy_configure];
    trueBtn.backgroundColor =kUIColorFromRGB_Alpa(0xFFFFFF, 0.8);
    [trueBtn.layer setCornerRadius:4];
    trueBtn.clipsToBounds = YES;
    [trueBtn setTitle:DYLocalizedString(@"sign in", nil) forState:0];
    [trueBtn setTitleColor:kUIColorFromRGB(0x2089ff) forState:0];
    [trueBtn addTarget:self action:@selector(dy_markAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:trueBtn];
    _markBtn = trueBtn;

    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.width.mas_equalTo(90);
        make.top.mas_equalTo(16);
        make.height.equalTo(@35);
    }] ;
    
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

- (void)dy_markAction {
    if (self.markBlk) {
        self.markBlk();
    }
}

- (void)setUserInfo:(DY_UserInfoModel *)userInfo
{
    _userInfo = userInfo;
    
    if (userInfo) {
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[userInfo.imageUrl getImageCompleteUrl]] placeholderImage:CC_Default_Avatar];
        self.nameLabel.text = userInfo.nickName;
    } else {
        self.headBtn.image = CC_Default_Avatar;
        self.nameLabel.text = DYLocalizedString(@"Login", @"登陆");
    }
    
}


@end
