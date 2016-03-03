//
//  CKBannerView.h
//  CKBannerView
//
//  Created by Yck on 16/3/2.
//  Copyright © 2016年 CK. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击图片的Block回调，参数当前图片的索引，也就是当前页数
typedef void(^TapImageViewButtonBlock)(NSInteger imageIndex);

@interface CKBannerView : UIView

//切换图片的时间间隔，可选，默认为3s
@property (nonatomic, assign) CGFloat scrollInterval;

//切换图片时，运动时间间隔,可选，默认为0.7s
@property (nonatomic, assign) CGFloat animationInterVale;

//图片数组
@property (nonatomic, strong) NSArray *imagesArray;

/**
 *  通过Frame和包含有图像的数组构造轮播器
 *
 *  @param frame     滚动视图的Frame
 *  @param imageURLs 要显示图片的数组
 *
 *  @return 该类的对象
 */
+ (instancetype) ck_imageScrollViewWithFrame: (CGRect)frame
                               WithImages: (NSArray *)images;

/**
 *  为每个图片添加点击事件
 *
 *  @param block 点击按钮要执行的Block
 */
- (void) ck_addTapEventForImageWithBlock: (TapImageViewButtonBlock) block;


@end
