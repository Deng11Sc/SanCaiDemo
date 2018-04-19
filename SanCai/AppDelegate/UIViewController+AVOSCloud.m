//
//  UIViewController+AVOSCloud.m
//  MerryS
//
//  Created by ds on 18/3/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "UIViewController+AVOSCloud.h"
#import "DY_TabbarController.h"
#import "DY_VestMainController.h"
#import "DY_NavigationController.h"
#import "AppDelegate.h"

#import "NSString+Common.h"


@implementation UIViewController(AVOSCloud)

/*
 // 获取三个特殊属性
 NSString *objectId = object.objectId;
 NSDate *updatedAt = object.updatedAt;
 NSDate *createdAt = object.createdAt;
 */
+(void)getAVOSCloudTypeController
{
    
    BOOL isShow = [NSString isShowMJBContent];
    if (isShow) {
        @weakify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:CC_KeyWindow animated:YES];
        hud.label.text = DYLocalizedString(@"Querying mode", @"正在查询模式");
        hud.hidden = NO;
        
        AVQuery *query = [AVQuery queryWithClassName:@"MainData"];
        [query getObjectInBackgroundWithId:AVOSCloudId block:^(AVObject *object, NSError *error) {
            
            @strongify(self)
            
            NSInteger dataType = [[object objectForKey:@"DYDataType"] integerValue];
            NSString *urlStr = [object objectForKey:@"urlStr"];
            NSLog(@"DYDataType - %ld",dataType);
            
            hud.hidden = YES;
            [MBProgressHUD hideHUDForView:CC_KeyWindow animated:YES];
            [MBProgressHUD hideHUDForView:CC_KeyWindow animated:YES];
            if (dataType == 2) {
                DY_VestMainController *vestCtrl = [[DY_VestMainController alloc] init];
                vestCtrl.urlStr = urlStr;
                //            DY_NavigationController *vestNav = [[DY_NavigationController alloc] initWithRootViewController:vestCtrl];
                [self restoreRootViewController:vestCtrl];
                
            } else {
                
                //            DY_TabbarController *tabbarCtrl = [[DY_TabbarController alloc] init];
                //            [self restoreRootViewController:tabbarCtrl];
            }
                        
        }];

    } else {
        
    }
    
}

+ (void)restoreRootViewController:(UIViewController *)rootViewController
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


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
