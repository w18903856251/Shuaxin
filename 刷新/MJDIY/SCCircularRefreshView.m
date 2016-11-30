//
//  SCCircularRefreshView.m
//  newSponia
//
//  Created by Singro on 5/27/14.
//  Copyright (c) 2014 Sponia. All rights reserved.
//

#import "SCCircularRefreshView.h"
#import "DACircularProgressView.h"
#import "UIView+frame.h"
//获取屏幕宽高
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)


static NSString* const kRotationAnimation = @"RotationAnimation";
//static NSInteger const CircleWidth = 25;

@interface SCCircularRefreshView ()

@property (nonatomic, strong) DACircularProgressView *circleView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UIImageView *imageview;

@property (nonatomic, assign) BOOL isRotating;
@property (nonatomic, assign) BOOL endWillCalled;
@property (nonatomic, assign) BOOL isEndingAnimation;

@end

@implementation SCCircularRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isLoadMore = NO;
        
        self.isRotating = NO;
        self.endWillCalled = NO;
        self.isEndingAnimation = NO;
        
        self.circleView = [[DACircularProgressView alloc] init];
        self.circleView.roundedCorners = 3;
        self.circleView.trackTintColor = [UIColor clearColor];
        self.circleView.progressTintColor =[UIColor cyanColor];
        self.circleView.hidden = YES;
        [self addSubview:self.circleView];
        self.circleView.frame = CGRectMake((SCREEN_WIDTH - 100)/2 - 50, self.height - 30, 30, 30);
        UIImageView *imageview = [[UIImageView alloc]init];
        _imageview = imageview;
        [imageview setImage:[UIImage imageNamed:@"appIconThree"]];
        [self.circleView addSubview:imageview];
        imageview.frame = CGRectMake(2, 2, 26, 26);
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 13;
//		[self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.centerY.equalTo(self.mas_centerY);
//			make.centerX.equalTo(self.mas_centerX);
//			make.width.equalTo(@(CircleWidth));
//			make.height.equalTo(@(CircleWidth));
//		}];
        
//        UIImage *loadingImage = [UIImage imageNamed:@"appicon"];
//        loadingImage = [loadingImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.loadingImageView = [[UIImageView alloc] init];
        [self.loadingImageView setImage:[UIImage imageNamed:@"appIconThree"]];
     //   self.loadingImageView.tintColor = [UIColor colorWithRed:0.333 green:0.691 blue:1.000 alpha:1.000];
        self.loadingImageView.layer.masksToBounds = YES;
        
        self.loadingImageView.layer.cornerRadius = 15;
        self.loadingImageView.hidden = YES;
 //       self.loadingImageView.layer.allowsEdgeAntialiasing = YES;
        [self addSubview:self.loadingImageView];
        self.loadingImageView.frame = CGRectMake((SCREEN_WIDTH - 100)/2 - 50, self.bounds.size.height - 30, 30, 30);
//		[self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.centerY.equalTo(@0);
//			make.centerX.equalTo(self.mas_centerX);
//			make.width.equalTo(@(CircleWidth));
//			make.height.equalTo(@(CircleWidth));
//		}];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statTextLabel = label;
        label.frame = CGRectMake((SCREEN_WIDTH - 100)/2, self.height - 30, 100, 30);
		self.circleView.transform = CGAffineTransformMakeRotation(M_PI*2);
		self.loadingImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return self;
}

#pragma mark - Public methods

- (void)setTimeOffset:(CGFloat)timeOffset {
    
    _timeOffset = timeOffset;
    self.circleView.hidden = NO;
    [self.circleView setProgress:timeOffset animated:YES];
    if (self.isRotating) {
        return;
    }
    if (self.isEndingAnimation) {
        return;
    }
    
   
}

- (void)setIsLoadMore:(BOOL)isLoadMore {
    _isLoadMore = isLoadMore;
    
    if (self.isLoadMore) {
		self.circleView.transform = CGAffineTransformMakeRotation(0);
		self.loadingImageView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)beginRefreshing {
    
    self.isRotating = YES;
    
    if (self.isEndingAnimation) {
        return;
    }
    
    [self.loadingImageView.layer addAnimation:[self createRotationAnimation] forKey:kRotationAnimation];

    self.loadingImageView.alpha = 1.0;
    self.circleView.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingImageView.alpha = 1.0;
        self.circleView.alpha = 0.6;
    } completion:^(BOOL finished) {
        self.loadingImageView.hidden = NO;
        self.circleView.hidden = YES;
        self.loadingImageView.alpha = 1.0;
        self.circleView.alpha = 1.0;
    }];

    
}

- (void)endRefreshing {
    
    if (self.isEndingAnimation) {
        return;
    }

    self.isEndingAnimation = YES;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.loadingImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.loadingImageView.hidden = YES;
        self.circleView.hidden = YES;
        self.loadingImageView.alpha = 1.0;
        [self.loadingImageView.layer removeAnimationForKey:kRotationAnimation];
        self.isRotating = NO;
        self.isEndingAnimation = NO;
    }];
}


#pragma mark - Private methods

- (void)didEndEndAnimation {
    
    self.isEndingAnimation = NO;
    self.endWillCalled = NO;
}

- (CAAnimation *)createRotationAnimation {
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [rotationAnimation setValue:kRotationAnimation forKey:@"id"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotationAnimation.duration = 0.8f;
    rotationAnimation.repeatCount = NSUIntegerMax;
    rotationAnimation.speed = 1.0f;
    rotationAnimation.removedOnCompletion = YES;
    
    return rotationAnimation;
}

@end
