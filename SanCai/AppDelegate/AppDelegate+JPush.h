//
//  AppDelegate+JPush.h
//  MerryS
//
//  Created by SongChang on 2018/2/1.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate(JPush)

///初始化
-(void)JPush_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions ;

///注册deviceToken
-(void)JPush_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

@end
