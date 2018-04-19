#import "DY_ArticleDetailController.h"
#import "DY_ArticleTextCell.h"
#import "DY_DetaillTextModel.h"
#import "DY_ArticleImageCell.h"


#import "DY_ScoresModel.h"
#import "NSString+ScoresManager.h"

#import "UIBarButtonItem+Custom.h"
#import "DY_ReleaseCommentController.h"

#import "DY_LoginInfoManager.h"

@interface DY_ArticleDetailController ()
@property (nonatomic,strong)NSMutableArray <DY_DetaillTextModel *>*textArr;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIView *footerView;


@property (nonatomic,strong)DY_ScoresModel *myScoresModel;
@property (nonatomic,strong)DY_ScoresModel *commentatorModel;


@end
@implementation DY_ArticleDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}


-(void)loadData {
    @weakify(self)
    
    if (self.filmModel) {
        [self.filmModel.movieDesc getNewContentWithBlock:^(NSMutableArray *textArr) {
            @strongify(self)
            NSMutableArray *newTextArr = [NSMutableArray new];
            for (NSString *text in textArr) {
                DY_DetaillTextModel *model = [[DY_DetaillTextModel alloc] init];
                model.text = text;
                [newTextArr addObject:model];
            }
            self.textArr = newTextArr;
            [self dy_initTableView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.tableHeaderView = self.headerView;
            self.tableView.tableFooterView = self.footerView;
        }];
    }
    
    if (self.movieModel) {
        [self.movieModel.movieDesc getNewContentWithBlock:^(NSMutableArray *textArr) {
            @strongify(self)
            NSMutableArray *newTextArr = [NSMutableArray new];
            for (NSString *text in textArr) {
                DY_DetaillTextModel *model = [[DY_DetaillTextModel alloc] init];
                model.text = text;
                [newTextArr addObject:model];
            }
            self.textArr = newTextArr;
            [self dy_initTableView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.tableHeaderView = self.headerView;
        }];
        
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem customBarButtonItemWithImageName:@"icon_release" action:@selector(rightAction) vc:self];
    }
}


-(void)rightAction {
    DY_ReleaseCommentController *vc = [[DY_ReleaseCommentController alloc] init];
    vc.movieModel = self.movieModel;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = (self.textArr[indexPath.row]).text;
    if (!self.textArr[indexPath.row].isImage) {
        static NSString *cellID = @"articleDetailTextCellId";
        DY_ArticleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[DY_ArticleTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        cell.dy_textLabel.text = text;
        return cell;
    } else {
        static NSString *cellID = @"articleDetailImageCellId";
        DY_ArticleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[DY_ArticleImageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
        NSString *imgUrl = self.textArr[indexPath.row].imageUrl;
        __weak DY_ArticleImageCell *weakCell = cell;
        @weakify(self)
        [cell.dy_imageView sd_setImageWithURL:[NSURL URLWithString:[imgUrl getImageCompleteUrl]]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            @strongify(self)
            DY_DetaillTextModel *textModel = self.textArr[indexPath.row];
            
            if (!textModel.imageHeight) {
                textModel.imageHeight = [weakCell resetImageHeight];
                [self.tableView reloadData];
            }
        } ];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.textArr[indexPath.row].isImage) {
        return self.textArr[indexPath.row].height;
    } else {
        DY_DetaillTextModel *textModel = self.textArr[indexPath.row];
        if (!textModel.imageHeight) {
            return self.textArr[indexPath.row].height;
        } else {
            return self.textArr[indexPath.row].imageHeight;
        }
    }
}
-(UIView *)headerView {
    if (!_headerView) {
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, DY_Width, 23+50+8);
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.frame = CGRectMake(16, 8, DY_Width-32, 50);
        titleLabel.textColor = mainColor;
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.numberOfLines = 2;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [headerView addSubview:titleLabel];
        
        UILabel *authorLabel = [[UILabel alloc] init];
        authorLabel.frame = CGRectMake(16, 8+titleLabel.bottom, DY_Width-32, 15);
        authorLabel.textColor = DY_CustomColor_595350;
        authorLabel.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:authorLabel];
        _headerView = headerView;
        
        
        if (_filmModel) {
            titleLabel.text = _filmModel.title;
            authorLabel.text = [NSString stringWithFormat:@"%@%@",DYLocalizedString(@"Author/", @"文/"),_filmModel.commentator];
        }
        
        if (_movieModel) {
            UIImageView *rightImgView = [[UIImageView alloc] init];
            [rightImgView dy_configure];
            rightImgView.clipsToBounds = YES;
            [rightImgView.layer setCornerRadius:headerView.height/2];
            rightImgView.contentMode = UIViewContentModeScaleAspectFill;
            
            [_headerView addSubview:rightImgView];
            
            [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@4);
                make.right.equalTo(@(-4));
                make.width.height.equalTo(headerView.mas_height);
            }];
            
            titleLabel.text = _movieModel.movieName;
            authorLabel.text = [NSString stringWithFormat:@"%@%@",DYLocalizedString(@"Author/", @"文/"),_movieModel.authorName];
            [rightImgView sd_setImageWithURL:[NSURL URLWithString:_movieModel.movieImg] placeholderImage:DY_PlaceholderImage];
        }
        
    }
    return _headerView;
}

-(UIView *)footerView {
    if (!_footerView) {
        UIView *headerView = [[UIView alloc] init];
        headerView.frame = CGRectMake(0, 0, DY_Width, 44);
        headerView.backgroundColor = [UIColor whiteColor];

        UIButton *receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [receiveBtn dy_configure];
        receiveBtn.frame = CGRectMake(DY_Width/2-110/2, 4.5, 110, 35);
        [receiveBtn setTitle:DYLocalizedString(@"Reward", nil) forState:0];
        [receiveBtn addTarget:self action:@selector(dy_rewardAction) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:receiveBtn];
        
        _footerView = headerView;
    }
    return _footerView;
}

-(void)dy_rewardAction {
    
    if ([DY_LoginInfoManager manager].isLogin == NO) {
        [NSObject showMessage:DYLocalizedString(@"Please log in first", "请先登录")];
        [[DY_LoginInfoManager manager] prensentLoginController];

        return;
    }
    
    @weakify(self)
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NSString server_getScoresModelWithUserId:SELF_USER_ID blk:^(DY_ScoresModel *scoresModel) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!scoresModel) {
            [NSObject showMessage:@"Failed"];
        } else {
            
            self.myScoresModel = scoresModel;
            
            if ([scoresModel.scores integerValue] < 10) {
                
                [NSObject showMessage:DYLocalizedString(@"Your scores are not enough to reward", @"")];
                
            } else {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:DYLocalizedString(@"Whether to delete this address?", @"是否删除该地址?") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                if ([self.myScoresModel.scores integerValue] >=10) {
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"10 %@",DYLocalizedString(@"Scores", @"积分")]
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                                        @strongify(self)
                                                                        [self dy_rewardScores:10];
                                                                    }];
                    [alert addAction:action1];
                }
                
                if ([self.myScoresModel.scores integerValue] >=20) {
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"20 %@",DYLocalizedString(@"Scores", @"积分")]
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                                        @strongify(self)
                                                                        [self dy_rewardScores:20];
                                                                    }];
                    [alert addAction:action2];
                }
                
                
                if ([self.myScoresModel.scores integerValue] >=50) {
                    UIAlertAction *action3 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"50 %@",DYLocalizedString(@"Scores", @"积分")]
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                                        @strongify(self)
                                                                        [self dy_rewardScores:50];
                                                                    }];
                    [alert addAction:action3];
                }
                
                if ([self.myScoresModel.scores integerValue] >=100) {
                    UIAlertAction *action4 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"100 %@",DYLocalizedString(@"Scores", @"积分")]
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *_Nonnull action) {
                                                                        @strongify(self)
                                                                        [self dy_rewardScores:100];
                                                                    }];
                    [alert addAction:action4];
                }
                
                
                UIAlertAction *action0 = [UIAlertAction actionWithTitle:DYLocalizedString(@"Cancel", @"取消")
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction *_Nonnull action) {
                                                                    
                                                                }];
                [alert addAction:action0];
                
                [self presentViewController:alert animated:YES completion:nil];

                
            }
        }
    }];
    
}

-(void)dy_rewardScores:(NSInteger)reward {
    
    [NSString server_saveScoresWithUserId:self.myScoresModel.userId objId:self.myScoresModel.objId changedNumber:-reward];
    
    [self commentatorIncrementScores:reward];
    [self dy_increaseThisArticleScores:reward];

}

-(void)commentatorIncrementScores:(NSInteger)scores
{
    
    AVQuery *query = [AVQuery queryWithClassName:URL_ScoresModel];
    [query whereKey:@"userId" equalTo:self.filmModel.authorId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            
            AVObject *lastObject = [objects firstObject];
            
            [NSString server_saveScoresWithUserId:self.filmModel.authorId objId:lastObject.objectId changedNumber:scores];

            
        } else {
            
            if (![NSString isEmptyString:self.filmModel.authorId]) {
                [NSString server_initScoresDataWithUserId:self.filmModel.authorId endblk:^(BOOL isSeccess) {
                    
                }];
            }
        }
    }];

}

//提升文章积分
-(void)dy_increaseThisArticleScores:(NSInteger)scores
{
    ///提升文章的积分
    AVObject *tatorObje = [AVObject objectWithClassName:URL_HotListModel objectId:self.filmModel.objId];
    [tatorObje incrementKey:@"scores" byAmount:@(scores)];
    
    AVQuery *tatorQuery = [[AVQuery alloc] init];
    [tatorQuery whereKey:@"objectId" equalTo:self.filmModel.objId];

    AVSaveOption *tatorOption = [[AVSaveOption alloc] init];
    tatorOption.query = tatorQuery;
    tatorOption.fetchWhenSave = NO;
    [tatorObje saveInBackgroundWithOption:tatorOption block:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"提升文章积分成功");
            [NSObject showMessage:[NSString stringWithFormat:DYLocalizedString(@"This article earned %ld scores", nil),scores]];
        } else if (error.code == 305) {
        }
    }];

}


- (void)setIsLandscape:(BOOL)isLandscape {
    
    [super setIsLandscape:isLandscape];
    
    [self loadData];
    
    
}


@end
