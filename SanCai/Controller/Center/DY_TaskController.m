//
//  DY_TaskController.m
//  SanCai
//
//  Created by SongChang on 2018/4/9.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_TaskController.h"

#import "DY_TaskListCell.h"

#import "DY_UserTasksModel.h"
#import "DY_TasksModel.h"

@interface DY_TaskController ()

@property (nonatomic,strong)NSMutableArray *userTaskArr;

@end

@implementation DY_TaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"My Tasks", nil);
    
    [self dy_initTableView];
    
    [self getUserTasks_server];
}

-(void)dy_data_from_server_page {
    
    ///获取任务列表
    [DY_LeanCloudNet getListWithClassName:URL_TasksListModel skip:0 orderby:nil limit:50 success:^(NSMutableArray *array,AVObject *object) {
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DY_TasksModel *tasksModel = [[DY_TasksModel alloc] initWithDictionary:dic];
            
            for (DY_UserTasksModel *userTasksModel in self.userTaskArr) {
                
                if (tasksModel.taskId == userTasksModel.finishTaskId) {
                    tasksModel.userTasksModel = userTasksModel;
                    break;
                }
            }
            
            [dataArray addObject:tasksModel];
        }
        self.dataArray = dataArray;
        
        [self.tableView reloadData];
        
    } failure:^(DYLeanCloudError error) {
        
    }];
    
}

-(void)getUserTasks_server {
    ///获取用户完成任务的情况
    AVQuery *query = [AVQuery queryWithClassName:URL_UserTasksModel];
    [query whereKey:@"userId" equalTo:SELF_USER_ID];
    
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"YYYY.MM.dd"];
    NSString *DateTime1 = [formatter1 stringFromDate:date1];
    
    [query whereKey:@"userMark" equalTo:DateTime1];
    [DY_LeanCloudNet findObjectWithQuery:query skip:1 limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        
        NSMutableArray *userTaskArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
            DY_UserTasksModel *userTasksModel = [[DY_UserTasksModel alloc] initWithDictionary:dic];
                        
            [userTaskArr addObject:userTasksModel];
        }
        self.userTaskArr = userTaskArr;
        
        [self dy_data_from_server_page];
        
        
    } failure:^(DYLeanCloudError error) {
        
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier =@"DY_TaskListCellId";
    DY_TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DY_TaskListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    DY_TasksModel *tasksModel = self.dataArray[indexPath.row];
    
    cell.tasksModel = tasksModel;
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DY_TaskListCell cellHeight];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
