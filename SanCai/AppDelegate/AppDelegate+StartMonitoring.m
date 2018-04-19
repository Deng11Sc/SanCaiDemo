//
//  AppDelegate+StartMonitoring.m
//  SanCai
//
//  Created by SongChang on 2018/4/19.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "AppDelegate+StartMonitoring.h"
#import <AFNetworking.h>

#import "DY_EmptyController.h"
#import "DY_TabbarController.h"

@implementation AppDelegate(StartMonitoring)

//网络监听
-(void)startToListenNow
{
    DY_TabbarController *tabbarCtrl = [[DY_TabbarController alloc] init];
    self.window.rootViewController = tabbarCtrl;
    [self.window makeKeyAndVisible];

    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                
                if (![self.window.rootViewController isKindOfClass:[DY_TabbarController class]]) {
                    DY_TabbarController *tabbarCtrl = [[DY_TabbarController alloc] init];
                    self.window.rootViewController = tabbarCtrl;
                    [self.window makeKeyAndVisible];
                }
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable://无网络
            {
                DY_EmptyController *emptyVC = [[DY_EmptyController alloc] init];
                self.window.rootViewController = emptyVC;
                [self.window makeKeyWindow];
            }
                break;
            default:
                break;
        }
    }];
    //开始监听
    [manager startMonitoring];
}


@end
