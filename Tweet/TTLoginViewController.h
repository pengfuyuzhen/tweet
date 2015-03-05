//
//  ViewController.h
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/3/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTLoginViewControllerDelegate <NSObject>
- (void) loggedIn;
@end

@interface TTLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *loginButtonContainerView;
@property (weak, nonatomic) id<TTLoginViewControllerDelegate>delegate;
@end

