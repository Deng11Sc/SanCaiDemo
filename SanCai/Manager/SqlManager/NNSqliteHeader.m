//
//  NNSqliteHeader.m
//  NNLetter
//
//  Created by SongChang on 2017/8/18.
//  Copyright © 2017年 Hunan nian information technology co., LTD. All rights reserved.
//

#import "NNSqliteHeader.h"
#import "NNSqliteManager.h"

#import "DYOcrRecordModel.h"

@implementation NNSqliteHeader

+(void)init_sql
{
    [DYOcrRecordModel initSqlite:nil];
}

+(void)clear
{
    [DYOcrRecordModel delete_all_sqlName:nil];
}

@end
