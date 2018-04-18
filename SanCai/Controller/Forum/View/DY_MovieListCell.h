//
//  DY_MovieListCell.h
//  SanCai
//
//  Created by SongChang on 2018/4/17.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DY_MovieDescModel.h"

@interface DY_MovieListCell : UITableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic,strong)DY_MovieDescModel *descModel;

@end
