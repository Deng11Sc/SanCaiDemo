//
//  DY_TaskListCell.h
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DY_TasksModel.h"

@interface DY_TaskListCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic,strong)DY_TasksModel *tasksModel;

@end
