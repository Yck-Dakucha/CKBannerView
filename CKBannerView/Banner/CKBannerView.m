//
//  CKBannerView.m
//  CKBannerView
//
//  Created by Yck on 16/3/2.
//  Copyright © 2016年 CK. All rights reserved.
//

#import "CKBannerView.h"
#import <UIImageView+WebCache.h>


@interface CKBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong         ) UIScrollView            *mainScrollView;
@property (nonatomic, assign         ) CGFloat                 widthOfView;
@property (nonatomic, assign         ) CGFloat                 heightView;
@property (nonatomic, assign         ) NSInteger               currentPage;
@property (nonatomic, strong         ) NSTimer                 *timer;
@property (nonatomic, strong         ) UIPageControl           *imageViewPageControl;
@property (nonatomic, strong         ) TapImageViewButtonBlock block;
@property (nonatomic, retain,readonly) UIImageView             * leftImageView;
@property (nonatomic, retain,readonly) UIImageView             * centerImageView;
@property (nonatomic, retain,readonly) UIImageView             * rightImageView;

//用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
@property (nonatomic, assign         ) BOOL isTimeUp;
@property (nonatomic, assign         ) BOOL isImageWithURL;
@property (nonatomic, assign         ) BOOL isLocalImage;


@end

@implementation CKBannerView

#pragma -- 遍历构造器
+ (instancetype) ck_imageScrollViewWithFrame: (CGRect)frame
                                  WithImages: (NSArray *)images{
    CKBannerView *instance = [[CKBannerView alloc] initWithFrame:frame WithImages:images];
    return instance;
}
#pragma -- mark 遍历初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setContentViews];
    }
    return self;
}
- (instancetype)initWithFrame: (CGRect)frame
                   WithImages: (NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentViews];
        self.imagesArray = images;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setContentViews];
    }
    return self;
}
- (void)setContentViews {
    _scrollInterval     = 3;
    _animationInterVale = 0.7;
    _isTimeUp           = NO;
    //当前显示页面
    _currentPage        = 0;
    self.clipsToBounds  = YES;
    //初始化滚动视图
    [self ck_initMainScrollView];
    //添加PageControl
    [self ck_addPageControl];
    //添加timer
    [self ck_addTimerLoop];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _heightView                 = self.frame.size.height;
    _widthOfView                = self.frame.size.width;
    _imageViewPageControl.frame = CGRectMake(0, _heightView - 20, _widthOfView, 20);
    _mainScrollView.frame       = CGRectMake(0, 0, _widthOfView, _heightView);
    _mainScrollView.contentSize = CGSizeMake(_widthOfView * 3, _heightView);
    _leftImageView.frame        = CGRectMake(0, 0, _widthOfView, _heightView);
    _centerImageView.frame      = CGRectMake(_widthOfView, 0, _widthOfView, _heightView);
    _rightImageView.frame       = CGRectMake(_widthOfView * 2, 0, _widthOfView, _heightView);
    [_mainScrollView setContentOffset:CGPointMake(_widthOfView, 0) animated:NO];
    if (_block) {
        [self ck_initImageViewButton];
    }
}
#pragma mark -  处理图像数据
- (void)setImagesArray:(NSArray *)imagesArray {
    
    _imagesArray = imagesArray;
    id imageInfo = imagesArray[0];
    if ([imageInfo isKindOfClass:[NSString class]]) {
        if ([(NSString *)imageInfo hasPrefix:@"http"]) {
            self.isImageWithURL = YES;
        }else {
            self.isLocalImage = YES;
        }
    }
    [self ck_addImageviewsForMainScrollWithImageView];
    _imageViewPageControl.numberOfPages = imagesArray.count;
}
#pragma 添加PageControl
- (void)ck_addPageControl{
    _imageViewPageControl = [[UIPageControl alloc] init];
    _imageViewPageControl.numberOfPages                 = _imagesArray.count;
    _imageViewPageControl.currentPage                   = _currentPage - 1;
    _imageViewPageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    _imageViewPageControl.pageIndicatorTintColor        = [UIColor whiteColor];

    [self addSubview:_imageViewPageControl];
}
#pragma mark -  如果设置了点击事件则加载一个Button
- (void)ck_addTapEventForImageWithBlock: (TapImageViewButtonBlock) block{
    if (_block == nil) {
        if (block != nil) {
            _block = block;
        }
    }
}
#pragma -- mark 初始化按钮
- (void)ck_initImageViewButton{
    CGRect currentFrame = CGRectMake(_widthOfView, 0, _widthOfView, _heightView);
    UIButton *tempButton = [[UIButton alloc] initWithFrame:currentFrame];
    [tempButton addTarget:self action:@selector(ck_tapImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:tempButton];
}
#pragma mark -  点击事件
- (void)ck_tapImageButton: (UIButton *) sender{
    if (_block) {
        _block(_currentPage);
    }
}
#pragma -- mark 初始化ScrollView
- (void)ck_initMainScrollView{
    
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.pagingEnabled                  = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator   = NO;
    _mainScrollView.delegate                       = self;
    
    [self addSubview:_mainScrollView];
}

#pragma -- mark 给ScrollView添加ImageView 3个ImageView
- (void)ck_addImageviewsForMainScrollWithImageView{
    
    _leftImageView = [[UIImageView alloc] init];
    _centerImageView = [[UIImageView alloc] init];
    _rightImageView = [[UIImageView alloc] init];
    
    [_mainScrollView addSubview:_leftImageView];
    [_mainScrollView addSubview:_centerImageView];
    [_mainScrollView addSubview:_rightImageView];

    [self ck_setIamgeToImageView:_leftImageView   WithImage:_imagesArray.lastObject];
    [self ck_setIamgeToImageView:_centerImageView WithImage:_imagesArray[0]];
    [self ck_setIamgeToImageView:_rightImageView  WithImage:_imagesArray[1]];    
}
#pragma mark -  设置计时器
- (void)ck_addTimerLoop{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(ck_animalMoveImage) userInfo:nil repeats:YES];
    }
}
#pragma mark - 计时器到时,系统滚动图片
- (void)ck_animalMoveImage
{
    [_mainScrollView setContentOffset:CGPointMake(_widthOfView * 2, 0) animated:YES];
    _isTimeUp = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (_mainScrollView.contentOffset.x == 0) {
        
        if (_currentPage == 0) {
            _currentPage = _imagesArray.count - 1;
        }else {
            _currentPage -= 1;
        }
        _imageViewPageControl.currentPage = _currentPage;
    }
    else if (_mainScrollView.contentOffset.x == _widthOfView * 2) {
        _currentPage                      = (_currentPage + 1)%_imagesArray.count;
        _imageViewPageControl.currentPage = (_imageViewPageControl.currentPage + 1)%_imagesArray.count;
        
    }else {
        return;
    }
    
    if (_currentPage == 0) {
        [self ck_setIamgeToImageView:_leftImageView WithImage:_imagesArray.lastObject];
    }else{
        [self ck_setIamgeToImageView:_leftImageView WithImage:_imagesArray[(_currentPage - 1) % _imagesArray.count]];
        
    }
    
    [self ck_setIamgeToImageView:_centerImageView WithImage:_imagesArray[_currentPage % _imagesArray.count]];
    [self ck_setIamgeToImageView:_rightImageView WithImage:_imagesArray[(_currentPage + 1) % _imagesArray.count]];
    
    
    _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
    
    if (!_isTimeUp) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollInterval-_animationInterVale]];
    }
    _isTimeUp = NO;
    
}

- (void)ck_setIamgeToImageView:(UIImageView *)imageView WithImage:(id)iamgeInfo {
    if (self.isImageWithURL) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)iamgeInfo]];
    }else if (self.isLocalImage) {
        [imageView setImage:[UIImage imageNamed:(NSString *)iamgeInfo]];
    }else {
        [imageView setImage:(UIImage *)iamgeInfo];
    }
}

@end
