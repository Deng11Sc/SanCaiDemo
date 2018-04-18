//
//  DY_FilmReviewModel.h
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_FilmReviewModel : NSObject

@property (nonatomic,strong)NSString *objId;

@property (nonatomic,strong)NSString *movieImgUrl;

@property (nonatomic,strong)NSString *commentType;

@property (nonatomic,strong)NSString *movieName;

//评论的目标电影的Id
@property (nonatomic,strong)NSString *movieId;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSString *movieDesc;

//评论人
@property (nonatomic,strong)NSString *commentator;

@property (nonatomic,strong)NSString *authorId;

@property (nonatomic,strong)NSString *scores;

///任务类型
@property (nonatomic,strong)NSString *taskType;


@end
