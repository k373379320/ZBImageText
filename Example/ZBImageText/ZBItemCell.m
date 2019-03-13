//
//  ZBItemCell.m
//  ZBImageText_Example
//
//  Created by xzb on 2019/3/12.
//  Copyright © 2019 373379320@qq.com. All rights reserved.
//

#import "ZBItemCell.h"
#import <ZBImageText/YYLabel+ZBImageTextAdditions.h>
@implementation ZBItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.label];
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        self.contentView.layer.borderWidth = 0.5f;
        self.label.numberOfLines = 0;
        self.label.displaysAsynchronously = YES;
    }    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
}

- (void)loadData:(id)data
{
    self.label.attributedText = data[@"attributedString"];
}

+ (CGSize)itemSize:(id)data
{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds),100);
}

- (YYLabel *)label
{
    if (!_label) {
        _label = [[YYLabel alloc] init];
        _label.backgroundColor = [UIColor whiteColor];
    }
    return _label;
}



@end
