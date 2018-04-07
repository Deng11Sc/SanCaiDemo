//
//  ForumList.h
//  MerryS
//
//  Created by SongChang on 2018/1/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "NNSqliteManager.h"

@interface ForumList : AVObject

///标题
@property (nonatomic,strong)NSString *title;

///内容
@property (nonatomic,strong)NSString *content;
///封面
@property (nonatomic,strong)NSString *image;

///所属分类
@property (nonatomic,strong)NSString *tagsName;
@property (nonatomic,strong)NSString *tagsId;
///作者
@property (nonatomic,strong)NSString *author;
///文章id
@property (nonatomic,strong)NSString *articleId;

@property (nonatomic,strong)NSString *top;

///跳转链接
@property (nonatomic,strong)NSString *webUrl;

////计算内容
//cell高度
@property (nonatomic,assign)CGFloat height;

@property (nonatomic,strong)NSString *subTitle;

@end
