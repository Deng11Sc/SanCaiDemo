//
//  DYAddressEditController.m
//  SanCai
//
//  Created by SongChang on 2018/4/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYAddressEditController.h"


@interface DYAddressEditController ()\

@property (nonatomic,strong)UITextField *nameTextField;

@property (nonatomic,strong)UITextField *phoneTextField;

@property (nonatomic,strong)UITextField *addrTextField;

@end

@implementation DYAddressEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _initSubviews];
}

-(void)_initSubviews
{
    [self setNameField];
    [self setPhoneField];
    [self setAddrField];
}


-(void)setNameField {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField dy_configure];
    [self.view addSubview:textField];
    
    UILabel *label = [[UILabel alloc] init];
    [label dy_configure];
    label.frame = CGRectMake(0, 0, 70, 44);
    label.text = [NSString stringWithFormat:@"  %@",DYLocalizedString(@"Name", @"姓名")];
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(44);
    }];
    _nameTextField = textField;
}

-(void)setPhoneField {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField dy_configure];
    [self.view addSubview:textField];
    
    UILabel *label = [[UILabel alloc] init];
    [label dy_configure];
    label.frame = CGRectMake(0, 0, 70, 44);
    label.text = [NSString stringWithFormat:@"  %@",DYLocalizedString(@"Phone", @"姓名")];
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameTextField.mas_bottom).offset(0.5);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(44);
    }];
    _phoneTextField = textField;
}

-(void)setAddrField {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField dy_configure];
    [self.view addSubview:textField];
    
    UILabel *label = [[UILabel alloc] init];
    [label dy_configure];
    label.frame = CGRectMake(0, 0, 70, 44);
    label.text = [NSString stringWithFormat:@"  %@",@"地址"];
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTextField.mas_bottom).offset(0.5);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(44);
    }];
    _addrTextField = textField;
}

@end
