//
//  DYUserInfoHeaderView.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYUserInfoModel.h"

@interface DYUserInfoHeaderView : UIView

@property (nonatomic,strong)DYUserInfoModel *userInfo;

@property (nonatomic,strong)void (^clickHeadBlk)();

@end
