//
//  ForumList.m
//  MerryS
//
//  Created by SongChang on 2018/1/23.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "ForumList.h"

@implementation ForumList

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super initWithDictionary:dict];
    if (self) {
        _subTitle = [self.content getSubTitle];
        _height = [self setHHHeight];
    }
    return self;
}



- (CGFloat)height {
    if (_height == 0) {
        return [self setHHHeight];
    } else {
        return _height;
    }

}


-(CGFloat)setHHHeight {
    ///标签高度
    CGFloat height = 30;
    //标题高度
    height += 8 + MIN([self textHeightStr:_title font:[UIFont systemFontOfSize:18] labelWidth:DY_Width-32], 26);
    
    //作者高度
    height += 30;
    
    //图片高度
    height += ([NSString isEmptyString:_image]?-8:(DY_Width - 32)*0.583) + 8;
    
    //正文高度
    height += (16 + MIN([self textHeightStr:_subTitle font:[UIFont systemFontOfSize:14] labelWidth:DY_Width-32], 40)) * (_subTitle.length?1:0);

    //减去最后一行的行间距
    height -= 4 ;
    
    ///尾边距
    height += 16;
    
    return height;
}

- (CGFloat )textHeightStr:(NSString *)str font:(UIFont *)font labelWidth:(CGFloat)width{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return sizeText.height;
}



@end
