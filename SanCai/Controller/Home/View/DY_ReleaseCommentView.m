//
//  DY_ReleaseCommentView.m
//  demo
//
//  Created by ios on 2018/4/8.
//  Copyright © 2018年 LC. All rights reserved.
//

#import "DY_ReleaseCommentView.h"

#import "UIView+CommonView.h"
#import "DY_LoginInfoManager.h"

@interface DY_ReleaseCommentView ()

@property (nonatomic,strong)UITextField *titleTextField;

@property (nonatomic,strong)UIButton *movieNameBtn;

@property (nonatomic,strong)UIButton *typeBtn;

@property (nonatomic,strong)UITextView *commentTextView;

@property (nonatomic,strong)UIButton *releaseBtn;

@end

@implementation DY_ReleaseCommentView

+ (CGFloat)height {
    return 300;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initSubview];
    }
    return self;
}

-(void)_initSubview {
    UITextField *textField = [[UITextField alloc] init];
    textField.font = [UIFont systemFontOfSize:17];
    textField.textColor = mainColor;
    textField.placeholder = DYLocalizedString(@"Enter a comment title", @"输入评论标题");
    [textField setValue:[UIFont systemFontOfSize:17] forKeyPath:@"_placeholderLabel.font"];

    [self addSubview:textField];
    _titleTextField = textField;
    
    UIButton *movieNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [movieNameBtn initTagsViewWithColor:[UIColor redColor]];
    [self addSubview:movieNameBtn];
    _movieNameBtn = movieNameBtn;
    
    UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [typeBtn initTagsViewWithColor:kUIColorFromRGB(0x2aa515)];
    typeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:typeBtn];
    _typeBtn = typeBtn;
    
    UITextView *commentTextView = [[UITextView alloc] init];
    commentTextView.font = [UIFont systemFontOfSize:16];
    [commentTextView.layer setCornerRadius:4];
    commentTextView.clipsToBounds = YES;
    [commentTextView.layer setBorderColor:[UIColor blackColor].CGColor];
    [commentTextView.layer setBorderWidth:1];
    [self addSubview:commentTextView];
    _commentTextView = commentTextView;
    
    UIButton *releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [releaseBtn dy_configure];
    [releaseBtn setTitleColor:[UIColor blackColor] forState:0];
    releaseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [releaseBtn setTitle:@"发布" forState:0];
    [releaseBtn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:releaseBtn];
    _releaseBtn = releaseBtn;

    
    [_typeBtn setTitle:DYLocalizedString(@" Film Review ", @" 影评 ") forState:0];
    
    [self _setLayoutSubviews];
}

-(void)_setLayoutSubviews {
    [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(44);
    }];
    
    [_movieNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleTextField.mas_bottom);
        make.left.mas_equalTo(8);
        make.height.mas_equalTo(16);
    }];
    
    [_typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleTextField.mas_bottom);
        make.left.equalTo(_movieNameBtn.mas_right).offset(8);
        make.height.mas_equalTo(16);
    }];
    
    [_releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(35);
    }];

    
    [_commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_typeBtn.mas_bottom).offset(12);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.equalTo(_releaseBtn.mas_top).offset(-8);
    }];

}

-(void)setMovieModel:(DY_MovieDescModel *)movieModel {
    _movieModel = movieModel;
    
    [_movieNameBtn setTitle:[NSString stringWithFormat:@" %@ ",movieModel.movieName] forState:0];

}

-(void)releaseAction {
    
    if ([NSString isEmptyString:_titleTextField.text] || [NSString isEmptyString:_commentTextView.text]) {
        [NSObject showError:DYLocalizedString(@"Please fill in the complete", nil)];
        return;
    }
    
    if (self.releaseCommentBlk) {
        
        if ([DY_LoginInfoManager manager].isLogin == NO) {

            [NSObject showMessage:DYLocalizedString(@"Please log in first", "请先登录")];
            [[DY_LoginInfoManager manager] prensentLoginController];
            return;
        }

        DY_UserInfoModel *userInfo = [DY_LoginInfoManager getUserInfo];
        
        DY_FilmReviewModel *model = [[DY_FilmReviewModel alloc] init];
        model.movieImgUrl = self.movieModel.movieImg;
        model.commentType = self.typeBtn.titleLabel.text;
        model.movieName = self.movieNameBtn.titleLabel.text;
        model.title = self.titleTextField.text;
        model.movieId = self.movieModel.movieId;
        model.movieDesc = self.commentTextView.text;
        model.commentator = userInfo.nickName;
        model.authorId = SELF_USER_ID;
        
        self.releaseCommentBlk(model);
    }
}




@end
