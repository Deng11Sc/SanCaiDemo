//
//  DYWinningDetailController.m
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYWinningDetailController.h"

#import "DYAddressController.h"

@interface DYWinningDetailController ()

@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *descLabel;

@property (nonatomic,strong)UIButton *receiveBtn;

@property (nonatomic,strong)UILabel *reciveAddressLabel;

@property (nonatomic,assign)NSInteger refreshStatus;


@end

@implementation DYWinningDetailController

- (void)actionBack {
    if (_refreshStatus > 1 && self.isRefreshBlk) {
        self.isRefreshBlk(YES);
    }
    
    [super actionBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _refreshStatus = 0;
    [self _initSubviews];
}

-(void)_initSubviews {
    _refreshStatus += 1;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:_winModel.goodsImageUrl] placeholderImage:DY_PlaceholderImage];
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
        [self.view addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(20);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(DY_Width/2, DY_Width/2));
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
        [self.view addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(8);
            make.centerX.equalTo(self.imgView);
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
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.view addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(51);
            make.left.equalTo(self.view).offset(12);
            make.right.mas_equalTo(-12);
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
        [self.view addSubview:reciveAddressLabel];
        
        [reciveAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.height.equalTo(@43);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
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
        [receiveBtn setTitle:@"填写领取地址" forState:0];
        [receiveBtn addTarget:self action:@selector(receiveAddressAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:receiveBtn];
        
        [receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(110, 35));
        }];
        
        _receiveBtn = receiveBtn;
    }
    return _receiveBtn;
}



- (void)receiveAddressAction {
    DYAddressController *addressVc = [[DYAddressController alloc] init];
    @weakify(self)
    addressVc.selectAddressBlk = ^(NSString *address) {
        @strongify(self)
        self.winModel.address = address;
        [self _initSubviews];
        
        [DYLeanCloudNet saveObject:self.winModel objectId:self.winModel.objId className:@"dy_winning_list" relationId:nil success:^(NSMutableArray *array) {
            
            NSLog(@"success");
            
        } failure:^(DYLeanCloudError error) {
            
        }];
        
    };
    [self.navigationController pushViewController:addressVc animated:YES];
}



@end
