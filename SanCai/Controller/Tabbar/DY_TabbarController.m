//
//  DY_TabbarController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_TabbarController.h"
#import "DY_OcrMainController.h"
#import "DY_CenterController.h"
#import "DY_ForumController.h"

#import "DY_NavigationController.h"
#import "UIImage+Common.h"

@interface DY_TabbarController ()

@property (nonatomic,strong)DY_OcrMainController *mainVC;

@property (nonatomic,strong)DY_CenterController *centerVC;

@property (nonatomic,strong)DY_ForumController *forumVC;

@end

@implementation DY_TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DY_OcrMainController *mainVC = [[DY_OcrMainController alloc] init];
    DY_NavigationController *mainNav = [[DY_NavigationController alloc] initWithRootViewController:mainVC];
    mainVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_hot"];
    mainVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_hot_highlight"];
    mainVC.tabBarItem.title = DYLocalizedString(@"Hot", @"热门");
    _mainVC = mainVC;
    
    DY_ForumController *forumVC = [[DY_ForumController alloc] init];
    DY_NavigationController *forumNav = [[DY_NavigationController alloc] initWithRootViewController:forumVC];
    forumVC.tabBarItem.image = [UIImage imageNamed:@"tabbar_movie"];
    forumVC.tabBarItem.title = DYLocalizedString(@"Movie", @"电影");
    _forumVC = forumVC;

    DY_CenterController *centerVC = [[DY_CenterController alloc] init];
    DY_NavigationController *centerNav = [[DY_NavigationController alloc] initWithRootViewController:centerVC];
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
