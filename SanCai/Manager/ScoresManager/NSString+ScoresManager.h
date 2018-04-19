//
//  NSString+ScoresManager.h
//  SanCai
//
//  Created by SongChang on 2018/4/13.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

///
#import "DY_ScoresModel.h"

@interface NSString(ScoresManager)


///保存积分
-(void)local_saveScores;
+(void)local_saveScores:(NSString *)scores;

///获取积分
+(NSString *)local_getScores;

///初始化积分数据
//+(void)server_initScoresDataWithUserId:(NSString *)userId endblk:(void (^)(BOOL isSeccess))endBlk;

///变更积分  正数为增加了，负数为减少了
/*
 objId可不传，应该
 */
+(void)server_saveScoresWithUserId:(NSString *)userId objId:(NSString *)objId changedNumber:(NSInteger)changedNumber endblk:(void (^)(BOOL isSeccess))endBlk;

///获取用户的积分
+(void)server_getScoresModelWithUserId:(NSString *)userId blk:(void (^)(DY_ScoresModel *scoresModel))blk;

+(void)logoutClear;

@end

