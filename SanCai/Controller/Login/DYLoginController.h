//
//  DYLoginController.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYBaseController.h"
///用户信息界面
#import "DYLoginInfoManager.h"

@interface DYLoginController : DYBaseController

@property (nonatomic,strong)void (^loginSuccessBlk)(BOOL succeeded);

@end
