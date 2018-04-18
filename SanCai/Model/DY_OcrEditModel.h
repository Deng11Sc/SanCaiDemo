//
//  DY_OcrEditModel.h
//  MerryS
//
//  Created by SongChang on 2018/1/25.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DY_OcrEditModel : NSObject

///内容
@property (nonatomic,strong)NSString *editText;

///是否选定
@property (nonatomic,assign)BOOL isSelect;

///是否不需要显示（当为YES时，不显示出来，不加载出来）
@property (nonatomic,assign)BOOL needDelete;


@property (nonatomic,assign)CGFloat height;

@end

