//
//  DYLoginInfoManager.h
//  MerryS
//
//  Created by SongChang on 2018/1/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYUserInfoModel.h"



@interface DYLoginInfoManager : NSObject

+(DYLoginInfoManager *)manager;

+ (void)saveUserInfo:(DYUserInfoModel *)model;

+(DYUserInfoModel *)getUserInfo;

@property (nonatomic,assign)BOOL isLogin;

-(void)logout;

@end
