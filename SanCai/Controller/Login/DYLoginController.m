//
//  DYLoginController.m
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYLoginController.h"
#import <AVOSCloud/AVOSCloud.h>

#import "DYRegistController.h"

#import "DYInputLoginView.h"

/*
 用户名错误 202
 手机号码错误 214
 邮箱错误 203
 */

@interface DYLoginController ()

@property (nonatomic,strong)DYInputLoginView *loginView;

@property (nonatomic,strong)UIImageView *baseView;

@property (nonatomic,strong)UIButton *trueBtn;
///注册时的返回按钮
@property (nonatomic,strong)UIButton *backBtn;


@property (nonatomic,strong)NSString *user;
@property (nonatomic,strong)NSString *password;

@end

@implementation DYLoginController

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.modalPresentationStyle = UIModalPresentationCustom;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor clearColor];
    self.title = DYLocalizedString(@"Login", @"登陆");
    
    [self _initSubviews];
    
}

-(void)_initSubviews {
    
    UIImageView *baseView = [[UIImageView alloc] init];
    baseView.userInteractionEnabled = YES;
    baseView.contentMode = UIViewContentModeScaleAspectFill;
    baseView.backgroundColor = [UIColor blueColor];
    baseView.clipsToBounds = YES;
    [self.view addSubview:baseView];
    _baseView = baseView;
    
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    DYInputLoginView *loginView = [[DYInputLoginView alloc] init];
    [self.view addSubview:loginView];
    _loginView = loginView;
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(12);
        make.height.mas_equalTo([DYInputLoginView height]);
    }];
    
    
    loginView.tf1.placeholder = DYLocalizedString(@"Please enter account number", @"请输入账号");
    loginView.tf2.placeholder = DYLocalizedString(@"Please enter the password", @"请输入密码");
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trueBtn dy_configure];
    trueBtn.backgroundColor = [UIColor whiteColor];
    [trueBtn.layer setCornerRadius:4];
    trueBtn.clipsToBounds = YES;
    [trueBtn setTitle:DYLocalizedString(@"Login", @"登陆") forState:0];
    [trueBtn setTitleColor:[UIColor blueColor] forState:0];
    [trueBtn addTarget:self action:@selector(trueAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:trueBtn];
    _trueBtn = trueBtn;
    
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginView).offset(-60-10);
        make.top.equalTo(loginView.mas_bottom).offset(16);
        make.width.equalTo(@110);
        make.height.equalTo(@35);
    }] ;

    
    ///注册
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn dy_configure];
    registBtn.backgroundColor = [UIColor whiteColor];
    [registBtn.layer setCornerRadius:4];
    registBtn.clipsToBounds = YES;
    [registBtn setTitle:DYLocalizedString(@"Regist", @"注册") forState:0];
    [registBtn setTitleColor:[UIColor blueColor] forState:0];
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginView).offset(70);
        make.top.equalTo(loginView.mas_bottom).offset(16);
        make.width.equalTo(@110);
        make.height.equalTo(@35);
    }];
    
    
    ///退出按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn dy_configure];
    [cancelBtn setImage:[UIImage imageNamed:@"icon_home_letter_lottery_cancel"] forState:UIControlStateNormal];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(baseView.mas_left).offset(10);
        make.top.equalTo(baseView.mas_top).offset(20);
    }];

}

- (void)registAction {
    DYRegistController *registVc = [[DYRegistController alloc] init];
    [self.navigationController pushViewController:registVc animated:YES];
}

///退出
- (void)cancelAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)trueAction {
    self.user = self.loginView.tf1.text;
    self.password = self.loginView.tf2.text;
    [self.loginView endEdit];
    if (([NSString isEmptyString:self.loginView.tf1.text]) || ([NSString isEmptyString:self.loginView.tf2.text])) {
        [NSObject showMessage:DYLocalizedString(@"Please enter the complete information", @"请输入完整的信息")];
        return;
    }
    
    if ([DYLoginInfoManager manager].isLogin == YES) {
        [AVUser logOut];
    }
    
    ///登陆
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AVUser logInWithUsernameInBackground:self.loginView.tf1.text password:self.loginView.tf2.text block:^(AVUser *user, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (user != nil) {
            NSLog(@"注册用户");
            
            DYUserInfoModel *model = [[DYUserInfoModel alloc] init];
            model.nickName = user.username;
            model.objectId = user.objectId;
            model.sessionToken = user.sessionToken;
            model.imageUrl = [user objectForKey:@"localData"][@"imageUrl"];
            model.goodsId = [user objectForKey:@"localData"][@"goodsId"];
            model.goodsTitle = [user objectForKey:@"localData"][@"goodsTitle"];
            [DYLoginInfoManager saveUserInfo:model];
            
            if (self.loginSuccessBlk) {
                self.loginSuccessBlk(YES);
            }
            
            [self cancelAction];
            
        } else {
            
            NSLog(@"未注册用户");
            switch ([error.userInfo[@"code"] integerValue]) {
                case 211: ///该账号未注册
                {
                    [NSObject showMessage:DYLocalizedString(@"Account does not exist", @"账号不存在")];
                }
                    break;
                case 210:
                {
                    ///密码错误
                    [NSObject showMessage:DYLocalizedString(@"Wrong password", @"密码错误")];
                }
                    break;
                default:
                {
                    [NSObject showMessage:DYLocalizedString(@"Login failed", @"登陆失败")];
                }
                    break;
            }
        }
    }];
    
}


- (void)dealloc {
    NSLog(@"%@ -dealloc",[self class]);
}



@end
