//
//  DY_TaskManager.m
//  SanCai
//
//  Created by SongChang on 2018/4/13.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_TaskManager.h"

#import "NSString+ScoresManager.h"

@implementation DY_TaskManager


+(DY_TaskManager *)manager {
    static DY_TaskManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DY_TaskManager alloc] init];
    });
    return _manager;
}


-(NSString *)getUserMark {
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"YYYY.MM.dd"];
    NSString *DateTime1 = [formatter1 stringFromDate:date1];
    return DateTime1;
}

///获取用户当天完成任务的情况
- (void)getUserTaskData_successBlk:(void (^)(NSMutableArray<DY_TasksModel *> *dataArray))successBlk
{
    AVQuery *query = [AVQuery queryWithClassName:URL_UserTasksModel];
    [query whereKey:@"userId" equalTo:SELF_USER_ID];
    [query whereKey:@"userMark" equalTo:[self getUserMark]];
    
    [DY_LeanCloudNet findObjectWithQuery:query skip:1 limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        
        NSMutableArray *userTaskArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DY_UserTasksModel *userTasksModel = [[DY_UserTasksModel alloc] initWithDictionary:dic];
            
            [userTaskArr addObject:userTasksModel];
        }
//        self.userTaskArr = userTaskArr;
        
        [self getTaskList:userTaskArr successBlk:successBlk];
        
    } failure:^(DYLeanCloudError error) {
        if (successBlk) {
            successBlk(nil);
        }
    }];

}

-(void)getTaskList:(NSMutableArray *)userTaskArr successBlk:(void (^)(NSMutableArray<DY_TasksModel *> *dataArray))successBlk
{
    ///获取任务列表
    [DY_LeanCloudNet getListWithClassName:URL_TasksListModel skip:0 orderby:nil limit:50 success:^(NSMutableArray *array,AVObject *object) {
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DY_TasksModel *tasksModel = [[DY_TasksModel alloc] initWithDictionary:dic];
            
            for (DY_UserTasksModel *userTasksModel in userTaskArr) {
                
                if (tasksModel.taskId == userTasksModel.finishTaskId) {
                    tasksModel.userTasksModel = userTasksModel;
                    break;
                }
            }
            [dataArray addObject:tasksModel];
            self.tasksArr = dataArray;
            
        }
        if (successBlk) {
            successBlk(dataArray);
        }

    } failure:^(DYLeanCloudError error) {
        if (successBlk) {
            successBlk(nil);
        }

    }];

}


- (void)increaseScoresByTaskType:(NSString *)taskType {
    
    if (self.tasksArr == nil) {
        NSLog(@"积分任务获取失败 ---");
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        /********************************************************************************/

        DY_TasksModel *currentTaskModel = nil;
        for (DY_TasksModel *taskModel in self.tasksArr) {
            
            if ([taskModel.taskType isEqualToString:taskType]) {
                currentTaskModel = taskModel;
                break;
            }
        }
        
        if (currentTaskModel) {
            
            if (currentTaskModel.userTasksModel == nil) {
                
                AVObject *todoFolder = [[AVObject alloc] initWithClassName:URL_UserTasksModel];
                [todoFolder setObject:@1 forKey:@"priority"];// 设置优先级
                
                //
                [todoFolder setObject:SELF_USER_ID forKey:@"userId"];
                [todoFolder setObject:@1 forKey:@"finishTimes"];
                [todoFolder setObject:[self getUserMark] forKey:@"userMark"];
                [todoFolder setObject:currentTaskModel.taskId forKey:@"finishTaskId"];

                
                [todoFolder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        // 存储成功
                        NSLog(@" 积分任务type:%@完成了一次,当前完成状态为%ld/%ld",taskType,(long)1,[currentTaskModel.finishMaxNumber integerValue]);

                    } else {
                        
                    }
                }];
                
//                DY_UserTasksModel *model = [[DY_UserTasksModel alloc] init];
//                model.userId = SELF_USER_ID;
//                model.finishTimes = @"1";
//                model.userMark = [self getUserMark];
//                model.finishTaskId = currentTaskModel.taskId;
//                currentTaskModel.userTasksModel = model;
//
//                [DY_LeanCloudNet saveObject:model objectId:nil className:URL_UserTasksModel relationId:nil success:^(NSMutableArray *array) {
//
//                    NSLog(@" 积分任务type:%@完成了一次,当前完成状态为%ld/%ld",taskType,[model.finishTimes integerValue],[currentTaskModel.finishMaxNumber integerValue]);
//
//                } failure:^(DYLeanCloudError error) {
//
//                }];
            } else {
                ///如果还可以完成，则调用
                if ([currentTaskModel.userTasksModel.finishTimes integerValue] < [currentTaskModel.finishMaxNumber integerValue]) {
                    
                    AVObject *praiseObject = [AVObject objectWithClassName:URL_UserTasksModel objectId:currentTaskModel.userTasksModel.objId];
                    [praiseObject incrementKey:@"finishTimes" byAmount:@1];
                    
                    AVQuery *query = [AVQuery queryWithClassName:URL_UserTasksModel];
                    [query whereKey:@"userId" equalTo:currentTaskModel.userTasksModel.userId];
                    
                    AVSaveOption *option = [[AVSaveOption alloc] init];
                    option.query = query;
                    option.fetchWhenSave = NO;
                    [praiseObject saveInBackgroundWithOption:option block:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            
                            NSLog(@" 积分任务type:%@完成了一次,当前完成状态为%ld/%ld",taskType,[currentTaskModel.userTasksModel.finishTimes integerValue]+1,[currentTaskModel.finishMaxNumber integerValue]);
                            
                            //提升积分
                            [NSString server_saveScoresWithUserId:SELF_USER_ID objId:nil changedNumber:[currentTaskModel.taskScores integerValue]];

                            
                        } else if (error.code == 305) {
                        }
                    }];
                    
                } else {
                    NSLog(@" 积分任务type:%@今天的目标已经全部完成",taskType);
                }
            
            }
            
        }
        /********************************************************************************/
    });
}



- (void)logoutClear {
    self.tasksArr = nil;
}

@end
