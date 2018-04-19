//
//  DY_AddressCell.m
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_AddressCell.h"

@interface DY_AddressCell ()

@property (nonatomic,strong)UIView *baseView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *phoneLabel;

@property (nonatomic,strong)UILabel *addressLabel;


@end


@implementation DY_AddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *baseView = [[UIView alloc] init];
        baseView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:baseView];
        _baseView = baseView;
        
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.bottom.mas_equalTo(-8);
        }];
        
        [self dy_initSubviews];
    }
    return self;
}


-(void)dy_initSubviews {
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = CC_CustomColor_F5F4F3;
    [self.baseView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
        make.bottom.mas_equalTo(-30);
    }];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"icon_address_delete"] forState:0];
    [deleteBtn setTitle:DYLocalizedString(@" Delete", @"删除") forState:0];
    [deleteBtn setTitleColor:mainColor forState:0];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];

    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"icon_address_edit"] forState:0];
    [editBtn setTitle:DYLocalizedString(@" Edit", @"编辑") forState:0];
    [editBtn setTitleColor:mainColor forState:0];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [editBtn addTarget:self action:@selector(editAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];
    
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(deleteBtn.mas_left).offset(-4);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
}



- (void)deleteAction {
    if (self.deleteBlk) {
        self.deleteBlk(self.addrModel);
    }
}


- (void)editAddressAction {
    if (self.editBlk) {
        self.editBlk(self.addrModel);
    }
}


-(UILabel *)nameLabel
{
    
    if (!_nameLabel) {
        UILabel *nameLabel = [[UILabel alloc] init];
        [nameLabel dy_configure];
        [self.baseView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12);
            make.left.equalTo(@12);
            make.height.equalTo(@20);
        }];
        
        _nameLabel = nameLabel;
    }
    return _nameLabel;
}


-(UILabel *)phoneLabel
{
    
    if (!_phoneLabel) {
        UILabel *phoneLabel = [[UILabel alloc] init];
        [phoneLabel dy_configure];
        [self.baseView addSubview:phoneLabel];
        
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@12);
            make.right.equalTo(@(-12));
            make.height.equalTo(@20);

        }];
        
        _phoneLabel = phoneLabel;
    }
    return _phoneLabel;
}


-(UILabel *)addressLabel
{
    
    if (!_addressLabel) {
        UILabel *addressLabel = [[UILabel alloc] init];
        [addressLabel dy_configure];
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addressLabel.numberOfLines = 2;
        [self.baseView addSubview:addressLabel];
        
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).offset(8);
            make.left.equalTo(_nameLabel);
            make.right.mas_equalTo(-12);
            make.height.mas_greaterThanOrEqualTo(30);
        }];
        
        _addressLabel = addressLabel;
    }
    return _addressLabel;
}




- (void)setAddrModel:(DY_AddressModel *)addrModel {
    _addrModel = addrModel;
    
    self.nameLabel.text = addrModel.receiveName;
    self.phoneLabel.text = addrModel.receivePhone;
    self.addressLabel.text = addrModel.address;
    
}
@end
