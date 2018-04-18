//
//  DY_AddressModel.h
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AVObject.h"

@interface DY_AddressModel : AVObject

@property (nonatomic,strong)NSString *objId;

@property (nonatomic,strong)NSString *address;

@property (nonatomic,strong)NSString *receiveName;

@property (nonatomic,strong)NSString *receivePhone;

///所属人
@property (nonatomic,strong)NSString *userId;


///任务类型
@property (nonatomic,strong)NSString *taskType;

@end
