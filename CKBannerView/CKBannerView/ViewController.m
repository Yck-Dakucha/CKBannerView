//
//  ViewController.m
//  CKBannerView
//
//  Created by Yck on 16/3/2.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "ViewController.h"
#import "CKBannerView.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CKBannerView *bannerWithAutoLayOut;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imageURLArray = @[
                               @"http://112.74.195.197:7777/zxupapi/resources/upload/banner/dycmtqt.jpg",
                               @"http://112.74.195.197:7777/zxupapi/resources/upload/banner/sj406.jpg",
                               @"http://112.74.195.197:7777/zxupapi/resources/upload/banner/sljj009.jpg",
                               @"http://112.74.195.197:7777/zxupapi/resources/upload/banner/zt192.jpg",
                               @"http://112.74.195.197:7777/zxupapi/resources/upload/banner/zt193.jpg"
                               ];
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
    
    self.bannerWithAutoLayOut.imagesArray = imageURLArray;
    [self.bannerWithAutoLayOut ck_addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        NSLog(@"这是第%ld张图片",imageIndex);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
