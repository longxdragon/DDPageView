//
//  DDPageView.m
//  DDPageView
//
//  Created by longxdragon on 2017/7/4.
//  Copyright © 2017年 longxdragon. All rights reserved.
//

#import "DDPageView.h"

@interface DDPageView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageNumbers;
@property (nonatomic, strong) NSMutableDictionary *reusedControllers;
@end

@implementation DDPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configueValues];
        [self configueViews];
    }
    return self;
}

- (void)configueValues {
    _activeIndex = 0;
    _activeController = nil;
}

- (void)configueViews {
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Reset all subviews
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.pageNumbers, 0);
    for (UIView *subView in self.scrollView.subviews) {
        NSInteger index = [self.scrollView.subviews indexOfObject:subView];
        subView.frame = (CGRect){{self.scrollView.frame.size.width * index, 0}, self.scrollView.frame.size};
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self reloadData];
}

- (void)showViewControllerAtIndex:(NSInteger)index {
    [self.activeController willMoveToParentViewController:nil];
    [self.activeController removeFromParentViewController];
    [self.activeController didMoveToParentViewController:nil];
    
    if (index < self.pageNumbers) {
        UIViewController *viewController = nil;
        
        // Get ViewController from cache
        UIViewController *cacheController = [self.reusedControllers objectForKey:@(index)];
        if (cacheController) {
            viewController = cacheController;
        } else {
            if ([self.dataSource respondsToSelector:@selector(viewControllerAtIndex:)]) {
                viewController = [self.dataSource viewControllerAtIndex:self.activeIndex];
            }
            // Cache current ViewController
            if (viewController) {
                [self.reusedControllers setObject:viewController forKey:@(index)];
            }
        }
        
        if (viewController) {
            [viewController willMoveToParentViewController:self.containerViewController];
            [self.containerViewController addChildViewController:viewController];
            [viewController didMoveToParentViewController:self.containerViewController];
            
            UIView *view = viewController.view;
            if ([self.scrollView.subviews containsObject:view]) {
                return;
            }
            view.frame = (CGRect){{self.scrollView.frame.size.width * index, 0}, self.scrollView.frame.size};
            [self.scrollView addSubview:view];
        }
    }
}

#pragma mark - Public
- (void)reloadData {
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfViewControllersInPageView)]) {
        number = [self.dataSource numberOfViewControllersInPageView];
    }
    self.pageNumbers = number;
    
    [self showViewControllerAtIndex:self.activeIndex];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width * number, 0)];
}

- (void)scrollToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated {
    self.activeIndex = index;
    
    CGPoint p = CGPointMake(self.scrollView.frame.size.width * index, 0);
    [self.scrollView setContentOffset:p animated:animated];
    [self showViewControllerAtIndex:self.activeIndex];
}

#pragma mark - Property Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (NSMutableDictionary *)reusedControllers {
    if (!_reusedControllers) {
        _reusedControllers = [NSMutableDictionary dictionary];
    }
    return _reusedControllers;
}

@end
