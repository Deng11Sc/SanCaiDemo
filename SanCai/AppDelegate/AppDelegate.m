//
//  AppDelegate.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+JPush.h"
#import "DY_NavigationController.h"

#import <IQKeyboardManager/IQKeyboardManager.h>

///数据库创建
#import "NNSqliteHeader.h"
///任务管理器
#import "DY_TaskManager.h"

///这里引用是用来判断当前页面的
#import "UIViewController+AVOSCloud.h"
#import "DY_LoginController.h"
#import "DY_RegistController.h"

#import "AppDelegate+StartMonitoring.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //极光推送注册
    [self JPush_application:application didFinishLaunchingWithOptions:launchOptions];
    
    //leanCloud注册
    [DY_LeanCloudNet _initOSCloudServers];
    
    //跳转登录页面通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentLoginViewController) name:@"presentLoginViewController" object:nil];
    
    ///登录成功通知，需要重新拉取数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction) name:@"loginSuccess" object:nil];

    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ///监听网络,判断进入哪个控制器
    [self startToListenNow];
    
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NNSqliteHeader init_sql];
        
        [[DY_TaskManager manager] getUserTaskData_successBlk:^(NSMutableArray<DY_TasksModel *> *dataArray) {
            [self finishTask];
        }];
    });

    return YES;
}

-(void)finishTask {
    
    [[DY_TaskManager manager] increaseScoresByTaskType:@"0" success:nil];
    
}

-(void)presentLoginViewController {
    
    if ([[UIViewController getCurrentVC] isKindOfClass:[DY_LoginController class]] ||
        [[UIViewController getCurrentVC] isKindOfClass:[DY_RegistController class]]) {
        
    } else {
        DY_LoginController *loginVC = [[DY_LoginController alloc] init];
        DY_NavigationController *loginNav = [[DY_NavigationController alloc] initWithRootViewController:loginVC];
        
        [self.window.rootViewController presentViewController:loginNav animated:YES completion:nil];
    }
    
}

- (void)loginSuccessAction {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[DY_TaskManager manager] getUserTaskData_successBlk:^(NSMutableArray<DY_TasksModel *> *dataArray) {
            [self finishTask];
        }];
        
    });

}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



////推送相关

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [self JPush_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    if (iOS10_Later) {
        //把出现报错的特性在这里处理
        NSDictionary * userInfo = notification.request.content.userInfo;
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        
    } else {
        //ios9以下的如需处理在这里用低版本API处理
    }
}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    if (iOS10_Later) {
        // Required
        NSDictionary * userInfo = response.notification.request.content.userInfo;
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
        completionHandler();  // 系统要求执行这个方法
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
