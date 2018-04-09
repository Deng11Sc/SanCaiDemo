//
//  DYOcrMainController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYOcrMainController.h"

#import "UIViewController+AVOSCloud.h"

#import "DYFilmReviewCell.h"

@interface DYOcrMainController ()

@end

@implementation DYOcrMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Hot", @"");
    [DYLeanCloudNet _initOSCloudServers];
    
    //获取APP当前语言
    NSArray *languageArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *curLanguage = languageArr.firstObject;
    if ([curLanguage isEqualToString:@"zh-Hans-CN"]) {

        [self getAVOSCloudTypeController];

    } else {

    }
    
    
    [self initTableView];
    @weakify(self)
    MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self data_from_server];
    }];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier =@"DYFilmReviewCellId";
    DYFilmReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DYFilmReviewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    DYFilmReviewModel *model = self.dataArray[indexPath.row];
    cell.filmModel = model;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DYFilmReviewCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)data_from_server
{
    [DYLeanCloudNet getList:URL_HotListModel orderby:nil limit:-1 success:^(NSMutableArray *array) {
        
        [self.tableView.mj_header endRefreshing];
        NSLog(@"dic - %@",array);
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DYFilmReviewModel *model = [[DYFilmReviewModel alloc] initWithDictionary:dic];
            [dataArray addObject:model];
        }
        self.dataArray = dataArray;
        [self.tableView reloadData];
        
        
    } failure:^(DYLeanCloudError error) {
        [self.tableView.mj_header endRefreshing];
    }];
}


@end

