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

@property (nonatomic, strong) YYLabel *spaceLabel;

@property (nonatomic, strong) YYLabel *imageLabel;

@property (nonatomic, strong) YYLabel *textLabel;

@end

@implementation ZBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.spaceLabel];
    [self.view addSubview:self.imageLabel];
    [self.view addSubview:self.textLabel];
    
    [self makeImageText];
    
    [self.spaceLabel zb_makeContexts:^(ZBImageTextMaker *make) {
        make.text(@"丨");
        make.space(10);
        make.text(@"丨");
        make.space(20);
        make.text(@"丨");
        make.space(30);
        make.text(@"丨");
    }];
    
    [self.imageLabel zb_makeContexts:^(ZBImageTextMaker *make) {
        make.image([UIImage imageNamed:@"Canada_28"]);
        make.image([UIImage imageNamed:@"Canada_28"]).size(CGSizeMake(20, 20));
        make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).border([ZBImageTextItemBorder borderWithRadius:20]);
        make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).border([ZBImageTextItemBorder borderWithColor:[UIColor redColor] width:5 radius:10]);
        make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).border([ZBImageTextItemBorder borderWithColor:[UIColor redColor] width:1 radius:3 margin:UIEdgeInsetsMake(3, 3, 3, 3)]);
        make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).url(@"http://b0.hucdn.com/img/country_new/ct_18.png");
    }];
    
    [self.textLabel zb_makeContexts:^(ZBImageTextMaker *make) {
        make.text(@"优惠券");
        
        //指定font,color
        make.text(@"优惠券")
        .font([UIFont systemFontOfSize:20])
        .color([UIColor redColor]);
        
        //删除线
        make.text(@"优惠券").decoration([ZBImageTextItemDecoration decoration]).baselineFont([UIFont systemFontOfSize:30]);
        
        //有背景的文字,图片会点九拉伸
        make.text(@"优惠券")
        .font([UIFont systemFontOfSize:20])
        .color([UIColor redColor])
        .offset(0.6)
        .bg([ZBImageTextItemBackground bgWithImage:[UIImage imageNamed:@"bg01"] margin:UIEdgeInsetsMake(2, 5, 2, 5)]);
        
        //有边框的文字
        make.text(@"下单立减10元")
        .font([UIFont systemFontOfSize:20])
        .color([UIColor redColor])
        .color([UIColor redColor])
        .border([ZBImageTextItemBorder borderWithColor:[UIColor redColor] width:0.5 radius:2 margin:UIEdgeInsetsMake(2, 3, 2, 3)]);
    } globalConfig:@{
                     @"baselineFont": [UIFont systemFontOfSize:30]
                     }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.label.frame = CGRectMake(0, 100, CGRectGetWidth([UIScreen mainScreen].bounds), 100);
    self.spaceLabel.frame = CGRectMake(0, 250, CGRectGetWidth([UIScreen mainScreen].bounds), 100);
    self.imageLabel.frame = CGRectMake(0, 400, CGRectGetWidth([UIScreen mainScreen].bounds), 100);
    self.textLabel.frame = CGRectMake(0, 550, CGRectGetWidth([UIScreen mainScreen].bounds), 100);
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
        make.image(([UIImage imageNamed:@"Canada_28"])).width(14).height(14).config(@{ @"imageView": imgEmptyBlock });
        make.space(4.0);
        //web图
        make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14).url(@"http://b0.hucdn.com/img/country_new/ct_18.png");
        make.space(4.0);
        //有边框样式
        make.image([UIImage imageNamed:@"img_empty"]).width(20).height(20).border([ZBImageTextItemBorder borderWithColor:[UIColor blueColor] width:1 radius:5]).offset(-2);
        make.space(4.0);
        
        //删除线
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
    for (NSInteger idx = 0; idx < 100; idx++) {
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

- (YYLabel *)spaceLabel
{
    if (!_spaceLabel) {
        _spaceLabel = [[YYLabel alloc] init];
        _spaceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _spaceLabel;
}

- (YYLabel *)imageLabel
{
    if (!_imageLabel) {
        _imageLabel = [[YYLabel alloc] init];
        _imageLabel.backgroundColor = [UIColor whiteColor];
    }
    return _imageLabel;
}

- (YYLabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[YYLabel alloc] init];
        _textLabel.backgroundColor = [UIColor whiteColor];
    }
    return _textLabel;
}

@end
