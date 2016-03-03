# CKBannerView
##一个复用的图片轮播器
####使用方法

* 使用纯代码
```
{
    NSArray *imageArray = @[
                            [UIImage imageNamed:@"Test1"],
                            [UIImage imageNamed:@"Test2"],
                            [UIImage imageNamed:@"Test3"]
                            ];
    CKBannerView *banner = [CKBannerView ck_imageScrollViewWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight/3) WithImages:imageArray];
    [banner ck_addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        NSLog(@"这是第%ld张图片",imageIndex);
    }];
    [self.view addSubview:banner];
}
```
*  使用AutoLayOut
```
self.bannerWithAutoLayOut.imagesArray = imageURLArray;
[self.bannerWithAutoLayOut ck_addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        NSLog(@"这是第%ld张图片",imageIndex);
    }];
```
点击事件可有可无，没有点击事件就不用添加
