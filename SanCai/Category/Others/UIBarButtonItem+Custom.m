//
//  UIBarButtonItem+Custom.m
//  SanCai
//
//  Created by SongChang on 2018/4/16.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem(Custom)

+(UIButton *)customButtomWithImageName:(NSString *)imageName action:(SEL)action vc:(id)vc
{
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setImage:[UIImage imageNamed:imageName] forState:0];
    customBtn.frame = CGRectMake(0, 0, 20, 20);
    [customBtn addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
    
    return customBtn;
    
}

+(UIBarButtonItem *)customBarButtonItemWithImageName:(NSString *)imageName action:(SEL)action vc:(id)vc
{
    return [[UIBarButtonItem alloc] initWithCustomView:[self customButtomWithImageName:imageName action:action vc:vc]];
}


@end
