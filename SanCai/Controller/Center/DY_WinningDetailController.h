//
//  DY_WinningDetailController.h
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_BaseController.h"
#import "DY_WinningModel.h"

@interface DY_WinningDetailController : DY_BaseController

@property (nonatomic,strong)DY_WinningModel *winModel;

@property (nonatomic,strong)void (^isRefreshBlk)(BOOL refresh);

@end
