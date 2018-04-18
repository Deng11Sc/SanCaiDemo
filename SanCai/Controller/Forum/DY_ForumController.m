//
//  DY_ForumController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_ForumController.h"

#import "DY_MovieDescModel.h"
#import "DY_MovieListCell.h"

#import "DY_ArticleDetailController.h"

@interface DY_ForumController ()

@property (nonatomic,assign)NSInteger page;

@end

@implementation DY_ForumController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = DYLocalizedString(@"Movie", @"电影");
    
    [self dy_initTableView];
    self.tableView.height -=49;
    @weakify(self)
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        _page = 1;
        [self dy_data_from_server_page:_page];
    }];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self dy_data_from_server_page:_page];
    }];
    self.tableView.mj_footer = footer;

}


#pragma mark --- tableView代理方法 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier =@"DY_MovieDescCellId";
    DY_MovieListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DY_MovieListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    DY_MovieDescModel *model = self.dataArray[indexPath.row];
    cell.descModel = model;
    
    return cell;
    
    return nil;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DY_MovieListCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DY_MovieDescModel *model = self.dataArray[indexPath.row];

    DY_ArticleDetailController *detailVC = [[DY_ArticleDetailController alloc] init];
    detailVC.movieModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}



-(void)dy_data_from_server_page:(NSInteger)page {
    
    AVQuery *query = [AVQuery queryWithClassName:URL_MovieDescModel];
    [DY_LeanCloudNet findObjectWithQuery:query skip:page limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (array.count) {
            NSMutableArray *titles = [NSMutableArray new];
            NSMutableArray *imagesURLStrings = [NSMutableArray new];
            
            NSMutableArray *headerArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in array) {
                DY_MovieDescModel *model = [[DY_MovieDescModel alloc] initWithDictionary:dic];
                [headerArr addObject:model];
                
                [titles addObject:model.movieName];
                [imagesURLStrings addObject:model.movieImg];
            }
            self.dataArray = headerArr;
            [self.tableView reloadData];
            
        } else {

        }
        
        
    } failure:^(DYLeanCloudError error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
}



@end
