# ZBFancyCollectionView

[![CI Status](https://img.shields.io/travis/373379320@qq.com/ZBFancyCollectionView.svg?style=flat)](https://travis-ci.org/373379320@qq.com/ZBFancyCollectionView)
[![Version](https://img.shields.io/cocoapods/v/ZBFancyCollectionView.svg?style=flat)](https://cocoapods.org/pods/ZBFancyCollectionView)
[![License](https://img.shields.io/cocoapods/l/ZBFancyCollectionView.svg?style=flat)](https://cocoapods.org/pods/ZBFancyCollectionView)
[![Platform](https://img.shields.io/cocoapods/p/ZBFancyCollectionView.svg?style=flat)](https://cocoapods.org/pods/ZBFancyCollectionView)

## Example

```oc
    self.collectionView = [UICollectionView fancyLayoutWithStyle:self.style];
    if (self.style == ZBFancyCollectionViewStyleCustom) {
        self.collectionView.fancyLayout.hoverIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    }
    self.view.backgroundColor = self.collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.bottom.offset(0);
        }
        make.left.right.offset(0);
    }];
    __weak typeof(self) weakSelf = self;
    
    //register
    [self.collectionView zb_configTableView:^(ZBCollectionProtoFactory *config) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf makerConfig:config];
    }];
    //data
    [self.collectionView zb_setup:^(ZBCollectionMaker *maker) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf makerExample:maker];
    }];
```

## Requirements

## Installation

ZBFancyCollectionView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZBFancyCollectionView'
```

## Author

373379320@qq.com, 373379320@qq.com

## License

ZBFancyCollectionView is available under the MIT license. See the LICENSE file for more info.
