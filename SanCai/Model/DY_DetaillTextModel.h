//
//  DY_DetaillTextModel.h
//  MerryS
//
//  Created by SongChang on 2018/1/25.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_DetaillTextModel : NSObject

@property (nonatomic,strong)NSString *text;

@property (nonatomic,assign)CGFloat height;

@property (nonatomic,assign)BOOL isImage;

@property (nonatomic,strong)NSString *imageUrl;

//获取到图片后已经计算出image的高度,如果获取到了图片高度，再次获取缓存图片时不需要再刷新高度了
@property (nonatomic,assign)CGFloat imageHeight;

@end
