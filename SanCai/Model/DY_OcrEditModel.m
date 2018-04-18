//
//  DY_OcrEditModel.m
//  MerryS
//
//  Created by SongChang on 2018/1/25.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_OcrEditModel.h"

@implementation DY_OcrEditModel

- (void)setEditText:(NSString *)editText
{
    _editText = editText;
    
    self.height = [self textHeightStr:editText font:[UIFont systemFontOfSize:16] labelWidth:DY_Width-32-80] + 16;
}



- (CGFloat )textHeightStr:(NSString *)str font:(UIFont *)font labelWidth:(CGFloat)width{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return sizeText.height;
}


- (id)copyWithZone:(nullable NSZone *)zone{
    DY_OcrEditModel *person = [[self class] allocWithZone:zone];
    person.editText = [_editText copy];
    person.isSelect = _isSelect;
    person.needDelete = _needDelete;
    person.height = _height;
    return person;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone{
    DY_OcrEditModel *person = [[self class] allocWithZone:zone];
    person.editText = [_editText copy];
    person.isSelect = _isSelect;
    person.needDelete = _needDelete;
    person.height = _height;
    
    return person;
}


@end
