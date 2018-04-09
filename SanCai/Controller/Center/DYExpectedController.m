//
//  DYExpectedController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYExpectedController.h"

#import "DYExpectedItem.h"
#import "dy_expected_list.h"

#import "DYLoginController.h"

@interface DYExpectedController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectView;

@property (nonatomic,strong)UILabel *selectLabel;


@end

@implementation DYExpectedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Expected items", @"期望物品");
    
    self.selectLabel.text = [NSString stringWithFormat:@"%@ : %@",DYLocalizedString(@"Selected Objective", @"已选择的期望物品"),[DYLoginInfoManager getUserInfo].goodsTitle];
    [self _setCollcetionView];
    
    [self data_from_server];
}


- (UILabel *)selectLabel {
    if (!_selectLabel) {
        UILabel *selectLabel = [[UILabel alloc] init];
        selectLabel.font = [UIFont systemFontOfSize:17];
        [selectLabel dy_configure];
        [self.view addSubview:selectLabel];
        
        [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(@0);
            make.left.equalTo(@20);
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
    
    CGFloat width = (DY_Width-20*3)/2;
    layout.itemSize = CGSizeMake(width, width+30);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, DY_Width, DY_Height-NavHeight-30) collectionViewLayout:layout];
    //代理设置
    collect.backgroundColor = [UIColor clearColor];
    collect.delegate=self;
    collect.dataSource=self;
    [collect registerClass:[DYExpectedItem class] forCellWithReuseIdentifier:@"expectedItemId"];
    self.collectView = collect;
    
    [self.view addSubview:collect];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DYExpectedItem * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"expectedItemId" forIndexPath:indexPath];
    
    dy_expected_list *listModel = self.dataArray[indexPath.row];
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
    
    
    dy_expected_list *listModel = self.dataArray[indexPath.row];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:DYLocalizedString(@"Make sure to select this item?", nil) message:DYLocalizedString(@"Select this item as your desired, push message to you when there is an item reward", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:DYLocalizedString(@"OK", @"确定")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                        [self selectExpectedGoods_server:listModel];
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
-(void)data_from_server {
    
    [DYLeanCloudNet getList:@"dy_expected_list" orderby:nil limit:50 success:^(NSMutableArray *array) {
        
        NSLog(@"dic - %@",array);
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            dy_expected_list *model = [[dy_expected_list alloc] initWithDictionary:dic];
            [dataArray addObject:model];
        }
        self.dataArray = dataArray;
        [self.collectView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        
    }];
}

///选择自己的期望物品
-(void)selectExpectedGoods_server:(dy_expected_list *)model {
    
    if ([DYLoginInfoManager manager].isLogin == NO) {
        DYLoginController *loginVC = [[DYLoginController alloc] init];
        DYNavigationController *loginNav = [[DYNavigationController alloc] initWithRootViewController:loginVC];
        
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
            
            DYUserInfoModel *info = [DYLoginInfoManager getUserInfo];
            info.goodsTitle = model.title;
            info.goodsId = model.goodsId;
            [DYLoginInfoManager saveUserInfo:info];
        
            self.selectLabel.text = [NSString stringWithFormat:@"%@ : %@",DYLocalizedString(@"Selected Objective", @"已选择的期望物品"),[DYLoginInfoManager getUserInfo].goodsTitle];
        }];

    }
    
}

@end
