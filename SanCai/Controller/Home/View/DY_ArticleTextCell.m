#import "DY_ArticleTextCell.h"
@implementation DY_ArticleTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(UILabel *)dy_textLabel {
    if (!_dy_textLabel) {
        UILabel *dy_textLabel = [[UILabel alloc] init];
        [dy_textLabel dy_configure];
        dy_textLabel.font = [UIFont systemFontOfSize:16];
        dy_textLabel.numberOfLines = 0;
        dy_textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:dy_textLabel];
        _dy_textLabel = dy_textLabel;
    }
    return _dy_textLabel;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    _dy_textLabel.frame = CGRectMake(16, 0, self.contentView.width-32, self.contentView.height);
}
@end
