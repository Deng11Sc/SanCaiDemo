//
//  DY_CenterListView.h
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Height_centerList 70.f

@protocol DY_CenterListViewDelegate <NSObject>

@required
-(void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end



///任务，金币兑换
@interface DY_CenterListView : UIView

-(void)initSubviewsWithDataArray:(NSMutableArray *)dataArray;

@property(nonatomic,weak)__weak id<DY_CenterListViewDelegate>delagate;


@end

