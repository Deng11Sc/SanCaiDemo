//
//  DYOcrRecordModel.m
//  MerryS
//
//  Created by SongChang on 2018/1/18.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYOcrRecordModel.h"

@implementation DYOcrRecordModel

- (void)updateOcrCurTime
{
    NSDate *senddate = [NSDate date];
    self.ocrCurTime = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];

}

- (void)updateToNewest
{
    NSDate *senddate = [NSDate date];
    self.ocrCurTime = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    self.sqlId = [NSString stringWithFormat:@"%@|%@",SELF_USER_ID,self.ocrCurTime];
}

@end
