//
//  DYFilmReviewModel.h
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYFilmReviewModel : NSObject

@property (nonatomic,strong)NSString *objId;

@property (nonatomic,strong)NSString *movieImgUrl;

@property (nonatomic,strong)NSString *commentType;

@property (nonatomic,strong)NSString *movieName;

@property (nonatomic,strong)NSString *title;

@property (nonatomic,strong)NSString *movieDesc;

//评论人
@property (nonatomic,strong)NSString *commentator;


@end
