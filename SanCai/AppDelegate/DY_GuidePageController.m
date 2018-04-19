//
//  DY_GuidePageController.m
//  SanCai
//
//  Created by SongChang on 2018/4/18.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DY_GuidePageController.h"

@interface DY_GuidePageController ()

@end

@implementation DY_GuidePageController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 静态引导页
    NSArray *imageNameArray = @[@"GuideImage1",@"GuideImage2",@"GuideImage3",@"GuideImage4"];
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:CGRectMake(0, 0, CC_Width, CC_Height) imageNameArray:imageNameArray buttonIsHidden:NO];
    guidePage.slideInto = YES;
    [self.view addSubview:guidePage];

    guidePage.guideEndBlock = ^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dismissViewControllerAnimated:NO completion:nil];
    };

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

-(BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    // 如果该界面仅支持横屏
    // return UIInterfaceOrientationMaskLandscapeRight；
}


@end
