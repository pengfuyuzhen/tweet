//
//  TTWarningView.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/4/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTWarningView.h"

@implementation TTWarningView

+ (TTWarningView *) createNewWarningViewWithTitle: (NSString *)title
{
    TTWarningView *view = [[[NSBundle mainBundle] loadNibNamed:@"TTWarningView" owner:self options:nil]objectAtIndex:0];
    view.bounds = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen]bounds]), 40);
    view.titleLabel.text = title;
    return view;
}

- (void) showOnView: (UIView *) superView
{
    self.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen]bounds])/2.0, 64.0+CGRectGetHeight(self.bounds)/2.0);
    self.containerView.center = CGPointMake(self.containerView.center.x, -CGRectGetHeight(self.containerView.bounds));
    [superView addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.containerView.center = CGPointMake(weakSelf.containerView.center.x, CGRectGetHeight(weakSelf.bounds)/2.0);
    } completion:^(BOOL finished) {
        [weakSelf performSelector:@selector(dismissView) withObject:nil afterDelay:2.8];
    }];
}

- (void) dismissView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.6 animations:^{
        weakSelf.containerView.center = CGPointMake(weakSelf.containerView.center.x, -CGRectGetHeight(self.containerView.bounds));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
