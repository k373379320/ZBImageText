#ZBImageTextEngine

## 起因

为了解决图文混排的痛点;

- space大小不正确问题;
- 富文本不同font对齐问题如:baselineOffset在8.0失效问题
- 不同font富文本,删除线无法居中问题;
- 富文本中有图片/web图问题;
- 富文本文字后面有图片切点九图问题;
- 富文本文字后面有边框样式问题;
- 富文本文字/图片有事件
- 写富文本代码啰嗦;
- 对image优化Color Blended Layers
...

## Features

- 图文混排



## How To Use

![xzb_imageText.jpg](https://upload-images.jianshu.io/upload_images/1986326-dd437251014700c3.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/320)

* space

```objective-c
[self.spaceLabel zb_makeContexts:^(ZBImageTextMaker *make) {
    make.text(@"丨");
    make.space(10);
    make.text(@"丨");
    make.space(20);
    make.text(@"丨");
    make.space(30);
    make.text(@"丨");
}];
```

* image

```objective-c
[self.imageLabel zb_makeContexts:^(ZBImageTextMaker *make) {
    make.image([UIImage imageNamed:@"Canada_28"]);
    make.image([UIImage imageNamed:@"Canada_28"]).size(CGSizeMake(20, 20));
    make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).border([ZBImageTextItemBorder borderWithRadius:20]);
    make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).border([ZBImageTextItemBorder borderWithColor:[UIColor redColor] width:5 radius:10]);
    make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).border([ZBImageTextItemBorder borderWithColor:[UIColor redColor] width:1 radius:3 margin:UIEdgeInsetsMake(3, 3, 3, 3)]);
    make.image([UIImage imageNamed:@"img_empty"]).size(CGSizeMake(40, 40)).url(@"http://b0.hucdn.com/img/country_new/ct_18.png");
}];
```
* text


```objective-c
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
```

## help

###### 1. 如何垂直调整
```objective-c
make.text(@"优惠券").offset(10);
```

###### 2.hook
使用block
```objective-c

typedef void(^ZBImageTextBlock)(id obj);
```

example:

- ZBImageTextItem
```objective-c
//ZBImageTextBlock imageViewBlock = data[@"imageView"] ? : nil;
//ZBImageTextBlock itemBlock = data[@"item"] ? : nil;

make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14).config(@{ @"imageView" :^(UIImageView *imageView) {
NSLog(@"%@",imageView);
}});

```
- ZBImageTextItem

```objective-c
//ZBImageTextBlock imageViewBlock = data[@"imageView"] ? : nil;
//ZBImageTextBlock itemBlock = data[@"item"] ? : nil;
//ZBImageTextBlock textLayerBlock = data[@"textLayer"] ? : nil;
```

## Installation

####  
```
platform :ios, '8.0'

pod 'ZBImageText'
```


