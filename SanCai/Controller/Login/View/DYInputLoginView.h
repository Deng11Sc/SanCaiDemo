//
//  DYInputLoginView.h
//  SanCai
//
//  Created by SongChang on 2018/4/5.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYInputTextField.h"


@interface DYInputLoginView : UIView

+ (CGFloat)height;

@property (nonatomic,strong)DYInputTextField *tf1;

@property (nonatomic,strong)DYInputTextField *tf2;

- (void)endEdit ;


@end
