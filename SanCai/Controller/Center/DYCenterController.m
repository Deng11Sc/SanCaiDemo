//
//  DYCenterController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYCenterController.h"
#import "DYUserInfoHeaderView.h"

#import "DYLoginController.h"

#import "DYAddressController.h"
#import "DYWinningController.h"
#import "DYExpectedController.h"
#import "DYGetRewardsController.h"
#import "DYAboutUsController.h"


@interface DYCenterController ()

@property (nonatomic,strong)DYUserInfoHeaderView *headerView;

@property (nonatomic,strong)UIView *logoutView;


@end

@implementation DYCenterController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadNewUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Center", @"个人中心");
    
    
    [self initTableView];
    self.tableView.height -= 49;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.logoutView;
    
    [self data_from_local];

    
}


-(DYUserInfoHeaderView *)headerView {
    if (!_headerView) {
        DYUserInfoHeaderView *headerView = [[DYUserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, DY_Width, DY_Width*0.618)];
//        @weakify(self)
        headerView.clickHeadBlk = ^{
            
//            @strongify(self)
            if ([DYLoginInfoManager manager].isLogin == NO) {
                DYLoginController *loginVC = [[DYLoginController alloc] init];
                DYNavigationController *loginNav = [[DYNavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccessBlk = ^(BOOL succeeded) {
                    if (succeeded) {
                        [self loadNewUserInfo];
                    }
                };
                [self presentViewController:loginNav animated:YES completion:^{
                    
                }];
            }
        };
        _headerView = headerView;
    }
    return _headerView;
}


- (UIView *)logoutView {
    if (!_logoutView) {
        UIView *logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DY_Width, 110)];
        
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(logoutView.width/2-110/2, logoutView.height/2-44/2, 110, 44);
        [logoutBtn dy_configure];
        logoutBtn.backgroundColor = DY_CustomColor_2594D2;
        [logoutBtn setTitle:DYLocalizedString(@"Sign out", @"退出登录") forState:0];
        [logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [logoutView addSubview:logoutBtn];
        [logoutBtn.layer setCornerRadius:4];
        logoutBtn.clipsToBounds = YES;
        
        _logoutView = logoutView;
    }
    return _logoutView;
}


#pragma mark - 数据
-(void)data_from_local {
    [self.dataArray addObject:DYLocalizedString(@"My Scores", @"我的积分")];
    [self.dataArray addObject:DYLocalizedString(@"My Address", @"我的地址")];

    [self.dataArray addObject:DYLocalizedString(@"My Winning", @"中奖纪录")];
    [self.dataArray addObject:DYLocalizedString(@"Expected items", @"期望物品")];
    [self.dataArray addObject:DYLocalizedString(@"Get rewards", @"兑换奖励")];
    [self.dataArray addObject:DYLocalizedString(@"About App", @"关于我们")];
    
    [self.tableView reloadData];
}

-(void)loadNewUserInfo {
    DYUserInfoModel *userInfo = [DYLoginInfoManager getUserInfo];
    self.headerView.userInfo = userInfo;
    if ([DYLoginInfoManager manager].isLogin == YES) {
        self.logoutView.hidden = NO;
    } else {
        self.logoutView.hidden = YES;
    }
    
    [self.tableView reloadData];
}


-(void)logoutAction:(UIButton *)sender
{
    [[DYLoginInfoManager manager] logout];
    
    [self loadNewUserInfo];
}


#pragma mark - 列表
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *centerCellId =@"centerCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:centerCellId];
    }
    NSString *text = self.dataArray[indexPath.row];
    cell.textLabel.text = text;
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"100s";
    }
    else if ([cell.textLabel.text isEqualToString:DYLocalizedString(@"Expected items", @"期望物品")]) {
        cell.detailTextLabel.text = [DYLoginInfoManager getUserInfo].goodsTitle;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    if ([text isEqualToString:DYLocalizedString(@"My Address", @"我的地址")]) {
        DYAddressController *ctrl = [[DYAddressController alloc] init];
        ctrl.title = DYLocalizedString(@"My Address", @"我的地址");
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([text isEqualToString:DYLocalizedString(@"My Winning", @"中奖纪录")]) {
        DYWinningController *ctrl = [[DYWinningController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([text isEqualToString:DYLocalizedString(@"Expected items", @"期望物品")]) {
        DYExpectedController *ctrl = [[DYExpectedController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([text isEqualToString:DYLocalizedString(@"Get rewards", @"兑换奖励")]) {
        DYGetRewardsController *ctrl = [[DYGetRewardsController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([text isEqualToString:DYLocalizedString(@"About App", @"关于我们")]) {
        DYAboutUsController *ctrl = [[DYAboutUsController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }

    
}


@end
