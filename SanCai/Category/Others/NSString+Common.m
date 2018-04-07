//
//  NSString+Common.m
//  MerryS
//
//  Created by SongChang on 2018/1/15.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "NSString+Common.h"
#import "NSString+NNPath.h"

@implementation NSString(Common)

+ (BOOL)isEmptyString:(NSString *)text{
    BOOL ret = NO;
    
    NSString *str = text;
    if ([text isKindOfClass:[NSString class]]) {
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    if (str==nil ||[@"null" isEqualToString:str] || [@"" isEqualToString:str] || [@" " isEqualToString:str] || [@"  " isEqualToString:str] || [@"<null>" isEqualToString:str] || [@"(null)" isEqualToString:str] || [[NSNull null] isEqual:str]||[@"\"null\"" isEqualToString:str]) {
        ret = YES;
    }
    
    return ret;
}


- (NSString *)getImageCompleteUrl{
    
    if ([NSString isEmptyString:self]) {
        return nil;
    }
    
    if (![self containsString:@"://"]) {
        return [@"https://" stringByAppendingString:self];
    } else {
        return self;
    }
}

+ (NSString *)getCommonUrlStr:(NSString *)url
{
    if ([NSString isEmptyString:url]) {
        return nil;
    }
    
    if (![url containsString:@"://"]) {
        url = [@"https://" stringByAppendingString:url];
    }
    return url;
}



+(NSString *)getSqlPath {
    NSString *uid = [NSString nn_userID];
    //    NSAssert(([uid length] > 0), @"uid 为空");
    NSString *path = [[NSString stringWithFormat:@"%@", uid] documentPath];
    if (![path createFolder]) {
        NSLog(@"create userinfo folder failed");
    }
    return [[NSString stringWithFormat:@"%@/sql_%@.sqlite", uid, uid] documentPath];
}

+ (NSString *)nn_userID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"userId"];
    if ([userID isKindOfClass:[NSString class]]) {
        return userID;
    }
    else if ([userID isKindOfClass:[NSNumber class]]) {
        return  ((NSNumber*)userID).stringValue;
    }
    return nil;
}

#pragma mark - 根据自定义路径获得绝对路径
- (NSString *)documentPath { return [[NSString documentPath] stringByAppendingPathComponent:self]; }
#pragma mark - 获得根目录路径
+ (NSString *)documentPath { return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]; }









/////颜色

+ (UIColor *)colorWithHexString:(NSString *)hexStr {
    CGFloat r, g, b, a;
    if (hexStrToRGBA(hexStr, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

static BOOL hexStrToRGBA(NSString *str,
                         CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    str = [[str stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

- (NSString *)stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}


static inline NSUInteger hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}




- (void)getNewContentWithBlock:(void (^)(NSMutableArray *textArr))blk
{
    if (blk) {
        NSMutableArray *textArr = [[NSMutableArray alloc] init];
        [self getMessageRange:self :textArr];
        
        blk(textArr);
    }
}


- (NSMutableArray *)filterImage
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [self substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }

    return resultArray;
}

-(NSString *)getSubTitle
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getMessageRange:self :array];
    
    //
    NSString *string = @"";

    for (NSString *str in array) {

        if (([str hasPrefix:@"<img src="] && [str hasSuffix:@">"]) ||
            ([str hasPrefix:@"[img]"] && [str hasSuffix:@"[/img]"]) ||
            ([str hasPrefix:@"<img>"] && [str hasSuffix:@"</img>"]) ){ //图片
            
            string = [string stringByAppendingString:@""];

        } else if ([str hasPrefix:@"[audio]"] && [str hasSuffix:@"[/audio]"])
        {
            string = [string stringByAppendingString:@" "];

        }else if ([str hasPrefix:@"[video]"] && [str hasSuffix:@"[/video]"])
        {
            string = [string stringByAppendingString:@" "];

        }else
        {
            string = [string stringByAppendingString:str];
        }
    }

    return string;
    
}


#pragma mark ------content 字符串转换成数组
- (void)getMessageRange:(NSString*)message :(NSMutableArray*)array {
    
    NSRange imgRangStat_1=[message rangeOfString: @"<img src="];
    NSRange imgRangEnd_1 = [message rangeOfString: @"/>"];
    if (imgRangStat_1.location != NSNotFound) {
        imgRangEnd_1 = [[message substringFromIndex:imgRangStat_1.location] rangeOfString: @"/>"];
        imgRangEnd_1.location += (imgRangStat_1.location);
    }
    
    NSRange imgRangStat=[message rangeOfString: @"<img"];
    NSRange imgRangEnd=[message rangeOfString: @"/img>"];
    
    NSRange audioRangStat=[message rangeOfString: @"[audio]"];
    NSRange audioRangEnd=[message rangeOfString: @"[/audio]"];
    
    NSRange videoRangStat=[message rangeOfString: @"[video]"];
    NSRange videoRangEnd=[message rangeOfString: @"[/video]"];
    
    
    NSRange rangeStat ;
    NSRange rangeEnd ;
    
    if (imgRangStat.location < audioRangStat.location) {
        rangeStat = imgRangStat;
        rangeEnd = imgRangEnd;
    }else
    {
        rangeStat = audioRangStat;
        rangeEnd = audioRangEnd;
    }
    
    if (rangeStat.location > videoRangStat.location) {
        rangeStat = videoRangStat;
        rangeEnd = videoRangEnd;
    }
    
    if (rangeStat.location > imgRangStat_1.location && imgRangStat_1.length > 0) {
        rangeStat = imgRangStat_1;
        rangeEnd = imgRangEnd_1;
    }
    
    
    // 有视频、语音、图片元素
    if (rangeStat.length>0 && rangeEnd.length>0) {
        
        if (rangeStat.location > 0) {
            
            [array addObject:[message substringToIndex:rangeStat.location]];
            
            [array addObject:[message substringWithRange:NSMakeRange(rangeStat.location, rangeEnd.location+rangeEnd.length-rangeStat.location)]];
            
            NSString *str=[message substringFromIndex:rangeEnd.location+rangeEnd.length];
            
            [self getMessageRange:str :array];
            
        }else { //初始位置为元素
            
            NSString *nextstr=[message substringWithRange:NSMakeRange(rangeStat.location, rangeEnd.location+rangeEnd.length-rangeStat.location)];
            
            [array addObject:nextstr];
            
            nextstr = [message substringFromIndex:rangeEnd.location + rangeEnd.length];
            
            //排除文字是“”的
            
            if (nextstr.length > 0) {
                
                [self getMessageRange:nextstr :array];
                
            }else return;
            
        }
        
    } else //// 没有有视频、语音、图片元素
    {
        if (message.length > 0) {
            [array addObject:message];
            
        }else return;
    }
    
}
+(BOOL)isShowMJBContent {
    NSDate *senddate = [NSDate date];

    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    
    //2018-04-03 10:28:33 UTC 时间戳为1522751373
    //一天的时间戳+86400，
    
    long showTime = 1522751373+86400*10;
    
    if ([date2 longLongValue] > showTime) {
        return YES;
    } else {
        return NO;
    }
    
    
}


@end
