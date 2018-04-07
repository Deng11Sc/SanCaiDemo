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
///初始化AVOSCloud服务
-(void)_initOSCloudServers;

-(void)getAVOSCloudTypeController;

@end
