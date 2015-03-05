//
//  TTWarningView.h
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/4/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTWarningView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

+ (TTWarningView *) createNewWarningViewWithTitle: (NSString *)title;
- (void) showOnView: (UIView *) superView;
@end
