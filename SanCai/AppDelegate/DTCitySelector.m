//
//  DTCitySelector.m
//  SanCai
//
//  Created by SongChang on 2018/4/10.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DTCitySelector.h"

@implementation DTCitySelector

+(UIImage *)getCityIconImgStr:(NSString *)oldImgStr
{
    NSString *newImgStr = [NSString stringWithFormat:@"%@%@",oldImgStr,[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"]];
    
    return [self getCityIconImgStr:oldImgStr newImagStr:newImgStr];
}

+ (UIImage *)getCityIconImgStr:(NSString *)oldImgStr newImagStr:(NSString *)newImagStr
{
    NSInteger cityId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"cityId"] integerValue];
    
    switch (cityId) {
        case 0:
        {
            return [UIImage imageNamed:oldImgStr];
        }
            break;
        default:
        {
            return [UIImage imageNamed:newImagStr];
        }
            break;
    }
}

+(void)saveCityId:(NSInteger)cityId
{
    [[NSUserDefaults standardUserDefaults] setObject:@(cityId) forKey:@"cityId"];
}

@end
