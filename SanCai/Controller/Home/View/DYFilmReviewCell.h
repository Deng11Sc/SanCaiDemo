//
//  DYFilmReviewCell.h
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import "DYFilmReviewModel.h"

@interface DYFilmReviewCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic,strong)DYFilmReviewModel *filmModel;

@end
