//
//  DTCitySelector.h
//  SanCai
//
//  Created by SongChang on 2018/4/10.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DTCitySelector : NSObject

///app初始化的时候调用
+(void)saveCityId:(NSInteger)cityId;

///把需要改的图片名传过来-oldImgStr，新的图片命名为 [oldImgStr]+[cityId]
+(UIImage *)getCityIconImgStr:(NSString *)oldImgStr;

///
+(UIImage *)getCityIconImgStr:(NSString *)oldImgStr newImagStr:(NSString *)newImagStr;

@end
