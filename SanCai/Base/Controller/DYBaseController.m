//
//  DYBaseController.m
//  MerryS
//
//  Created by SongChang on 2018/1/8.
//  Copyright © 2018年 SongChang. All rights reserved.
//

#import "DYBaseController.h"

#import "DYOcrMainController.h"
#import "DYForumController.h"
#import "DYCenterController.h"

@interface DYBaseController ()

@end

@implementation DYBaseController


- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self isMemberOfClass:[DYOcrMainController class]] ||
            [self isMemberOfClass:[DYForumController class]] ||
            [self isMemberOfClass:[DYCenterController class]]
            )
        {
            
        }
        else
        {
            self.hidesBottomBarWhenPushed = YES;
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = DY_CustomColor_F5F4F3;
    self.navigationController.navigationBar.translucent = NO;    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.navigationController.viewControllers.count > 1)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.hiddenNavigationBar = _hiddenNavigationBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        _backButton.frame = CGRectMake(0, 0, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"nav_normal_back"] forState:UIControlStateNormal];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(void)setBackButtonHide:(BOOL)hide {
    if (hide == YES) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = !hide;
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
        self.navigationController.interactivePopGestureRecognizer.enabled = !hide;
    }
}


- (void)actionBack
{
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DY_Width, DY_Height - NavHeight)
                                                  style:(self.tableViewIsGrouped ? UITableViewStyleGrouped : UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)])
        {
            _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
        
        //        if (@available(iOS 11.0, *)) {
        //            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        } else {
        //            // Fallback on earlier versions
        //            self.automaticallyAdjustsScrollViewInsets = NO;
        //        }
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

-(void)initTableView {
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)setHiddenNavigationBar:(BOOL)hiddenNavigationBar
{
    _hiddenNavigationBar = hiddenNavigationBar;
    self.navigationController.navigationBar.hidden = _hiddenNavigationBar;
}









@end
