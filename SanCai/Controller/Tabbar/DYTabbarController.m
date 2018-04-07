//
//  DYTabbarController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYTabbarController.h"
#import "DYOcrMainController.h"
#import "DYCenterController.h"
#import "DYForumController.h"

#import "DYNavigationController.h"
#import "UIImage+Common.h"

@interface DYTabbarController ()

@property (nonatomic,strong)DYOcrMainController *mainVC;

@property (nonatomic,strong)DYCenterController *centerVC;

@property (nonatomic,strong)DYForumController *forumVC;

@end

@implementation DYTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DYOcrMainController *mainVC = [[DYOcrMainController alloc] init];
    DYNavigationController *mainNav = [[DYNavigationController alloc] initWithRootViewController:mainVC];
    mainVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_find"];
    mainVC.tabBarItem.title = DYLocalizedString(@"Find", @"发现");
    _mainVC = mainVC;
    
    DYForumController *forumVC = [[DYForumController alloc] init];
    DYNavigationController *forumNav = [[DYNavigationController alloc] initWithRootViewController:forumVC];
    forumVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_forum"];
    forumVC.tabBarItem.title = DYLocalizedString(@"Forum", @"论坛");
    _forumVC = forumVC;

    DYCenterController *centerVC = [[DYCenterController alloc] init];
    DYNavigationController *centerNav = [[DYNavigationController alloc] initWithRootViewController:centerVC];
    centerVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_center"];
    centerVC.tabBarItem.title = DYLocalizedString(@"Center", @"个人中心");
    _centerVC = centerVC;
    
    [self addChildViewController:mainNav];
    [self addChildViewController:forumNav];
    [self addChildViewController:centerNav];

    self.tabBarController.selectedIndex = 0;
    
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
