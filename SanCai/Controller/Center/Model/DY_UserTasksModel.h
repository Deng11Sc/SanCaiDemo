//
//  DY_UserTasksModel.h
//  SanCai
//
//  Created by SongChang on 2018/4/10.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AVQuery.h"

@interface DY_UserTasksModel : AVQuery

@property(nonatomic,strong)NSString *objId;

@property(nonatomic,strong)NSString *finishTimes;

@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSString *userMark;

///完成的任务Id
@property(nonatomic,strong)NSString *finishTaskId;

@end
