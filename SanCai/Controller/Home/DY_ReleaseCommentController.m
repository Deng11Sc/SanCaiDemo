//
//  DYReleaseCommentController.m
//  SanCai
//
//  Created by SongChang on 2018/4/9.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_ReleaseCommentController.h"
#import "DY_ReleaseCommentView.h"

///构造影评model
#import "DY_FilmReviewModel.h"
#import "DY_TaskManager.h"


@interface DY_ReleaseCommentController ()

@end

@implementation DY_ReleaseCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = DYLocalizedString(@"Comment", @"发表评论");
    
    DY_ReleaseCommentView *releaseView = [[DY_ReleaseCommentView alloc] init];
    releaseView.movieModel = self.movieModel;
    
    @weakify(self)
    releaseView.releaseCommentBlk = ^(DY_FilmReviewModel *filmModel) {
        
        @strongify(self)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DY_LeanCloudNet saveObject:filmModel objectId:nil className:URL_HotListModel numberArr:nil relationId:nil success:^(NSMutableArray *array, AVObject *object) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"success");
            
            [[DY_TaskManager manager] increaseScoresByTaskType:self.movieModel.taskType success:nil];
            [NSObject showMessage:DYLocalizedString(@"Review successful", @"评论成功")];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(DYLeanCloudError error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];

    };
    [self.view addSubview:releaseView];
    
    [releaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo([DY_ReleaseCommentView height]);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
