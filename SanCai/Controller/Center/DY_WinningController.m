//
//  DY_WinningController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_WinningController.h"

#import "DY_WinningModel.h"
#import "DY_WinningCell.h"

#import "DY_WinningDetailController.h"

@interface DY_WinningController ()

@property (nonatomic,assign)NSInteger page;

@end

@implementation DY_WinningController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"My Winning", @"中奖纪录");
    
    [self dy_initTableView];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 88, 0, 12);

    @weakify(self)
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        _page = 1;
        [self dy_data_from_server_page_page:_page];
    }];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self dy_data_from_server_page_page:_page];
    }];
    self.tableView.mj_footer = footer;
    
}



#pragma mark - 列表
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *centerCellId =@"centerCellId";
    DY_WinningCell *cell = [tableView dequeueReusableCellWithIdentifier:centerCellId];
    if (!cell) {
        cell = [[DY_WinningCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:centerCellId];
    }
    DY_WinningModel *winModel = self.dataArray[indexPath.row];
    cell.winModel = winModel;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DY_WinningModel *winModel = self.dataArray[indexPath.row];
    DY_WinningDetailController *detailVc = [[DY_WinningDetailController alloc] init];
    detailVc.title = winModel.goodsName;
    detailVc.winModel = winModel;
    detailVc.isRefreshBlk = ^(BOOL refresh) {
        if (refresh) {
            [self dy_data_from_server_page_page:1];
        }
    };
    
    [self.navigationController pushViewController:detailVc animated:YES];
}


-(void)dy_data_from_server_page_page:(NSInteger)page
{
    AVQuery *query = [AVQuery queryWithClassName:URL_WinningModel];
    [query whereKey:@"userId" equalTo:SELF_USER_ID];
    [DY_LeanCloudNet findObjectWithQuery:query skip:page limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        NSLog(@"dic - %@",array);
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            DY_WinningModel *model = [[DY_WinningModel alloc] initWithDictionary:dic];
            [dataArray addObject:model];
        }
        if (page == 1) {
            self.dataArray = dataArray;
        } else {
            [self.dataArray addObjectsFromArray:dataArray];
        }
        [self.tableView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
}

@end
