//
//  TTDetailTweetView.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/4/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTDetailTweetView.h"

@implementation TTDetailTweetView


+ (TTDetailTweetView *) createNewDetailTweetViewWithTweet:(TWTRTweet *)tweet
{
    // Tweet detail view
    TTDetailTweetView *view = [[TTDetailTweetView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.detailTweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
    view.detailTweetView.layer.borderColor = [[UIColor clearColor]CGColor];
    view.detailTweetView.center = view.center;
    [view addSubview:view.detailTweetView];
    
    // Gradient view
    NSArray *colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor,
                        (id)[UIColor clearColor].CGColor];
    
    NSArray *locations = @[@0, @0.2, @0.4, @0.6, @0.9];
    
    CAGradientLayer *topGradientLayer = [CAGradientLayer layer];
    topGradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    topGradientLayer.colors = colors;
    topGradientLayer.locations = locations;
    
    UIView *topGradientView = [UIView new];
    topGradientView.frame = topGradientLayer.frame;
    topGradientView.backgroundColor = [UIColor clearColor];
    [topGradientView.layer insertSublayer:topGradientLayer atIndex:0];
    [view addSubview:topGradientView];
    
    // Done button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.layer.cornerRadius = 4.0;
    doneButton.layer.borderWidth = 1.0;
    doneButton.layer.borderColor = [[UIColor whiteColor]CGColor];
    doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-medium" size:13];
    doneButton.frame = CGRectMake(0, 0, 56, 28);
    doneButton.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen]bounds]) - 15 - CGRectGetWidth(doneButton.frame)/2.0, CGRectGetHeight(doneButton.frame) + 12);
    [doneButton addTarget:view action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneButton];
    
    return view;
}

- (void) loadViewAnimatedOnView: (UIView *) superView
{
    self.backgroundColor = [UIColor clearColor];
    self.detailTweetView.alpha = 0;
    [self.detailTweetView setTransform:CGAffineTransformMakeScale(0.85, 0.85)];
    [superView addSubview:self];
    
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    } completion:nil];
    
    [UIView animateWithDuration:0.4 delay:0.08 usingSpringWithDamping:0.7 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.detailTweetView.alpha = 1;
        [weakSelf.detailTweetView setTransform:CGAffineTransformIdentity];
    } completion:nil];
}

- (void) doneButtonPressed
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
