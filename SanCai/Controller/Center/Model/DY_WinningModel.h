//
//  DY_WinningModel.h
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AVObject.h"

@interface DY_WinningModel : AVObject

@property (nonatomic,strong)NSString *objId;

@property (nonatomic,strong)NSString *goodsDes;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *goodsImageUrl;
@property (nonatomic,strong)NSString *goodsName;


@property (nonatomic,strong)NSString *address;

///该物品值的积分
@property (nonatomic,strong)NSString *priceScores;


///任务类型
@property (nonatomic,strong)NSString *taskType;

@end
