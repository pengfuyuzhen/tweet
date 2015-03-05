//
//  TTMainViewController.h
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/3/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void) downloadTweets;
@end
