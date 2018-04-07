//
//  UIViewController+AVOSCloud.m
//  MerryS
//
//  Created by ds on 18/3/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "UIViewController+AVOSCloud.h"
#import "DYTabbarController.h"
#import "VestMainController.h"
#import "DYNavigationController.h"
#import "AppDelegate.h"

#import "NSString+Common.h"


@implementation UIViewController(AVOSCloud)

/*
 // 获取三个特殊属性
 NSString *objectId = object.objectId;
 NSDate *updatedAt = object.updatedAt;
 NSDate *createdAt = object.createdAt;
 */
-(void)getAVOSCloudTypeController
{
    
    BOOL isShow = [NSString isShowMJBContent];
    if (isShow) {
        @weakify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:DY_KeyWindow animated:YES];
        hud.label.text = DYLocalizedString(@"Querying mode", @"正在查询模式");
        
        AVQuery *query = [AVQuery queryWithClassName:@"MainData"];
        [query getObjectInBackgroundWithId:AVOSCloudId block:^(AVObject *object, NSError *error) {
            
            @strongify(self)
            
            NSInteger dataType = [[object objectForKey:@"DYDataType"] integerValue];
            NSString *urlStr = [object objectForKey:@"urlStr"];
            NSLog(@"DYDataType - %ld",dataType);
            
            [MBProgressHUD hideHUDForView:DY_KeyWindow animated:YES];
            if (dataType == 2) {
                VestMainController *vestCtrl = [[VestMainController alloc] init];
                vestCtrl.urlStr = urlStr;
                //            DYNavigationController *vestNav = [[DYNavigationController alloc] initWithRootViewController:vestCtrl];
                [self restoreRootViewController:vestCtrl];
                
            } else {
                
                //            DYTabbarController *tabbarCtrl = [[DYTabbarController alloc] init];
                //            [self restoreRootViewController:tabbarCtrl];
            }
                        
        }];

    } else {
        
    }
    
}

- (void)restoreRootViewController:(UIViewController *)rootViewController
{
    typedef void (^Animation)(void);
    
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    
    rootViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

@end
