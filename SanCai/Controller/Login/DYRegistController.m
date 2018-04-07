//
//  DYRegistController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYRegistController.h"

#import "DYInputLoginView.h"

@interface DYRegistController ()

@property (nonatomic,strong)DYInputLoginView *loginView;

@property (nonatomic,strong)UIImageView *baseView;

///注册时的返回按钮
@property (nonatomic,strong)UIButton *backBtn;


@end

@implementation DYRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Regist", @"注册");

    [self _initSubviews];
}

-(void)_initSubviews {
    
    DYInputLoginView *loginView = [[DYInputLoginView alloc] init];
    [self.view addSubview:loginView];
    _loginView = loginView;
    
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(12);
        make.height.mas_equalTo([DYInputLoginView height]);
    }];
    
    UIButton *trueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trueBtn dy_configure];
    trueBtn.backgroundColor = [UIColor whiteColor];
    [trueBtn.layer setCornerRadius:4];
    trueBtn.clipsToBounds = YES;
    [trueBtn setTitle:DYLocalizedString(@"Regist", @"注册") forState:0];
    [trueBtn setTitleColor:[UIColor blueColor] forState:0];
    [trueBtn addTarget:self action:@selector(registServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trueBtn];
    
    [trueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(loginView);
        make.top.equalTo(loginView.mas_bottom).offset(12);
        make.height.equalTo(@35);
    }];
    
    ///退出按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"nav_normal_back"] forState:UIControlStateNormal];
    cancelBtn.contentMode = UIViewContentModeScaleAspectFit;
    [cancelBtn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(20);
    }];

}

- (void)registServer {
    [self.loginView endEdit];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    ///注册
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = self.loginView.tf1.text;// 设置用户名
    user.password =  self.loginView.tf2.text;// 设置密码
    [user setObject:[NSString randomHeaderImageUrl] forKey:@"imageUrl"];
    user.email = nil;// 设置邮箱
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeeded) {
            // 注册成功
            [NSObject showMessage:DYLocalizedString(@"Succeeded", @"注册成功")];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self actionBack];
            });
            
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
            [NSObject showMessage:DYLocalizedString(@"Register failure", @"注册失败")];
        }
    }];

}

@end
