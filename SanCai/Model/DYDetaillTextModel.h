//
//  DYDetaillTextModel.h
//  MerryS
//
//  Created by SongChang on 2018/1/25.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYDetaillTextModel : NSObject

@property (nonatomic,strong)NSString *text;

@property (nonatomic,assign)CGFloat height;

@property (nonatomic,assign)BOOL isImage;

@property (nonatomic,strong)NSString *imageUrl;

@end
