//
//  TTWebViewController.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/5/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTWebViewController.h"

@interface TTWebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) NSTimer *progressTimer;

@end

@implementation TTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progress = 0;
    self.navigationItem.title = @"Link";
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.url) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:urlRequest];
    }
}

- (void) progressTimerFired: (NSTimer *)sender
{
    if (self.progressView.progress >= 0.95) {
        [sender invalidate];
        sender = nil;
        [self.progressView setProgress:0.95 animated:YES];
    }else{
        [self.progressView setProgress:self.progressView.progress + 0.01 animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.progressTimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(progressTimerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSDefaultRunLoopMode];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
    
    if (self.progressView.progress != 1) {
        [self.progressView setProgress:1 animated:YES];
        [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.progressView.alpha = 0;
        } completion:nil];
    }
}

- (void) dealloc
{
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
}

@end
