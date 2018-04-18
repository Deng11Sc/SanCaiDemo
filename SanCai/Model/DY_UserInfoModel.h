//
//  DY_UserInfoModel.h
//  MerryS
//
//  Created by SongChang on 2018/1/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_UserInfoModel : NSObject

@property (nonatomic,strong)NSString *imageUrl;

@property (nonatomic,strong)NSString *nickName;

@property (nonatomic,strong)NSString *objectId;

@property (nonatomic,strong)NSString *sessionToken;

@property (nonatomic,strong)NSString *scores;

///期望物品id
@property (nonatomic,strong)NSString *goodsId;

//期望物品名字
@property (nonatomic,strong)NSString *goodsTitle;



@end
