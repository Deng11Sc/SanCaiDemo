//
//  DYOcrMainController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYOcrMainController.h"

#import "UIViewController+AVOSCloud.h"

@interface DYOcrMainController ()

@end

@implementation DYOcrMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [DYLeanCloudNet _initOSCloudServers];
    
    //获取APP当前语言
    NSArray *languageArr = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *curLanguage = languageArr.firstObject;
    if ([curLanguage isEqualToString:@"zh-Hans-CN"]) {

        [self getAVOSCloudTypeController];

    } else {

    }
    
}



@end

