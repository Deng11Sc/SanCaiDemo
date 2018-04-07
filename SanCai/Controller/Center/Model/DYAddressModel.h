//
//  DYAddressModel.h
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AVObject.h"

@interface DYAddressModel : AVObject

@property (nonatomic,strong)NSString *objId;

@property (nonatomic,strong)NSString *address;

@property (nonatomic,strong)NSString *receiveName;

@property (nonatomic,strong)NSString *receivePhone;


@end
