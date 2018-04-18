//
//  DY_MallDetailController.m
//  SanCai
//
//  Created by SongChang on 2018/4/17.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_MallDetailController.h"

#import "DY_WinningModel.h"

#import "DY_AddressController.h"

///积分管理
#import "NSString+ScoresManager.h"

@interface DY_MallDetailController ()

@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UIView *exchangeView;

@end

@implementation DY_MallDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dy_initTableView];

}

-(UIImageView *)imgView
{
    if (!_imgView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imgView = imageView;
    }
    return _imgView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"mallDetailId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        
        [cell.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(4);
            make.centerX.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(DY_SCREEN_MIN/2, DY_SCREEN_MIN/2));
        }];
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.listModel.imageUrl] placeholderImage:DY_PlaceholderImage];
        
    } else if (indexPath.row == 1) {
        
        [cell.contentView addSubview:self.exchangeView];
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return DY_SCREEN_MIN/2+8;
    }
    
    return 80.f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//    return 80.f;
//}
//
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return self.exchangeView;
//}

- (UIView *)exchangeView {
    if (!_exchangeView) {
        UIView *logoutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DY_Width, 80)];
        
        
        UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        logoutBtn.frame = CGRectMake(logoutView.width/2-120/2, logoutView.height/2-44/2, 120, 44);
        [logoutBtn dy_configure];
        logoutBtn.tag = 1;
        logoutBtn.backgroundColor = DY_CustomColor_2594D2;
        [logoutBtn setTitle:DYLocalizedString(@"Exchange Goods", @"兑换物品") forState:0];
        [logoutBtn addTarget:self action:@selector(exchangeAction:) forControlEvents:UIControlEventTouchUpInside];
        [logoutView addSubview:logoutBtn];
        [logoutBtn.layer setCornerRadius:4];
        logoutBtn.clipsToBounds = YES;
        
        _exchangeView = logoutView;
    }
    
    return _exchangeView;
}


- (void)exchangeAction:(UIButton *)sender
{
    
    ///获取自己的积分
    [NSString server_getScoresModelWithUserId:SELF_USER_ID blk:^(DY_ScoresModel *scoresModel) {
        
        if ([scoresModel.scores integerValue] >= [self.listModel.priceScores integerValue]) {

            DY_WinningModel *winModel = [[DY_WinningModel alloc] init];
            winModel.goodsDes = self.listModel.mallGoodsDesc;
            winModel.userId = SELF_USER_ID;
            winModel.goodsImageUrl = self.listModel.imageUrl;
            winModel.goodsName = self.listModel.mallGoodsName;
            winModel.priceScores = self.listModel.priceScores;
            
            
            __block DY_WinningModel *weakWinModel = winModel;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [DY_LeanCloudNet saveObject:winModel objectId:nil className:URL_WinningModel relationId:nil success:^(NSMutableArray *array,AVObject *object) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                DY_AddressController *addrVC = [[DY_AddressController alloc] init];
                @weakify(self)
                addrVC.selectAddressBlk = ^(NSString *address) {
                    @strongify(self)
                    
                    ///减少积分
                    [NSString server_saveScoresWithUserId:SELF_USER_ID objId:scoresModel.objId changedNumber:-[winModel.priceScores integerValue]];

                    weakWinModel.address = address;
                    [self dy_selectedAddressAndSave:weakWinModel objectId:object.objectId];
                    
                };
                [self.navigationController pushViewController:addrVC animated:YES];
                
                
            } failure:^(DYLeanCloudError error) {
                
            }];

        } else {
            [NSObject showMessage:DYLocalizedString(@"Your scores are not enough", @"您的积分不足")];
        }
        
    }];
    
}


///选择了地址并保存
-(void)dy_selectedAddressAndSave:(DY_WinningModel *)winModel objectId:(NSString *)objectId {
    @weakify(self)
    
    [DY_LeanCloudNet saveObject:winModel objectId:objectId className:URL_WinningModel relationId:nil success:^(NSMutableArray *array,AVObject *object) {
        
        @strongify(self)
        [self dy_actionBack];
        
    } failure:^(DYLeanCloudError error) {
        
    }];

}

- (void)setIsLandscape:(BOOL)isLandscape {
    [super setIsLandscape:isLandscape];
    
    self.exchangeView.frame = CGRectMake(0, 0, DY_Width, 80);
    [self.exchangeView viewWithTag:1].frame = CGRectMake(self.exchangeView.width/2-120/2, self.exchangeView.height/2-44/2, 120, 44);

    
}


@end
