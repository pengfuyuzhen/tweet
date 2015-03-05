//
//  ViewController.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/3/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTLoginViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "TTLoginOnboardingView.h"

@interface TTLoginViewController ()
@property (nonatomic, strong) TTLoginOnboardingView *onboardingView;
@end

@implementation TTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create login button
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            // Show onboarding while load tweets
            [self.delegate loggedIn];
            self.onboardingView = [TTLoginOnboardingView createNewLoginOnboardingViewWithUsername:[session userName]];
            [self.onboardingView loadViewAnimatedOnView:self.view];
            [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:2.5];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);            
        }
    }];
    logInButton.center = CGPointMake(self.view.center.x, CGRectGetHeight(self.loginButtonContainerView.bounds)/2);
    [self.loginButtonContainerView addSubview:logInButton];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.onboardingView removeFromSuperview];
        self.onboardingView = nil;
    }];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

@end
