//
//  TTWebViewController.h
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/5/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSURL *url;

@end
