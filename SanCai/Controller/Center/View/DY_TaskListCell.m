//
//  DY_TaskListCell.m
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import "DY_TaskListCell.h"

@interface DY_TaskListCell ()

@property (nonatomic,strong)UIImageView *leftImageView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *statusLabel;

@property (nonatomic,strong)UIButton *scoresBtn;

@end

@implementation DY_TaskListCell

+ (CGFloat)cellHeight {
    return 60.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initSubview];
    }
    return self;
}

- (void)_initSubview
{
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.clipsToBounds = YES;
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    [leftImageView dy_configure];
    [self.contentView addSubview:leftImageView];
    _leftImageView = leftImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel dy_configure];
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIButton *scoresBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [scoresBtn dy_configure];
    [scoresBtn setTitleColor:kUIColorFromRGB(0x2aa515) forState:0];
    scoresBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    scoresBtn.backgroundColor = [UIColor clearColor];
    scoresBtn.clipsToBounds = YES;
    [scoresBtn.layer setBorderColor:CC_CustomColor_BAB2AF.CGColor];
    [scoresBtn.layer setBorderWidth:0.5];
    [scoresBtn.layer setCornerRadius:4];
    [scoresBtn setImage:[UIImage imageNamed:@"icon_scores_small"] forState:0];
    [self.contentView addSubview:scoresBtn];
    _scoresBtn = scoresBtn;
    
    UILabel *statusLabel = [[UILabel alloc] init];
    [statusLabel dy_configure];
    statusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:statusLabel];
    _statusLabel = statusLabel;

    
    [self _setLayoutSubviews];
    
}

- (void)_setLayoutSubviews {
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo([DY_TaskListCell cellHeight]-30);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftImageView);
        make.left.equalTo(_leftImageView.mas_right).offset(8);
        make.bottom.equalTo(_leftImageView);
    }];
    
    [_scoresBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftImageView);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(25);
    }];
    
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.right.equalTo(_scoresBtn.mas_left).offset(-8);
        make.bottom.mas_equalTo(-12);
    }];


}

- (void)dy_setTest {
    self.leftImageView.image = [UIImage imageNamed:@"icon_scores_small"];
    self.titleLabel.text = @"签到";
    [self.scoresBtn setTitle:@"+10" forState:0];
    self.statusLabel.text = @"0/1";
    
    
}

-(void)setTasksModel:(DY_TasksModel *)tasksModel {
    _tasksModel = tasksModel;
    
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:tasksModel.taskImg] placeholderImage:CC_PlaceholderImage];;
    self.titleLabel.text = tasksModel.taskName;
    [self.scoresBtn setTitle:tasksModel.taskScores forState:0];
    
    NSDate *date1 = [NSDate date];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"YYYY.MM.dd"];
    NSString *DateTime1 = [formatter1 stringFromDate:date1];
    
    NSString *maxNumber = [NSString isEmptyString:_tasksModel.finishMaxNumber]?@"0":_tasksModel.finishMaxNumber;
    if (![DateTime1 isEqualToString:_tasksModel.userTasksModel.userMark]) {
        
        self.statusLabel.text = [NSString stringWithFormat:@"0/%@",maxNumber];
    } else {
        self.statusLabel.text = [NSString stringWithFormat:@"%@/%@",_tasksModel.userTasksModel.finishTimes,maxNumber];
    }

    
}



@end
