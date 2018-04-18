//
//  DYHeader.h
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#ifndef DYHeader_h
#define DYHeader_h

#define DY_Height CGRectGetHeight([[UIScreen mainScreen] bounds])
#define DY_Width CGRectGetWidth([[UIScreen mainScreen] bounds])
#define DY_SCREEN_MIN MIN(DY_Height,DY_Width)
#define DY_SCREEN_MAX MAX(DY_Height,DY_Width)


/** 定义版本判定 */
#define iOS7_Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8_Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1_Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10_Later ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define iOS11_Later ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)


/*
 *  适配坐标 ， 以（375， 667）为基准
 */
#define selfWidthRate ([UIScreen mainScreen].bounds.size.width / 375.0)
#define selfHeightRate ([UIScreen mainScreen].bounds.size.height / 667.0)
#define DYRate(rect) CGRectMake(rect.origin.x *selfWidthRate, rect.origin.y *selfHeightRate, rect.size.width *selfWidthRate, rect.size.height *selfHeightRate)
#define DYRate_X(x) selfWidthRate *x
#define DYRate_Y(y) selfHeightRate *y
#define DYRate_Width(w) selfWidthRate *w
#define DYRate_height(h) selfHeightRate *h


///颜色，不透明
#define kUIColorFromRGB(rgbValue)                                                                                                                                                  \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

///颜色，加透明度
#define kUIColorFromRGB_Alpa(rgbValue, alpa)                                                                                                                                       \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:alpa]




//当前版本号
#define kCurrentSystemVersion [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

/** 用户设备的id */
#define nn_udid [[[[UIDevice currentDevice] identifierForVendor] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""]


#define NNCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]


#endif /* DYHeader_h */
