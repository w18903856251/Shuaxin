//
//  SCRefreshView.h
//  jianzhiweishi
//
//  Created by snow on 15/6/1.
//  Copyright (c) 2015年 yojianzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCRefreshView : UIView
{
	BOOL _isLoadMore;
	CGFloat _timeOffset;
}

@property (nonatomic, assign) BOOL isLoadMore;
/**
 *  圆的弧度
 */
@property (nonatomic, assign) CGFloat timeOffset;  // 0.0 ~ 1.0

- (void)beginRefreshing;
- (void)endRefreshing;

@end
