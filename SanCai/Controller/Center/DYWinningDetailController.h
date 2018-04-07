//
//  DYWinningDetailController.h
//  SanCai
//
//  Created by SongChang on 2018/4/6.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYBaseController.h"
#import "DYWinningModel.h"

@interface DYWinningDetailController : DYBaseController

@property (nonatomic,strong)DYWinningModel *winModel;

@property (nonatomic,strong)void (^isRefreshBlk)(BOOL refresh);

@end
