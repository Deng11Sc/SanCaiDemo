//
//  NSString+ScoresManager.m
//  SanCai
//
//  Created by SongChang on 2018/4/13.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "NSString+ScoresManager.h"


@implementation NSString(ScoresManager)


///保存积分
-(void)local_saveScores
{
    [NSString local_saveScores:self];
}

+(void)local_saveScores:(NSString *)scores
{
    [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"scores_"];
}

///获取积分
+(NSString *)local_getScores
{
    NSString *scores = [[NSUserDefaults standardUserDefaults] objectForKey:@"scores_"];
    if ([NSString isEmptyString:scores]) {
        return @"0";
    }
    
    return scores;
}

///初始化积分数据
+(void)server_initScoresDataWithUserId:(NSString *)userId endblk:(void (^)(BOOL isSeccess))endBlk
{
    DY_ScoresModel *scoresModel = [[DY_ScoresModel alloc] init];
    scoresModel.userId = userId;
    scoresModel.scores = @"0";
    
    [DY_LeanCloudNet saveObject:scoresModel objectId:nil className:URL_ScoresModel relationId:nil success:^(NSMutableArray *array,AVObject *object) {
        
        if (endBlk) {
            endBlk(YES);
        }
        
        
    } failure:^(DYLeanCloudError error) {
        if (endBlk) {
            endBlk(NO);
        }
    }];
    
    [scoresModel.scores local_saveScores];
}

+(void)server_saveScoresWithUserId:(NSString *)userId objId:(NSString *)objId changedNumber:(NSInteger)changedNumber
{
    
    AVQuery *query = [AVQuery queryWithClassName:URL_ScoresModel];
    [query whereKey:@"userId" equalTo:userId];
    
    __block NSString *weakObjId = objId;
    [DY_LeanCloudNet findObjectWithQuery:query skip:1 limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        if (array.count == 0) {
            
            [NSString server_initScoresDataWithUserId:userId endblk:^(BOOL isSeccess) {
                if (isSeccess) {
                    [self server_saveScoresWithUserId:userId objId:weakObjId changedNumber:changedNumber];
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self server_saveScoresWithUserId:userId objId:weakObjId changedNumber:changedNumber];
                    });
                }
            }];
            
        } else {
            
            NSDictionary *dic = array.lastObject;
            if ([NSString isEmptyString:weakObjId]) {
                weakObjId = dic[@"objId"];
            }
            
            //改变积分
            AVObject *praiseObject = [AVObject objectWithClassName:URL_ScoresModel objectId:weakObjId];
            [praiseObject incrementKey:@"scores" byAmount:@(changedNumber)];
            
            AVQuery *query = [[AVQuery alloc] init];
            [query whereKey:@"userId" equalTo:userId];
            
            AVSaveOption *option = [[AVSaveOption alloc] init];
            option.query = query;
            option.fetchWhenSave = NO;
            [praiseObject saveInBackgroundWithOption:option block:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"%@ - 改变积分成功:%ld",NSStringFromSelector(_cmd),changedNumber);
                } else if (error.code == 305) {
                }
            }];
            
            
        }
        
    } failure:^(DYLeanCloudError error) {
        
    }];
    
}


+(void)server_getScoresModelWithUserId:(NSString *)userId blk:(void (^)(DY_ScoresModel *scoresModel))blk
{
    if ([NSString isEmptyString:userId]) {
        userId = SELF_USER_ID;
    }
    
    AVQuery *query = [AVQuery queryWithClassName:URL_ScoresModel];
    [query whereKey:@"userId" equalTo:userId];
    [DY_LeanCloudNet findObjectWithQuery:query skip:1 limit:-1 success:^(NSMutableArray *array,AVObject *object) {
        
        if (array.count) {
            NSDictionary *dict = array.lastObject;
            DY_ScoresModel *model = [[DY_ScoresModel alloc] initWithDictionary:dict];
            
            [self local_saveScores:model.scores];
            
            if (blk) {
                blk(model);
            }

        } else {
            [NSString server_initScoresDataWithUserId:userId endblk:^(BOOL isSeccess) {
                if (isSeccess) {
                    [self local_saveScores:@"0"];
                    
                    DY_ScoresModel *model = [[DY_ScoresModel alloc] init];
                    model.userId = userId;
                    model.scores = @"0";
                    if (blk) {
                        blk(model);
                    }
                } else {
                    if (blk) {
                        blk(nil);
                    }
                }
            }];
        }
        
    } failure:^(DYLeanCloudError error) {
        if (blk) {
            blk(nil);
        }

    }];
}



+(void)logoutClear {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"scores_"];
}


@end
