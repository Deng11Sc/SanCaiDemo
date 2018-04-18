//
//  DY_MineListCell.m
//  SanCai
//
//  Created by SongChang on 2018/4/16.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_MineListCell.h"

@implementation DY_MineListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightArrowImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (UIImageView *)rightArrowImgView
{
    if (!_rightArrowImgView) {
        UIImageView *rightArrowImgView =[[UIImageView alloc] init];
        rightArrowImgView.image = [UIImage imageNamed:@"mine_right_arrow"];
        [self addSubview:rightArrowImgView];
        
        [rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(2);
            make.width.height.equalTo(@16);
            make.right.equalTo(@(-4));
        }];
        
        _rightArrowImgView = rightArrowImgView;
    }
    return _rightArrowImgView;
}


@end
