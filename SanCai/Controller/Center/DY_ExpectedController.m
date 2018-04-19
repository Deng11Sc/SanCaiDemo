//
//  DY_ExpectedController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_ExpectedController.h"

#import "DY_ExpectedItem.h"
#import "DY__expected_list.h"

#import "DY_LoginController.h"

@interface DY_ExpectedController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign)NSInteger page;

@property (nonatomic,strong)UICollectionView *collectView;

@property (nonatomic,strong)UILabel *selectLabel;


@end

@implementation DY_ExpectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Expected items", @"期望物品");
    
    self.selectLabel.text = [NSString stringWithFormat:@"    %@ : %@",DYLocalizedString(@"Selected Objective", @"已选择的期望物品"),[DY_LoginInfoManager getUserInfo].goodsTitle];
    [self _setCollcetionView];
    
}


- (UILabel *)selectLabel {
    if (!_selectLabel) {
        UILabel *selectLabel = [[UILabel alloc] init];
        [selectLabel dy_configure];
        selectLabel.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:selectLabel];
        
        [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(@0);
            make.left.equalTo(@0);
            make.height.equalTo(@30);
        }];
        
        _selectLabel = selectLabel;
    }
    return _selectLabel;
}


-(void)_setCollcetionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat width = (CC_Width-20*3)/2;
    layout.itemSize = CGSizeMake(width, width+30);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, CC_Width, CC_Height-NavHeight-30) collectionViewLayout:layout];
    //代理设置
    collect.backgroundColor = [UIColor clearColor];
    collect.delegate=self;
    collect.dataSource=self;
    [collect registerClass:[DY_ExpectedItem class] forCellWithReuseIdentifier:@"expectedItemId"];
    self.collectView = collect;
    
    [self.view addSubview:collect];
    
    @weakify(self)
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        _page = 1;
        [self dy_data_from_server_page_page:_page];
    }];
    _collectView.mj_header = header;
    [_collectView.mj_header beginRefreshing];
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        _page += 1;
        [self dy_data_from_server_page_page:_page];
    }];
    _collectView.mj_footer = footer;

    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DY_ExpectedItem * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"expectedItemId" forIndexPath:indexPath];
    
    DY__expected_list *listModel = self.dataArray[indexPath.row];
    cell.listModel = listModel;
    return cell;
}


//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    DY__expected_list *listModel = self.dataArray[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:DYLocalizedString(@"Make sure to select this item?", nil) message:DYLocalizedString(@"Select this item as your desired, push message to you when there is an item reward", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:DYLocalizedString(@"OK", @"确定")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                        [self dy_selectExpectedGoods_server:listModel];
                                                    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:DYLocalizedString(@"Cancel", @"取消")
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                        
                                                    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];

}


///获取列表数据
-(void)dy_data_from_server_page_page:(NSInteger)page {
    
    [DY_LeanCloudNet getListWithClassName:URL_Expected_list skip:page orderby:nil limit:30 success:^(NSMutableArray *array,AVObject *object) {
        [_collectView.mj_header endRefreshing];
        [_collectView.mj_footer endRefreshing];

        NSLog(@"dic - %@",array);
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DY__expected_list *model = [[DY__expected_list alloc] initWithDictionary:dic];
            [dataArray addObject:model];
        }
        
        if (page == 1) {
            self.dataArray = dataArray;
        } else {
            [self.dataArray addObjectsFromArray:dataArray];
        }
        [self.collectView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        [_collectView.mj_header endRefreshing];
        [_collectView.mj_footer endRefreshing];

    }];
}

///选择自己的期望物品
-(void)dy_selectExpectedGoods_server:(DY__expected_list *)model {
    
    if ([DY_LoginInfoManager manager].isLogin == NO) {
        DY_LoginController *loginVC = [[DY_LoginController alloc] init];
        DY_NavigationController *loginNav = [[DY_NavigationController alloc] initWithRootViewController:loginVC];
        
        loginVC.loginSuccessBlk = ^(BOOL succeeded) {
            if (succeeded) {
                
            }
        };
        [self presentViewController:loginNav animated:YES completion:^{
            
        }];
    } else {
        [[AVUser currentUser] setObject:model.goodsId forKey:@"goodsId"];
        [[AVUser currentUser] setObject:model.title forKey:@"goodsTitle"];
        [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            DY_UserInfoModel *info = [DY_LoginInfoManager getUserInfo];
            info.goodsTitle = model.title;
            info.goodsId = model.goodsId;
            [DY_LoginInfoManager saveUserInfo:info];
        
            self.selectLabel.text = [NSString stringWithFormat:@"    %@ : %@",DYLocalizedString(@"Selected Objective", @"已选择的期望物品"),[DY_LoginInfoManager getUserInfo].goodsTitle];
        }];

    }
    
}



-(void)setIsLandscape:(BOOL)isLandscape {
    [super setIsLandscape:isLandscape];
    
    _collectView.frame = CGRectMake(0, 30, CC_Width, CC_Height-NavLandscapeHeight(isLandscape)-30);
    [_collectView reloadData];
}

@end
