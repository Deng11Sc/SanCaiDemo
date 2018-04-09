//
//  DYWinningController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYWinningController.h"

#import "DYWinningModel.h"
#import "DYWinningCell.h"

#import "DYWinningDetailController.h"

@interface DYWinningController ()

@end

@implementation DYWinningController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"My Winning", @"中奖纪录");
    
    [self initTableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 88, 0, 12);

    
    [self data_from_server];
}



#pragma mark - 列表
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *centerCellId =@"centerCellId";
    DYWinningCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellId];
    if (!cell) {
        cell = [[DYWinningCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:centerCellId];
    }
    DYWinningModel *winModel = self.dataArray[indexPath.row];
    cell.winModel = winModel;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DYWinningModel *winModel = self.dataArray[indexPath.row];
    DYWinningDetailController *detailVc = [[DYWinningDetailController alloc] init];
    detailVc.title = winModel.goodsName;
    detailVc.winModel = winModel;
    detailVc.isRefreshBlk = ^(BOOL refresh) {
        if (refresh) {
            [self data_from_server];
        }
    };
    
    [self.navigationController pushViewController:detailVc animated:YES];
}


-(void)data_from_server
{
    AVQuery *query = [AVQuery queryWithClassName:@"dy_winning_list"];
    [query whereKey:@"userId" equalTo:SELF_USER_ID];
    [DYLeanCloudNet findObjectWithQuery:query success:^(NSMutableArray *array) {
        
        NSLog(@"dic - %@",array);
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            DYWinningModel *model = [[DYWinningModel alloc] initWithDictionary:dic];
            [dataArray addObject:model];
        }
        self.dataArray = dataArray;
        [self.tableView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        
    }];
    
}

@end
