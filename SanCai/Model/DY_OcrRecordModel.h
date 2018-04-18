//
//  DYOcrRecordModel.h
//  MerryS
//
//  Created by SongChang on 2018/1/18.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+FMDB.h"

@interface DY_OcrRecordModel : NSObject

///
@property (nonatomic,strong)NSString *ocrResultStr;

///识别时保存到数据库的id --- 结构为UserId+时间戳
@property (nonatomic,strong)NSString *sqlId;

///识别时使用的用户
@property (nonatomic,strong)NSString *userId;

///时间戳
@property (nonatomic,strong)NSString *ocrCurTime;

//leanCloud的唯一id
@property (nonatomic,strong)NSString *objectId;


-(void)updateOcrCurTime;

///更新数据库到最新状态，云同步
- (void)updateToNewest;


@end
