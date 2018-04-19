//
//  DY_AddressEditController.m
//  SanCai
//
//  Created by SongChang on 2018/4/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_AddressEditController.h"


@interface DY_AddressEditController ()\

@property (nonatomic,strong)UITextField *nameTextField;

@property (nonatomic,strong)UITextField *phoneTextField;

@property (nonatomic,strong)UITextField *addrTextField;

@end

@implementation DY_AddressEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.type) {
        case DYEditAddressTypeAdd:
            self.title = DYLocalizedString(@"Add address", @"添加地址");
            break;
        case DYEditAddressTypeChanged:
            self.title = DYLocalizedString(@"Change address", @"修改地址");
            break;

        default:
            break;
    }
    
    [self dy_initSubviews];
}

-(void)dy_initSubviews
{
    [self dy_setNameField];
    [self dy_setPhoneField];
    [self dy_setAddrField];
    
    self.nameTextField.text = self.addrModel.receiveName;
    self.phoneTextField.text = self.addrModel.receivePhone;
    self.addrTextField.text = self.addrModel.address;
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn dy_configure];
    [submitBtn setTitle:DYLocalizedString(@"Submit", @"提交") forState:0];
    [submitBtn addTarget:self action:@selector(dy_submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addrTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(110, 35));
    }];
}


-(void)dy_setNameField {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField dy_configure];
    [self.view addSubview:textField];
    
    UILabel *label = [[UILabel alloc] init];
    [label dy_configure];
    label.frame = CGRectMake(0, 0, 70, 44);
    label.text = [NSString stringWithFormat:@"  %@:",DYLocalizedString(@"Name", @"姓名")];
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

-(void)dy_setPhoneField {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField dy_configure];
    [self.view addSubview:textField];
    
    UILabel *label = [[UILabel alloc] init];
    [label dy_configure];
    label.frame = CGRectMake(0, 0, 70, 44);
    label.text = [NSString stringWithFormat:@"  %@:",DYLocalizedString(@"Phone", @"姓名")];
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

-(void)dy_setAddrField {
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    [textField dy_configure];
    [self.view addSubview:textField];
    
    UILabel *label = [[UILabel alloc] init];
    [label dy_configure];
    label.frame = CGRectMake(0, 0, 70, 44);
    label.text = [NSString stringWithFormat:@"  %@:",DYLocalizedString(@"Address", @"地址")];
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

-(void)endEdit {
    [self.nameTextField endEditing:YES];
    [self.phoneTextField endEditing:YES];
    [self.addrTextField endEditing:YES];
}


- (void)dy_submitAction:(UIButton *)sender
{
    [self endEdit];
    
    if (self.nameTextField.text.length == 0 || self.phoneTextField.text.length == 0 ||self.addrTextField.text.length == 0) {
        
        [NSObject showError:DYLocalizedString(@"Please fill in the complete", nil)];
        
        return;
    }
    
    DY_AddressModel *addrModel = [[DY_AddressModel alloc] init];
    addrModel.address = self.addrTextField.text;
    addrModel.receiveName = self.nameTextField.text;
    addrModel.receivePhone = self.phoneTextField.text;
    addrModel.userId = SELF_USER_ID;//初始化有过一次
    addrModel.objId = self.addrModel.objId;
    self.addrModel = addrModel;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [DY_LeanCloudNet saveObject:self.addrModel objectId:self.addrModel.objId className:URL_AddressModel  numberArr:nil relationId:nil success:^(NSMutableArray *array,AVObject *object) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.refreshBlk) {
            self.refreshBlk();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(DYLeanCloudError error) {
        
    }];

}


- (void)dealloc {
    NSLog(@"___ %@ ___ dealloc",NSStringFromClass([self class]));
}





@end
