//
//  DY_WinningDetailController.m
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_WinningDetailController.h"

#import "DY_AddressController.h"

#import "NSString+ScoresManager.h"

@interface DY_WinningDetailController ()

///基础视图
@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *descLabel;

@property (nonatomic,strong)UIButton *receiveBtn;

@property (nonatomic,strong)UILabel *reciveAddressLabel;

@property (nonatomic,assign)NSInteger refreshStatus;


@end

@implementation DY_WinningDetailController

- (void)dy_actionBack {
    if (_refreshStatus > 1 && self.isRefreshBlk) {
        self.isRefreshBlk(YES);
    }
    
    [super dy_actionBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _refreshStatus = 0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(CC_Width, CC_SCREEN_MAX);
    _scrollView = scrollView;
    
    [self dy_initSubviews];
}

-(void)dy_initSubviews {
    _refreshStatus += 1;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_winModel.goodsImageUrl] placeholderImage:CC_PlaceholderImage];
    self.titleLabel.text = _winModel.goodsName;
    self.descLabel.text = _winModel.goodsDes;
    
    if ([NSString isEmptyString:self.winModel.address]) {
        self.receiveBtn.hidden = NO;
        self.reciveAddressLabel.hidden = YES;
        self.reciveAddressLabel.text = nil;
    } else {
        self.receiveBtn.hidden = YES;
        self.reciveAddressLabel.hidden = NO;
        self.reciveAddressLabel.text = [NSString stringWithFormat:@"%@ : %@",DYLocalizedString(@"Receive Address", @"领取地址"),self.winModel.address];

    }
    [self _setLayoutSubviews];
}


-(void)_setLayoutSubviews {
    
}


-(UIImageView *)imgView
{
    if (!_imgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_scrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_scrollView).offset(20);
            make.centerX.equalTo(_scrollView);
            make.size.mas_equalTo(CGSizeMake(CC_SCREEN_MIN/2, CC_SCREEN_MIN/2));
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
        titleLabel.font = [UIFont systemFontOfSize:17];
        [_scrollView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(8);
            make.centerX.equalTo(self.imgView);
            make.height.mas_equalTo(20);
            make.width.mas_lessThanOrEqualTo(CC_Width-16);
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
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_scrollView addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(51);
            make.left.equalTo(_scrollView).offset(12);
            make.right.mas_equalTo(-12);
            make.width.mas_lessThanOrEqualTo(CC_Width-24);
            make.height.mas_lessThanOrEqualTo(@200);
        }];
        
        _descLabel = descLabel;
    }
    return _descLabel;
}

-(UILabel *)reciveAddressLabel
{
    
    if (!_reciveAddressLabel) {
        UILabel *reciveAddressLabel = [[UILabel alloc] init];
        [reciveAddressLabel dy_configure];
        reciveAddressLabel.numberOfLines = 2;
        reciveAddressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_scrollView addSubview:reciveAddressLabel];
        
        [reciveAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.height.equalTo(@43);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        _reciveAddressLabel = reciveAddressLabel;
    }
    return _reciveAddressLabel;
}


- (UIButton *)receiveBtn
{
    if (!_receiveBtn) {
        UIButton *receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [receiveBtn dy_configure];
        [receiveBtn setTitle:DYLocalizedString(@"Fill in the address", nil) forState:0];
        [receiveBtn addTarget:self action:@selector(dy_receiveAddressAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:receiveBtn];
        
        [receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(35);
            make.width.mas_greaterThanOrEqualTo(110);
        }];
        
        _receiveBtn = receiveBtn;
    }
    return _receiveBtn;
}


- (void)dy_receiveAddressAction {
    

    ///获取自己的积分
    __block DY_WinningModel *weakWinModel = self.winModel;
    [NSString server_getScoresModelWithUserId:SELF_USER_ID blk:^(DY_ScoresModel *scoresModel) {
        if ([scoresModel.scores integerValue] >= [self.winModel.priceScores integerValue]) {
            
            ///
            DY_AddressController *addrVC = [[DY_AddressController alloc] init];
            @weakify(self)
            addrVC.selectAddressBlk = ^(NSString *address) {
                @strongify(self)
                
                ///减少积分
                [NSString server_saveScoresWithUserId:SELF_USER_ID objId:scoresModel.objId changedNumber:-[self.winModel.priceScores integerValue] endblk:nil];
                
                weakWinModel.address = address;
                [self dy_selectedAddressAndSave:weakWinModel objectId:self.winModel.objId];
                
            };
            [self.navigationController pushViewController:addrVC animated:YES];

            
        } else {
            [NSObject showMessage:DYLocalizedString(@"Your scores are not enough", @"您的积分不足")];
        }
    }];

}

///选择了地址并保存
-(void)dy_selectedAddressAndSave:(DY_WinningModel *)winModel objectId:(NSString *)objectId {
    
    [DY_LeanCloudNet saveObject:winModel objectId:objectId className:URL_WinningModel numberArr:nil relationId:nil success:^(NSMutableArray *array,AVObject *object) {
        
//        [self dy_actionBack];
        
    } failure:^(DYLeanCloudError error) {
        
    }];
    
}



- (void)setIsLandscape:(BOOL)isLandscape {
    [super setIsLandscape:isLandscape];
    
    
    [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView).offset(20);
        make.centerX.equalTo(_scrollView);
        make.size.mas_equalTo(CGSizeMake(CC_SCREEN_MIN/2, CC_SCREEN_MIN/2));
    }];
    
    [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(8);
        make.centerX.equalTo(self.imgView);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(CC_Width-16);
    }];
    
    [_reciveAddressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.height.equalTo(@43);
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(CC_Width-24);
    }];

    [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(51);
        make.left.equalTo(_scrollView).offset(12);
        make.width.mas_equalTo(CC_Width-24);
        make.height.mas_lessThanOrEqualTo(@200);
    }];

    
    _scrollView.frame = self.view.bounds;
    if (isLandscape) {
        _scrollView.contentSize = CGSizeMake(CC_Width, CC_SCREEN_MAX);
    } else {
        _scrollView.contentSize = CGSizeMake(CC_Width, CC_Height);
    }

}

@end
