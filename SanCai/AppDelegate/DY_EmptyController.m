//
//  DY_EmptyController.m
//  SanCai
//
//  Created by SongChang on 2018/4/19.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_EmptyController.h"

@interface DY_EmptyController ()

@end

@implementation DY_EmptyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    CGFloat width = self.view.width/2;
//    UIImageView *logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.top-width)/2, (self.view.left-width)/2, width, width)];
//    logoImgView.image = [UIImage imageNamed:@"AppIcon"];
//    [self.view addSubview:logoImgView];
//   
//    
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//                                   //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
//                                   animation.fromValue = [NSNumber numberWithFloat:0.f];
//                                   animation.toValue = [NSNumber numberWithFloat: M_PI *2];
//                                   animation.duration = 3;
//                                   animation.autoreverses = NO;
//                                   animation.fillMode = kCAFillModeForwards;
//                                   animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
//                                   [logoImgView.layer addAnimation:animation forKey:nil];
                                   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
