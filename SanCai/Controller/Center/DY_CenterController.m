//
//  DY_CenterController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_CenterController.h"
#import "DY_UserInfoHeaderView.h"
#import "DY_MineListCell.h"

#import "DY_LoginController.h"

#import "DY_AddressController.h"
#import "DY_WinningController.h"
#import "DY_ExpectedController.h"
#import "DY_GetRewardsController.h"
#import "DY_AboutUsController.h"
#import "DY_TaskController.h"


#import "DY_CenterListView.h"

///积分model
#import "DY_ScoresModel.h"
#import "NSString+ScoresManager.h"
#import "DY_TaskManager.h"

@interface DY_CenterController ()<DY_CenterListViewDelegate>

@property (nonatomic,strong)DY_UserInfoHeaderView *headerView;

@property (nonatomic,strong)UIView *logoutView;

@property (nonatomic,strong)DY_CenterListView *centerListView;

//积分model
@property (nonatomic,strong)DY_ScoresModel *scoresModel;

@end

@implementation DY_CenterController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self dy_loadNewUserInfo];
    [self loadScores_server];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Center", @"个人中心");
    
    self.tableViewIsGrouped = YES;
    [self dy_initTableView];
    self.tableView.height -= 49;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.logoutView;
    
    [self dy_data_from_local];

    
}


-(DY_UserInfoHeaderView *)headerView {
    if (!_headerView) {
        DY_UserInfoHeaderView *headerView = [[DY_UserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, CC_Width, CC_Width*0.618)];
        @weakify(self)
        headerView.markBlk = ^{
            [[DY_TaskManager manager] increaseScoresByTaskType:@"1" success:^{
                [self dy_loadSigninStauts];
            }];
        };
        
        headerView.clickHeadBlk = ^{
            
            @strongify(self)
            if ([DY_LoginInfoManager manager].isLogin == NO) {
                DY_LoginController *loginVC = [[DY_LoginController alloc] init];
                DY_NavigationController *loginNav = [[DY_NavigationController alloc] initWithRootViewController:loginVC];
                
                loginVC.loginSuccessBlk = ^(BOOL succeeded) {
                    if (succeeded) {
                        [self dy_loadNewUserInfo];
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
        UIView *logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CC_Width, 110)];
        
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(logoutView.width/2-110/2, logoutView.height/2-44/2, 110, 44);
        [logoutBtn dy_configure];
        logoutBtn.tag = 1;
        logoutBtn.backgroundColor = CC_CustomColor_2594D2;
        [logoutBtn setTitle:DYLocalizedString(@"Sign out", @"退出登录") forState:0];
        [logoutBtn addTarget:self action:@selector(dy_logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [logoutView addSubview:logoutBtn];
        [logoutBtn.layer setCornerRadius:4];
        logoutBtn.clipsToBounds = YES;
        
        _logoutView = logoutView;
    }
    
    return _logoutView;
}


#pragma mark - 数据
-(void)dy_data_from_local {
    
    
    [self.dataArray addObject:@{@"imageName":@"mine_scores_icon",@"title":DYLocalizedString(@"My Scores", @"我的积分")}];
    [self.dataArray addObject:@{@"imageName":@"mine_address_icon",@"title":DYLocalizedString(@"My Address", @"我的地址")}];

    [self.dataArray addObject:@{@"imageName":@"mine_winning_icon",@"title":DYLocalizedString(@"My Winning", @"中奖纪录")}];
    [self.dataArray addObject:@{@"imageName":@"mine_expected_icon",@"title":DYLocalizedString(@"Expected items", @"期望物品")}];
//    [self.dataArray addObject:@{@"imageName":@"mine_aboutApp_icon",@"title":DYLocalizedString(@"About App", @"关于我们")}];
    
    [self.tableView reloadData];
}

- (void)loadScores_server {
    
    [NSString server_getScoresModelWithUserId:SELF_USER_ID blk:^(DY_ScoresModel *scoresModel) {
        
        if (scoresModel == nil) {
            return ;
        }
        
        self.scoresModel = scoresModel;
        
        UITableViewCell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell0.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.scoresModel.scores];
        
    }];
}

-(void)dy_loadNewUserInfo {
    DY_UserInfoModel *userInfo = [DY_LoginInfoManager getUserInfo];
    self.headerView.userInfo = userInfo;
    if ([DY_LoginInfoManager manager].isLogin == YES) {
        self.logoutView.hidden = NO;
        self.headerView.markBtn.hidden = NO;
    } else {
        self.logoutView.hidden = YES;
        self.headerView.markBtn.hidden = YES;
    }
    
    [self.tableView reloadData];
    
    [self dy_loadSigninStauts];
}

-(void)dy_loadSigninStauts {
    NSMutableArray<DY_TasksModel *> *tasksArr =[DY_TaskManager manager].tasksArr;
    for (DY_TasksModel *model in tasksArr) {
        if ([model.taskType integerValue] == 1) {
            
            if ([model.userTasksModel.finishTimes integerValue] >= [model.finishMaxNumber integerValue]) {
                self.headerView.markBtn.hidden = YES;
            } else {
                self.headerView.markBtn.hidden = NO;
            }
            
            break;
        }
    }
    [self.tableView reloadData];
}


-(void)dy_logoutAction:(UIButton *)sender
{
    [[DY_LoginInfoManager manager] logout];
    
    [self dy_loadNewUserInfo];
}


#pragma mark - 列表
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *centerCellId =@"centerCellId";
    DY_MineListCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellId];
    if (!cell) {
        cell = [[DY_MineListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:centerCellId];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    NSString *text = self.dataArray[indexPath.row][@"title"];
    cell.textLabel.text = text;
    
    if (indexPath.row == 0) {
        cell.rightArrowImgView.hidden = YES;
    } else {
        cell.rightArrowImgView.hidden = NO;
    }
    
    NSString *imageName = self.dataArray[indexPath.row][@"imageName"];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [NSString local_getScores];
    }
    else if ([cell.textLabel.text isEqualToString:DYLocalizedString(@"Expected items", @"期望物品")]) {
        cell.detailTextLabel.text = [DY_LoginInfoManager getUserInfo].goodsTitle;
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Height_centerList;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.centerListView;
}

-(DY_CenterListView *)centerListView
{
    if (!_centerListView) {
        DY_CenterListView *listView = [[DY_CenterListView alloc] init];
        listView.frame = CGRectMake(0, 0, CC_Width, Height_centerList);
        listView.delagate = self;
//        [self.view addSubview:listView];

        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:@[@{@"icon":@"icon_center_task",@"title":DYLocalizedString(@"Task", @"")},
                                                                      @{@"icon":@"icon_center_shop",@"title":DYLocalizedString(@"Mall", @"")}]];
        [listView initSubviewsWithDataArray:arr];
        _centerListView = listView;
    }
    return _centerListView;
}


#pragma mark ----- listView代理方法
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            DY_TaskController *taskVC = [[DY_TaskController alloc] init];
            [self.navigationController pushViewController:taskVC animated:YES];
        }
            break;
        case 1:
        {
            DY_GetRewardsController *ctrl = [[DY_GetRewardsController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
            
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    if ([text isEqualToString:DYLocalizedString(@"My Address", @"我的地址")]) {
        DY_AddressController *ctrl = [[DY_AddressController alloc] init];
        ctrl.title = DYLocalizedString(@"My Address", @"我的地址");
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([text isEqualToString:DYLocalizedString(@"My Winning", @"中奖纪录")]) {
        DY_WinningController *ctrl = [[DY_WinningController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([text isEqualToString:DYLocalizedString(@"Expected items", @"期望物品")]) {
        DY_ExpectedController *ctrl = [[DY_ExpectedController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([text isEqualToString:DYLocalizedString(@"About App", @"关于我们")]) {
        DY_AboutUsController *ctrl = [[DY_AboutUsController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }

}

- (void)setIsLandscape:(BOOL)isLandscape {
    [super setIsLandscape:isLandscape];
    
    _logoutView.frame = CGRectMake(0, 0, CC_Width, 110);
    [_logoutView viewWithTag:1].frame = CGRectMake(_logoutView.width/2-110/2, _logoutView.height/2-44/2, 110, 44);

}

@end
