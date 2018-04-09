//
//  DYAddressController.m
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYAddressController.h"

#import "DYAddressCell.h"

#import "DYAddressEditController.h"

@interface DYAddressController ()

@end

@implementation DYAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    [self data_from_server];
}


- (void)actionBack {
    
    if (self.selectAddressBlk) {
        self.selectAddressBlk(@"我的地址");
    }
    
    [super actionBack];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"addressCellId";
    DYAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[DYAddressCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    DYAddressModel *addrModel = self.dataArray[indexPath.row];
    cell.addrModel = addrModel;
    
    @weakify(self)
    cell.editBlk = ^(DYAddressModel *addrModel) {
        DYAddressEditController *editVC = [[DYAddressEditController alloc] init];
        editVC.addrModel = addrModel;
        [self.navigationController pushViewController:editVC animated:YES];
    };
    
    __weak NSIndexPath *weakIndexPath = indexPath;
    cell.deleteBlk = ^(DYAddressModel *addrModel) {
        @strongify(self)
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:DYLocalizedString(@"Whether to delete this address?", @"是否删除该地址?") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:DYLocalizedString(@"OK", @"确定")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [self deletaAddress_server:addrModel row:weakIndexPath.row];
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
}


-(void)data_from_server {
    
    AVQuery *query = [AVQuery queryWithClassName:@"dy_address_list"];
    [query whereKey:@"userId" equalTo:SELF_USER_ID];
    [DYLeanCloudNet findObjectWithQuery:query success:^(NSMutableArray *array) {
        
        NSLog(@"dic - %@",array);
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            DYAddressModel *addrModel = [[DYAddressModel alloc] initWithDictionary:dic];
            [dataArray addObject:addrModel];
        }
        self.dataArray = dataArray;
        [self.tableView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        
    }];

    
}


-(void)deletaAddress_server:(DYAddressModel *)addrModel row:(NSInteger)row {
    //delete from GameScore where objectId=?
    NSString *cql = [NSString stringWithFormat:@"delete from %@ where objectId='%@'", @"dy_address_list",addrModel.objId];
    [AVQuery doCloudQueryInBackgroundWithCQL:cql callback:^(AVCloudQueryResult *result, NSError *error)
     {
         NSLog(@"results:%@", result.results);
         [self data_from_server];
     }];

}

@end
