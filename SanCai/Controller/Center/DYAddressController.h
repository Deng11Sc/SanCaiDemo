//
//  DYAddressController.h
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYBaseController.h"

@interface DYAddressController : DYBaseController

@property (nonatomic,strong)void (^selectAddressBlk)(NSString *address);

@end