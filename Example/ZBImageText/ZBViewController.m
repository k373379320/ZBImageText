//
//  ZBViewController.m
//  ZBImageText
//
//  Created by 373379320@qq.com on 03/11/2019.
//  Copyright (c) 2019 373379320@qq.com. All rights reserved.
//

#import "ZBViewController.h"
#import <YYText/YYText.h>
#import <ZBImageText/YYLabel+ZBImageTextAdditions.h>

#ifdef DEBUG
#define kStartTime CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#define kEnd(__log__) CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime); NSLog(@"📝--%@-->  %f ms", __log__, linkTime * 1000.0);
#else
#define kStartTime
#define kEnd(__log__)
#endif

@interface ZBViewController ()

@property (nonatomic, strong) YYLabel *label;

@end

@implementation ZBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self.view addSubview:self.label];
    
    [self makeImageText];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.label.frame = CGRectMake(0, 100, CGRectGetWidth([UIScreen mainScreen].bounds), 100);
}

- (void)makeImageText
{
    [self.label zb_makeContexts:^(ZBImageTextMaker *make) {
        make.space(4.0);
        
        //默认
        make.image([UIImage imageNamed:@"Canada_28"]);
        make.space(4.0);
        //指定宽高
        ZBImageTextBlock imgEmptyBlock = ^(UIImageView *imageView) {
            NSLog(@"%@", imageView);
        };
        
        make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14).config(@{ @"imageView" : imgEmptyBlock });
        make.space(4.0);
        //web图
        make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14).url(@"http://b0.hucdn.com/img/country_new/ct_18.png");
        make.space(4.0);
        //有边框样式
        make.image([UIImage imageNamed:@"Netherlands_28"]).width(11).height(11).border([ZBImageTextItemBorder borderWithColor:[UIColor blueColor] width:1 radius:5.5]).offset(-2);
        
        //默认
        make.text(@"优惠券").decoration([ZBImageTextItemDecoration decoration]);
        
        make.space(4.0);
        
        //baselineFont 用于中心对齐的基准font
        
        //指定font,color
        make.text(@"优惠券")
        .font([UIFont systemFontOfSize:12])
        .color([UIColor redColor])
        .baselineFont([UIFont systemFontOfSize:16]);
        
        make.space(4.0);
        
        //有背景的文字,图片会点九拉伸
        make.text(@"优惠券")
        .font([UIFont systemFontOfSize:12])
        .color([UIColor redColor])
        .baselineFont([UIFont systemFontOfSize:16])
        .offset(0.6)
        .bg([ZBImageTextItemBackground bgWithImage:[UIImage imageNamed:@"bg01"] margin:UIEdgeInsetsMake(2, 5, 2, 5)]);
        
        make.space(4.0);
        
        //有边框的文字
        make.text(@"下单立减10元")
        .font([UIFont systemFontOfSize:10])
        .color([UIColor redColor])
        .baselineFont([UIFont systemFontOfSize:16])
        .color([UIColor redColor])
        .border([ZBImageTextItemBorder borderWithColor:[UIColor redColor] width:0.5 radius:2 margin:UIEdgeInsetsMake(2, 3, 2, 3)]);
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    kStartTime;
    for (NSInteger idx = 0; idx < 10; idx++) {
        [self makeImageText];
    }
    kEnd(@"总耗时");
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
