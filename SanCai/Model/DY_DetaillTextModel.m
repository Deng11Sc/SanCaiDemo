//
//  DY_DetaillTextModel.m
//  MerryS
//
//  Created by SongChang on 2018/1/25.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_DetaillTextModel.h"

@implementation DY_DetaillTextModel

- (void)setText:(NSString *)text
{
    _text = text;
    
    if (![self isImage:text]) {
        self.height = [self textHeightStr:text font:[UIFont systemFontOfSize:16] labelWidth:DY_Width-32] + 16;
        self.isImage = NO;
    } else {
        self.isImage = YES;
        self.imageUrl = [text filterImage].firstObject;
        if ([NSString isEmptyString:self.imageUrl]) {
            self.height = 0.f;
        } else {
            self.height = (DY_Width-32)*0.618;
        }
    }
}


- (CGFloat )textHeightStr:(NSString *)str font:(UIFont *)font labelWidth:(CGFloat)width{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
//    paraStyle.lineSpacing = 4;
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return sizeText.height;
}

-(BOOL)isImage:(NSString *)str {
    if ((([str hasPrefix:@"<img src="] && [str hasSuffix:@">"]) ||
         ([str hasPrefix:@"[img]"] && [str hasSuffix:@"[/img]"]) ||
         ([str hasPrefix:@"<img>"] && [str hasSuffix:@"</img>"]) )) {
        return YES;
    }
    return NO;
}


@end
