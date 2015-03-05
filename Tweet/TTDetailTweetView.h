//
//  TTDetailTweetView.h
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/4/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface TTDetailTweetView : UIView
@property (nonatomic, strong) TWTRTweetView *detailTweetView;
+ (TTDetailTweetView *) createNewDetailTweetViewWithTweet:(TWTRTweet *)tweet;
- (void) loadViewAnimatedOnView: (UIView *) superView;

@end
