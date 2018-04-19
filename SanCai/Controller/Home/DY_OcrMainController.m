//
//  DY_OcrMainController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_OcrMainController.h"

#import "UIViewController+AVOSCloud.h"

#import "DY_FilmReviewCell.h"

#import "DY_ArticleDetailController.h"

#import "SDCycleScrollView.h"


///轮播图
#import "DY_MovieDescModel.h"

#import "DY_GuidePageController.h"


@interface DY_OcrMainController ()<SDCycleScrollViewDelegate>

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSMutableArray *headerArr; ///首页顶部轮播图数据

@end

@implementation DY_OcrMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Hot", @"");
    
    [self dy_initTableView];
    self.tableView.height -=49;
    @weakify(self)
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        _page = 1;
        [self dy_data_header_server];
        [self dy_data_from_server_page:_page];
    }];
    self.tableView.mj_header = header;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self dy_data_from_server_page:_page];
    }];
    self.tableView.mj_footer = footer;
    
    [self dy_setTableHeaderView];
    
//    if (DEBUG) {
//        DY_GuidePageController *gpVC = [[DY_GuidePageController alloc] init];
//        [self presentViewController:gpVC animated:NO completion:nil];
//    }

    //跳转引导图
    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
        DY_GuidePageController *gpVC = [[DY_GuidePageController alloc] init];
        [self presentViewController:gpVC animated:NO completion:nil];
    }

}

-(void)dy_setTableHeaderView {
    
    NSArray *imagesURLStrings = @[];
    // 情景三：图片配文字
    NSArray *titles = @[];

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0
                                                                                                , CC_Width, CC_Width *0.55) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];

    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.autoScrollTimeInterval = 4;
    cycleScrollView.titlesGroup = titles;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    _cycleScrollView = cycleScrollView;

    
}


#pragma mark --- SDCycleScrollView代理方法 ---
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    DY_MovieDescModel *movieModel = self.headerArr[index];
    DY_ArticleDetailController *detailVC = [[DY_ArticleDetailController alloc] init];
    detailVC.movieModel = movieModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark --- tableView代理方法 ---
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier =@"DY_FilmReviewCellId";
    DY_FilmReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DY_FilmReviewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    DY_FilmReviewModel *model = self.dataArray[indexPath.row];
    cell.filmModel = model;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DY_FilmReviewCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DY_FilmReviewModel *model = self.dataArray[indexPath.row];

    DY_ArticleDetailController *detailVC = [[DY_ArticleDetailController alloc] init];
    detailVC.filmModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)dy_data_from_server_page:(NSInteger)page
{
    
    [DY_LeanCloudNet getListWithClassName:URL_HotListModel skip:page orderby:nil limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"dic - %@",array);
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DY_FilmReviewModel *model = [[DY_FilmReviewModel alloc] initWithDictionary:dic];
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


- (NSMutableArray *)headerArr
{
    if (!_headerArr) {
        _headerArr = [NSMutableArray new];
    }
    return _headerArr;
}

-(void)dy_data_header_server {
    
    AVQuery *query = [AVQuery queryWithClassName:URL_MovieDescModel];
    [query whereKey:@"top" equalTo:@1];
    [DY_LeanCloudNet findObjectWithQuery:query skip:1 limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        
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
            self.headerArr = headerArr;
            
            self.cycleScrollView.titlesGroup = titles;
            self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
            [self.tableView setTableHeaderView:self.cycleScrollView];

        } else {
            [self.tableView setTableHeaderView:nil];
        }
        
        
    } failure:^(DYLeanCloudError error) {
        [self.tableView setTableHeaderView:nil];

    }];
}

- (void)setIsLandscape:(BOOL)isLandscape {
    [super setIsLandscape:isLandscape];
    
    self.cycleScrollView.frame = CGRectMake(0, 0
                                            , CC_Width, CC_Width *0.55);
}


@end

