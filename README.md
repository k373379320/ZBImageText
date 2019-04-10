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

* space

```objective-c
[self.label zb_makeContexts:^(ZBImageTextMaker *make) {
    make.space(4.0);
}];

config:
label.attributedText = [ZBImageTextEngine attributedStringFromData:@[@(4.0)]];
```

* image

```objective-c
[self.label zb_makeContexts:^(ZBImageTextMaker *make) {
    //默认
    make.image([UIImage imageNamed:@"Canada_28"]);
    //指定宽高
    make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14);
    //web图
    make.image([UIImage imageNamed:@"img_empty"]).width(14).height(14).url(@"http://b0.hucdn.com/img/country_new/ct_18.png");    
    //有边框样式
    make.image([UIImage imageNamed:@"Netherlands_28"]).width(11).height(11).border([ZBImageTextItemBorder borderWithColor:[UIColor blueColor] width:1 radius:5.5]).offset(-2);
    //事件
    YYTextAction action1 = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        NSLog(@"%@",text);
    };
    make.image([UIImage imageNamed:@"Canada_28"]).config(@{
    @"tap" : action1
    });
    //获取imageView
    ZBImageTextBlock imgEmptyBlock = ^(UIImageView *imageView) {
    NSLog(@"%@",imageView);
    };
    make.image([UIImage imageNamed:@"img_empty"]).config(@{ @"imageView" :imgEmptyBlock});
}];
```
![image01.png](https://upload-images.jianshu.io/upload_images/1986326-ba1803638fb4b513.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/320)


* text


```objective-c
[self.label zb_makeContexts:^(ZBImageTextMaker *make) {
    
    //默认
    make.text(@"优惠券");
    
    make.space(4.0);
    
    //指定font,color.baselineFont 用于中心对齐的基准font
    make.text(@"优惠券")
    .font([UIFont systemFontOfSize:12])
    .color([UIColor redColor])
    .baselineFont([UIFont systemFontOfSize:16]);
    
    make.space(4.0);
    
    //有背景的文字,图片会点九拉伸
    make.text(@"优惠券")
    .bg([ZBImageTextItemBackground bgWithImage:[UIImage imageNamed:@"bg01"] margin:UIEdgeInsetsMake(2, 5, 2, 5)]);
    
    make.space(4.0);
    
    //有边框的文字
    make.text(@"下单立减10元")
    .border([ZBImageTextItemBorder borderWithColor:[UIColor redColor] width:0.5 radius:2 margin:UIEdgeInsetsMake(2, 3, 2, 3)]);
   
   //删除线
   make.text(@"优惠券").decoration([ZBImageTextItemDecoration decoration]);
   
   //事件
     YYTextAction action2 = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
     NSLog(@"%@",text);
     };
     make.text(@"优惠券").config(@{
     @"decoration" :@{},
     @"tap" : action2
     });
}];
```
![text01.png](https://upload-images.jianshu.io/upload_images/1986326-230072f0c32c43cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/320)

## help

###### 1. 如何垂直调整
```objective-c
make.text(@"优惠券").offset(10);
```
###### 2. 如何用dict写
```objective-c
label.attributedText = [ZBImageTextEngine attributedStringFromData:[self templates]];

- (NSArray *)templates
{
    return @[ @{
                   @"text" : @"优惠券",
                   @"font" : [UIFont systemFontOfSize:12],
                   @"color" : [UIColor blackColor],
                   @"baselineFont" : [UIFont systemFontOfSize:16],
                   @"offset" : @(0.5),
                   @"bg" : @{
                           @"margin" : [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 5)],
                           @"image" : [UIImage imageNamed:@"bg01"],
                           }
                   }, @(4.0), @{
                   @"image" : [UIImage imageNamed:@"jianada_28x28"],
                   @"width" : @(11),
                   @"height" : @(11),
                   @"border" : @{
                           @"color" : [UIColor blueColor],
                           @"width" : @(1),
                           @"radius" : @(5.5),
                           }
                   }, @(4.0),@{
                   @"text" : @"下单立减10元",
                   @"font" : [UIFont systemFontOfSize:10],
                   @"baselineFont" : [UIFont systemFontOfSize:16],
                   @"color" : [UIColor redColor],
                   @"border" : @{
                           @"margin" : [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 3, 2, 3)],
                           @"color" : [UIColor redColor],
                           @"width" : @(0.5),
                           @"radius" : @(2),
                           }
                   }];
}
```
###### 3.hook
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
