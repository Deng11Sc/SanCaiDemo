//
//  DYWebTabbarView.m
//  MerryS
//
//  Created by SongChang on 2018/1/15.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYWebTabbarView.h"

@implementation DYWebTabbarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setBorderColor:kUIColorFromRGB(0xDDDDDD).CGColor];
        [self.layer setBorderWidth:0.5];
        
        [self _initSubviews];
    }
    return self;
}

-(void)_initSubviews
{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSArray *imgArr = @[@{@"img":@"lc_toolbar_tohome",@"type":@(DYWebBtnTypeTohome)},
                        @{@"img":@"lc_toolbar_refresh",@"type":@(DYWebBtnTypeRefresh)},
                        @{@"img":@"lc_edit_toolbar_back",@"type":@(DYWebBtnTypeBack)},
                        @{@"img":@"lc_toolbar_next",@"type":@(DYWebBtnTypeNext)}
                        ];
    for (int i = 0 ; i < imgArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSDictionary *dic = imgArr[i];
        
        UIImage *img = [UIImage imageNamed:dic[@"img"]];
        if (img) {
            [btn setImage:img forState:0];
        } else {
            [btn setTitle:(NSString *)img forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitleColor:DY_CustomColor_3A3534 forState:0];
        }
        btn.tag = [dic[@"type"] integerValue];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [arr addObject:btn];
    }
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60 leadSpacing:20 tailSpacing:20];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
}


-(void)btnAction:(UIButton *)btn
{
    if (self.actionBlock) {
        self.actionBlock(btn.tag);
    }
}









@end
