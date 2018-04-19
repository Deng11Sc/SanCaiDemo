//
//  DY_TaskManager.h
//  SanCai
//
//  Created by SongChang on 2018/4/13.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DY_TasksModel.h"
#import "DY_UserTasksModel.h"

@interface DY_TaskManager : NSObject

+(DY_TaskManager *)manager;

///用户任务完成情况数组
@property (nonatomic,strong)NSMutableArray<DY_TasksModel *> *tasksArr;

///获取用户当天完成任务的情况
- (void)getUserTaskData_successBlk:(void (^)(NSMutableArray<DY_TasksModel *> *dataArray))successBlk;


-(void)increaseScoresByTaskType:(NSString *)taskType success:(void (^)(void))successBlk;


///退出登陆需要调用
-(void)logoutClear;

@end
