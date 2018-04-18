//
//  UIViewController+AVOSCloud.h
//  MerryS
//
//  Created by ds on 18/3/22.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>

@interface UIViewController(AVOSCloud)


+(void)getAVOSCloudTypeController;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;


@end
