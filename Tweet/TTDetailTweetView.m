//
//  TTDetailTweetView.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/4/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTDetailTweetView.h"

@interface TTDetailTweetView() <TWTRTweetViewDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIButton *doneButton;
@end

@implementation TTDetailTweetView

+ (TTDetailTweetView *) createNewDetailTweetViewWithTweet:(TWTRTweet *)tweet
{
    TTDetailTweetView *view = [[TTDetailTweetView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    // Background view
    UIView *backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    
    // Tap gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(handleTapGestureRecognizer:)];
    [backgroundView addGestureRecognizer:tap];
    view.tapGestureRecognizer = tap;
    [view addSubview:backgroundView];
    
    // Tweet detail view
    view.tweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
    view.tweetView.layer.borderColor = [[UIColor clearColor]CGColor];
    view.tweetView.center = view.center;
    [view addSubview:view.tweetView];
    
    // Gradient view
    NSArray *colors = @[(id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor,
                        (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor,
                        (id)[UIColor clearColor].CGColor];
    
    NSArray *locations = @[@0, @0.1, @0.2, @0.3, @0.4, @0.6, @0.9];
    
    CAGradientLayer *topGradientLayer = [CAGradientLayer layer];
    topGradientLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    topGradientLayer.colors = colors;
    topGradientLayer.locations = locations;
    
    UIView *topGradientView = [UIView new];
    topGradientView.frame = topGradientLayer.frame;
    topGradientView.backgroundColor = [UIColor clearColor];
    [topGradientView.layer insertSublayer:topGradientLayer atIndex:0];
    topGradientView.userInteractionEnabled = NO;
    [view addSubview:topGradientView];
    
    // Done button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.layer.cornerRadius = 4.0;
    doneButton.layer.borderWidth = 1.0;
    doneButton.layer.borderColor = [[UIColor groupTableViewBackgroundColor]CGColor];
    doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-medium" size:13];
    doneButton.frame = CGRectMake(0, 0, 56, 28);
    doneButton.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen]bounds]) - 15 - CGRectGetWidth(doneButton.frame)/2.0, CGRectGetHeight(doneButton.frame) + 12);
    [doneButton addTarget:view action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneButton];
    view.doneButton = doneButton;
    
    return view;
}

- (void) handleTapGestureRecognizer: (UITapGestureRecognizer *) sender
{
    [self dismissViewAnimated];
}

- (void)tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url
{
    [self.delegate didTapOnDetailTweetViewURL:url];
    [self dismissViewAnimated];
}

- (void) loadViewAnimatedOnView: (UIView *) superView
{
    self.backgroundColor = [UIColor clearColor];
    self.tweetView.alpha = 0;
    self.doneButton.alpha = 0;
    [self.tweetView setTransform:CGAffineTransformMakeScale(0.88, 0.88)];
    [superView addSubview:self];
    self.tweetView.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    } completion:nil];
    
    [UIView animateWithDuration:0.4 delay:0.08 usingSpringWithDamping:0.6 initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        weakSelf.tweetView.alpha = 1;
        [weakSelf.tweetView setTransform:CGAffineTransformIdentity];
        weakSelf.doneButton.alpha = 1;
    } completion:nil];
}

- (void) doneButtonPressed
{
    [self dismissViewAnimated];
}

- (void) dismissViewAnimated
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
