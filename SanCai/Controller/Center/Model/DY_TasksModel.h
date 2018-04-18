//
//  DY_TasksModel.h
//  SanCai
//
//  Created by SongChang on 2018/4/10.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AVQuery.h"
#import "DY_UserTasksModel.h"

@interface DY_TasksModel : AVQuery

@property (nonatomic,strong)NSString *taskName;

@property (nonatomic,strong)NSString *taskId;

@property (nonatomic,strong)NSString *finishMaxNumber;

@property (nonatomic,strong)NSString *taskImg;

@property (nonatomic,strong)NSString *taskScores;

@property (nonatomic,strong)DY_UserTasksModel *userTasksModel;


///任务类型
@property (nonatomic,strong)NSString *taskType;

@end
