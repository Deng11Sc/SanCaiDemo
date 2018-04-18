//
//  DY_UserInfoHeaderView.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY_UserInfoModel.h"

@interface DY_UserInfoHeaderView : UIView

@property (nonatomic,strong)DY_UserInfoModel *userInfo;

@property (nonatomic,strong)void (^clickHeadBlk)(void);

@end
