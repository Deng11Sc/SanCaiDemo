#import "DY_ArticleImageCell.h"
@implementation DY_ArticleImageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(UIImageView *)dy_imageView {
    if (!_dy_imageView) {
        UIImageView *dy_imageView = [[UIImageView alloc] init];
        [dy_imageView dy_configure];
        [self.contentView addSubview:dy_imageView];
        _dy_imageView = dy_imageView;
    }
    return _dy_imageView;
}
-(void)layoutSubviews {
    [super layoutSubviews];    
}


-(CGFloat)resetImageHeight
{
    if (_dy_imageView.image) {
        CGSize size = _dy_imageView.image.size;
        CGFloat width = size.width/size.height * self.contentView.height;
        
        if (width < (DY_SCREEN_MIN-32)) {
            _dy_imageView.frame = CGRectMake(16, 0, width, self.contentView.height);
        } else {
            CGFloat scale = (DY_SCREEN_MIN-32)/width;
            _dy_imageView.frame = CGRectMake(16, 0, (DY_SCREEN_MIN-32), self.contentView.height*scale);
        }
    } else {
        _dy_imageView.frame = CGRectMake(16, 0, self.contentView.width-32, 0);
    }
    return _dy_imageView.frame.size.height;
}

@end
