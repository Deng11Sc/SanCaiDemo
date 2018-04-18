//
//  DY_GetRewardsController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_GetRewardsController.h"

#import "DY_ShopListCell.h"
#import "DY_ShopListModel.h"

#import "DY_MallDetailController.h"

@interface DY_GetRewardsController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectView;


@end

@implementation DY_GetRewardsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Scores Mall", @"积分商城");
    [self _setCollcetionView];
    
    [self dy_data_from_server_page];
}



-(void)_setCollcetionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat width = (DY_Width-10*3)/2;
    layout.itemSize = CGSizeMake(width, width-30);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, DY_Width, DY_Height-NavHeight) collectionViewLayout:layout];
    //代理设置
    collect.backgroundColor = [UIColor clearColor];
    collect.delegate=self;
    collect.dataSource=self;
    [collect registerClass:[DY_ShopListCell class] forCellWithReuseIdentifier:@"DY_ShopListCellId"];
    self.collectView = collect;
    
    [self.view addSubview:collect];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DY_ShopListCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"DY_ShopListCellId" forIndexPath:indexPath];
    
    DY_ShopListModel *model = self.dataArray[indexPath.row];
    cell.listModel = model;
    
    return cell;
}


//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    DY_ShopListModel *listModel = self.dataArray[indexPath.row];
    
    DY_MallDetailController *detailVC = [[DY_MallDetailController alloc] init];
    detailVC.listModel = listModel;
    detailVC.title = listModel.mallGoodsName;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
}


///获取列表数据
-(void)dy_data_from_server_page {
    
    [DY_LeanCloudNet getListWithClassName:URL_Mall_list skip:0 orderby:nil limit:50 success:^(NSMutableArray *array,AVObject *object) {
        
        NSLog(@"dic - %@",array);
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DY_ShopListModel *model = [[DY_ShopListModel alloc] initWithDictionary:dic];
            [dataArray addObject:model];
        }
        self.dataArray = dataArray;
        [self.collectView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        
    }];
}


- (void)setIsLandscape:(BOOL)isLandscape {
    [super setIsLandscape:isLandscape];
    
    self.collectView.frame = CGRectMake(0, 0, DY_Width, DY_Height-NavLandscapeHeight(isLandscape));
    [self.collectView reloadData];
}

@end
