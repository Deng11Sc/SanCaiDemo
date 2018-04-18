//
//  DY_AddressController.h
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_BaseController.h"

@interface DY_AddressController : DY_BaseController

@property (nonatomic,strong)void (^selectAddressBlk)(NSString *address);

@end
