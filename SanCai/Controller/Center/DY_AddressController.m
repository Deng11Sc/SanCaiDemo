//
//  DY_AddressController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_AddressController.h"

#import "DY_AddressCell.h"

#import "DY_AddressEditController.h"

#import "UIBarButtonItem+Custom.h"

@interface DY_AddressController ()

@end

@implementation DY_AddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self dy_initTableView];
    [self dy_data_from_server_page];
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem customBarButtonItemWithImageName:@"icon_item_add" action:@selector(rightItemAction) vc:self];
}

- (void)rightItemAction {
    DY_AddressEditController *editVC = [[DY_AddressEditController alloc] init];
    editVC.type = DYEditAddressTypeAdd;
    editVC.addrModel = nil;
    @weakify(self)
    editVC.refreshBlk = ^{
        @strongify(self)
        [self dy_data_from_server_page];
    };
    [self.navigationController pushViewController:editVC animated:YES];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"addressCellId";
    DY_AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[DY_AddressCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    DY_AddressModel *addrModel = self.dataArray[indexPath.row];
    cell.addrModel = addrModel;
    
    @weakify(self)
    cell.editBlk = ^(DY_AddressModel *addrModel) {
        @strongify(self)
        DY_AddressEditController *editVC = [[DY_AddressEditController alloc] init];
        editVC.type = DYEditAddressTypeChanged;
        editVC.addrModel = addrModel;
        @weakify(self)
        editVC.refreshBlk = ^{
            @strongify(self)
            [self dy_data_from_server_page];
        };
        [self.navigationController pushViewController:editVC animated:YES];
    };
    
    __weak NSIndexPath *weakIndexPath = indexPath;
    cell.deleteBlk = ^(DY_AddressModel *addrModel) {
        @strongify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:DYLocalizedString(@"Whether to delete this address?", @"是否删除该地址?") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:DYLocalizedString(@"OK", @"确定")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [self dy_deletaAddress_server:addrModel row:weakIndexPath.row];
                                                        }];
        [alert addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:DYLocalizedString(@"Cancel", @"取消")
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            
                                                        }];
        [alert addAction:action2];

        [self presentViewController:alert animated:YES completion:nil];
        
    };
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //30是编辑，删除的高度
    return 80.f+8.f+30.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DY_AddressModel *addrModel = self.dataArray[indexPath.row];
    
    if (self.selectAddressBlk) {
        self.selectAddressBlk(addrModel.address);
        [self dy_actionBack];
    }
}


-(void)dy_data_from_server_page {
    
    AVQuery *query = [AVQuery queryWithClassName:@"dy_address_list"];
    [query whereKey:@"userId" equalTo:SELF_USER_ID];
    [DY_LeanCloudNet findObjectWithQuery:query skip:1 limit:100  success:^(NSMutableArray *array,AVObject *object) {
        
        NSLog(@"dic - %@",array);
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            DY_AddressModel *addrModel = [[DY_AddressModel alloc] initWithDictionary:dic];
            [dataArray addObject:addrModel];
        }
        self.dataArray = dataArray;
        [self.tableView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        
    }];

    
}


-(void)dy_deletaAddress_server:(DY_AddressModel *)addrModel row:(NSInteger)row {
    //delete from GameScore where objectId=?
    NSString *cql = [NSString stringWithFormat:@"delete from %@ where objectId='%@'", @"dy_address_list",addrModel.objId];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error)
     {
         NSLog(@"results:%@", result.results);
         [self dy_data_from_server_page];
     }];

}

@end
