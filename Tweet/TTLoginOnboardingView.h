//
//  TTLoginOnboardingView.h
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/3/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTLoginOnboardingView : UIView
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

+ (TTLoginOnboardingView *) createNewLoginOnboardingViewWithUsername: (NSString *) username;
- (void) loadViewAnimatedOnView: (UIView *) superView;
@end
