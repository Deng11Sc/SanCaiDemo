//
//  DY_FilmReviewCell.h
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import "DY_FilmReviewModel.h"

@interface DY_FilmReviewCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic,strong)DY_FilmReviewModel *filmModel;

@end
