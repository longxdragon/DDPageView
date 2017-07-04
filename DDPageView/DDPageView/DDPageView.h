//
//  DDPageView.h
//  DDPageView
//
//  Created by longxdragon on 2017/7/4.
//  Copyright © 2017年 longxdragon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDPageView;


@protocol DDPageViewDelegate <NSObject>

- (void)pageView:(DDPageView *)pageView didSelectedAtIndex:(NSInteger)index;

@end




@protocol DDPageViewDataSource <NSObject>

- (NSInteger)numberOfViewControllersInPageView;

- (UIViewController *)viewControllerAtIndex:(NSInteger)index;

@end




@interface DDPageView : UIView

@property (nonatomic, weak) id<DDPageViewDelegate> delegate;
@property (nonatomic, weak) id<DDPageViewDataSource> dataSource;

@property (nonatomic, weak) UIViewController *containerViewController;
@property (nonatomic, assign) NSInteger activeIndex;
@property (nonatomic, strong) UIViewController *activeController;

- (void)reloadData;

- (void)scrollToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
