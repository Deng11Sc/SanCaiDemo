//
//  DY_AddressCell.h
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY_AddressModel.h"

@interface DY_AddressCell : UITableViewCell

@property (nonatomic,strong)DY_AddressModel *addrModel;


@property (nonatomic,strong)void (^deleteBlk)(DY_AddressModel *addrModel);

@property (nonatomic,strong)void (^editBlk)(DY_AddressModel *addrModel);


@end
