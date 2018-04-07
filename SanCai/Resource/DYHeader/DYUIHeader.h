//
//  DYUIHeader.h
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#ifndef DYUIHeader_h
#define DYUIHeader_h

#define DY_KeyWindow [[[UIApplication sharedApplication] delegate] window]

#define kDevice_iPhoneX CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)
#define NavHeight (kDevice_iPhoneX?84:64)

#define mainColor kUIColorFromRGB(0x525252)

#define DY_CustomColor_F5F4F3 kUIColorFromRGB(0xF5F4F3) ///背景色

#define DY_CustomColor_3A3534 kUIColorFromRGB(0x3A3534)
#define DY_CustomColor_595350 kUIColorFromRGB(0x595350)
#define DY_CustomColor_FA5252 kUIColorFromRGB(0xFA5252)
#define DY_CustomColor_BAB2AF kUIColorFromRGB(0xBAB2AF)


///按钮主色调
#define DY_CustomColor_2594D2 kUIColorFromRGB(0x2594D2)



///头像
#define DY_Default_Avatar [UIImage imageNamed:@"default_avatar_round"]


#define DY_PlaceholderImage [UIImage imageNamed:@"default_avatar_round"]


#endif /* DYUIHeader_h */
