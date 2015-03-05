//
//  TTLoginOnboardingView.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/3/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTLoginOnboardingView.h"

@implementation TTLoginOnboardingView


+ (TTLoginOnboardingView *) createNewLoginOnboardingViewWithUsername: (NSString *) username
{
    TTLoginOnboardingView *newView = [[[NSBundle mainBundle] loadNibNamed:@"TTLoginOnboardingView" owner:self options:nil] objectAtIndex:0];
    newView.frame = [[UIScreen mainScreen] bounds];
    newView.welcomeLabel.text = [NSString stringWithFormat:@"Welcome\n@%@", username];
    return newView;
}

- (void) loadViewAnimatedOnView:(UIView *)superView
{
    self.alpha = 0;
    self.activityIndicator.alpha = 0;
    [superView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(showActivityIndicator) withObject:nil afterDelay:0.5];
    }];
}

- (void) showActivityIndicator
{
    [self.activityIndicator startAnimating];
    [UIView animateWithDuration:0.3 animations:^{
        self.activityIndicator.alpha = 1;
    }];
}

@end
