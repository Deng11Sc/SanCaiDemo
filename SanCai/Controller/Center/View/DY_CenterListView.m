//
//  DY_CenterListView.m
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import "DY_CenterListView.h"

#import "DY_CenterListCell.h"

@interface DY_CenterListView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation DY_CenterListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self dy_initSubviews];
    }
    return self;
}

-(void)initSubviewsWithDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}


-(void)dy_initSubviews {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0.5;
    layout.minimumInteritemSpacing = 0;

    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    collect.backgroundColor = [UIColor clearColor];
    [collect registerClass:[DY_CenterListCell class] forCellWithReuseIdentifier:@"DY_CenterListCellId"];
    
    [self addSubview:collect];
    _collectionView = collect;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, 0, self.width, self.height);
    [self.collectionView reloadData];
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DY_CenterListCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"DY_CenterListCellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    [cell setImage:[UIImage imageNamed:dict[@"icon"]] title:dict[@"title"]];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.width/_dataArray.count - (_dataArray.count-1)*0.5;
    return CGSizeMake(width, self.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([self.delagate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delagate didSelectItemAtIndexPath:indexPath];
    }
}


@end








