//
//  ZBListViewController.m
//  ZBImageText_Example
//
//  Created by xzb on 2019/3/12.
//  Copyright © 2019 373379320@qq.com. All rights reserved.
//

#import "ZBListViewController.h"
#import <ZBImageText/YYLabel+ZBImageTextAdditions.h>
#import <ZBFancyCollectionView/UICollectionView+ZBFancy.h>
#import "ZBFpsTool.h"

@interface ZBListViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *fpsLabel;
@end

@implementation ZBListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView = [UICollectionView fancyLayoutWithStyle:ZBFancyCollectionViewStylePlain];
    self.collectionView.backgroundColor = [UIColor cyanColor];
    [self.collectionView zb_configTableView:^(ZBCollectionProtoFactory *config) {
        config.cell(@"<item>").cls(@"ZBItemCell");
    }];
    [self.collectionView zb_setup:^(ZBCollectionMaker *maker) {
        maker.section(@"one");
        for (NSInteger idx = 0; idx < 100; idx++) {
            NSAttributedString *attributedString = [YYLabel zb_attributedStringWithContexts:^(ZBImageTextMaker *make) {
                for (NSInteger idx = 0; idx < 3; idx++) {
                    make.space(4.0);
                    //默认
                    make.image([UIImage imageNamed:@"Canada_28"]);
                    make.space(4.0);
                    //指定宽高
                    make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14);
                    make.space(4.0);
                    //web图
                    make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14).url(@"http://b0.hucdn.com/img/country_new/ct_18.png");
                    make.space(4.0);
                    //有边框样式
                    make.image([UIImage imageNamed:@"Netherlands_28"]).width(11).height(11).border([ZBImageTextItemBorder borderWithColor:[UIColor blueColor] width:1 radius:5.5]).offset(-2);
                    
                    //默认
                    make.text(@"优惠券");
                    
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
                }
            }];
            
            maker.row(@"<item>").model(@{ @"attributedString" : attributedString });
        }
    }];
    [self.view addSubview:self.collectionView];
    
    UILabel *fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 50, 50, 15)];
    fpsLabel.backgroundColor = [UIColor whiteColor];
    fpsLabel.font = [UIFont systemFontOfSize:12];
    fpsLabel.textColor = [UIColor redColor];
    [self.view addSubview:fpsLabel];
    
    self.fpsLabel = fpsLabel;
    
    __weak typeof(self)weakSelf = self;
    [[ZBFpsTool instance] openWithHandler:^(NSInteger fpsValue) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.fpsLabel.text = [NSString stringWithFormat:@"fps-%d", (int)round(fpsValue)];
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

@end
