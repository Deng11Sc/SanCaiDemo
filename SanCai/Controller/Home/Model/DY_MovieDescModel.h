//
//  DY_MovieDescModel.h
//  SanCai
//
//  Created by SongChang on 2018/4/16.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_MovieDescModel : NSObject


@property (nonatomic,strong)NSString *movieDesc;

@property (nonatomic,strong)NSString *movieId;

@property (nonatomic,strong)NSString *taskType;

///这个是轮播图用的，长宽比1:0.55
@property (nonatomic,strong)NSString *movieImg;

///这个是列表用的，长宽比0.8:1
@property (nonatomic,strong)NSString *imageUrl;

@property (nonatomic,strong)NSString *movieName;


//作者id
@property (nonatomic,strong)NSString *authorId;

//作者mingzi
@property (nonatomic,strong)NSString *authorName;

///上映时间
@property (nonatomic,strong)NSString *releaseTime;

//语言
@property (nonatomic,strong)NSString *language;

//导演
@property (nonatomic,strong)NSString *director;

//剧情类型
@property (nonatomic,strong)NSString *movieType;;


@end
