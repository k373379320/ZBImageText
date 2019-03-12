//
//  ZBItemCell.h
//  ZBImageText_Example
//
//  Created by xzb on 2019/3/12.
//  Copyright © 2019 373379320@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText/YYText.h>
#import <ZBFancyCollectionView/ZBFancyCellProtocol.h>

@interface ZBItemCell : UICollectionViewCell <ZBFancyCellProtocol>

@property (nonatomic, strong) YYLabel *label;

@end
