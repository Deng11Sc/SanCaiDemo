//
//  DY_ReleaseCommentView.h
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY_MovieDescModel.h"
#import "DY_FilmReviewModel.h"

///发布影评等
@interface DY_ReleaseCommentView : UIView

@property (nonatomic,strong)DY_MovieDescModel *movieModel;

+ (CGFloat)height;

@property (nonatomic,strong)void (^releaseCommentBlk)(DY_FilmReviewModel *filmModel);

@end
