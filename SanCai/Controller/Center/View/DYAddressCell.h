//
//  DYAddressCell.h
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYAddressModel.h"

@interface DYAddressCell : UITableViewCell

@property (nonatomic,strong)DYAddressModel *addrModel;


@property (nonatomic,strong)void (^deleteBlk)(DYAddressModel *addrModel);

@property (nonatomic,strong)void (^editBlk)(DYAddressModel *addrModel);


@end
