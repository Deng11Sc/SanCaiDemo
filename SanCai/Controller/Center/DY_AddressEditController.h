//
//  DY_AddressEditController.h
//  SanCai
//
//  Created by SongChang on 2018/4/7.
//  Copyright © 2018年 SongChang. All rights reserved.
//

typedef NS_ENUM(NSInteger,DYEditAddressType) {
    DYEditAddressTypeAdd = 0,   //新增
    DYEditAddressTypeChanged,   //修改
};

#import "DY_BaseController.h"

#import "DY_AddressModel.h"

@interface DY_AddressEditController : DY_BaseController

@property (nonatomic,assign)DYEditAddressType type;
///成功回调
@property (nonatomic,strong)void (^refreshBlk)(void);

@property (nonatomic,strong)DY_AddressModel *addrModel;

@end
