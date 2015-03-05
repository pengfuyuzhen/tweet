//
//  TTMainViewController.m
//  Tweet
//
//  Created by Peng Fuyuzhen on 3/3/15.
//  Copyright (c) 2015 Peng Fuyuzhen. All rights reserved.
//

#import "TTMainViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "TTLoginViewController.h"
#import "AppDelegate.h"
#import "TTDetailTweetView.h"

static NSString * const TweetTableReuseIdentifier = @"TweetCell";

@interface TTMainViewController () <TTLoginViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TWTRTweetViewDelegate>
@property (nonatomic, strong) TTLoginViewController *loginViewController;
@property (nonatomic, strong) NSArray *tweets;
@end

@implementation TTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Style the nav bar title
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter_logo"]];
    
    // Setup tableview
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension; // Explicitly set on iOS 8 if using automatic row height calculation
    self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    self.tableView.tableFooterView = [UIView new];
    
    // Create refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(downloadTweets)
                  forControlEvents:UIControlEventValueChanged];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Ask user to login if hasn't done so already
    if (![[[Twitter sharedInstance] session] authToken]) {
        self.loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TTLoginViewController"];
        self.loginViewController.delegate = self;
        [self presentViewController:self.loginViewController animated:YES completion:nil];
    }
}

#pragma mark TTLoginViewController delegate methods

- (void) loggedIn {
    [self downloadTweets];
}

#pragma mark Compose Tweets

- (IBAction)composeButtonPressed:(id)sender {
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer showWithCompletion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultDone) {
            NSLog(@"Sending Tweet!");
            
            // TODO:
            // reload tweets
        }
    }];
}

#pragma mark Load Tweets

- (void) downloadTweets
{
    NSString *endPoint = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    NSDictionary *params = @{@"id" : [[[Twitter sharedInstance] session] userID]};
    NSError *clientError;
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient]
                             URLRequestWithMethod:@"GET"
                             URL:endPoint
                             parameters:params
                             error:&clientError];

    __weak typeof(self) weakSelf = self;
    if (request) {
        [[[Twitter sharedInstance] APIClient]
         sendTwitterRequest:request
         completion:^(NSURLResponse *response,
                      NSData *data,
                      NSError *connectionError) {
             if (data) {
                 NSError *jsonError;
                 NSDictionary *json = (NSDictionary *)[NSJSONSerialization
                                       JSONObjectWithData:data
                                       options:0
                                       error:&jsonError];
                 
                 NSMutableArray *IDs = [[NSMutableArray alloc] init];
                 for (id tweet in json){
                     if (tweet) {
                         [IDs addObject:[tweet objectForKey:@"id_str"]];
                     }
                 }
                 [weakSelf loadTweetsWithIDs:IDs];
             }
             else {
                 NSLog(@"Error: %@", connectionError);
                 // TODO: show warning UI
                 [weakSelf loadSavedTweets];
             }
         }];
    }
    else {
        NSLog(@"Error: %@", clientError);
        // TODO: show warning UI
        [weakSelf loadSavedTweets];
    }
}

- (void) loadTweetsWithIDs: (NSArray *) IDs
{
    __weak typeof(self) weakSelf = self;
    [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:IDs completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            if ([weakSelf.refreshControl isRefreshing]) {
                [weakSelf.refreshControl endRefreshing];
            }
            typeof(self) strongSelf = weakSelf;
            strongSelf.tweets = tweets;
            [strongSelf.tableView reloadData];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate saveTweets:tweets];
        } else {
            NSLog(@"Failed to load tweet: %@", [error localizedDescription]);
            // TODO: show warning UI
            [weakSelf loadSavedTweets];
        }
    }];
}

- (void) loadSavedTweets
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Tweets" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSError *fetchError = nil;
    NSArray *fetchResults = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError) {
        NSLog(@"Error fetching request: %@, %@", fetchError, fetchError.localizedDescription);
    }else{
        if (fetchResults.count > 0) {
            NSManagedObject *tweet = fetchResults.firstObject;
            self.tweets = [tweet valueForKey:@"data"];
            [self.tableView reloadData];
        }
    }
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
}

# pragma mark - UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweets count];
}

- (TWTRTweetTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.tweets[indexPath.row];
    TWTRTweetTableViewCell *cell = (TWTRTweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
    [cell configureWithTweet:tweet];
    cell.tweetView.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.tweets[indexPath.row];
    return [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
}

# pragma mark TweetViewDelegate methods

- (void)tweetView:(TWTRTweetView *)tweetView didSelectTweet:(TWTRTweet *)tweet{
    TTDetailTweetView *detailView = [TTDetailTweetView createNewDetailTweetViewWithTweet:tweet];
    [detailView loadViewAnimatedOnView:self.navigationController.view];
}

- (void)tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url {
//    // Open your own custom webview
//    MyWebViewController *webViewController = [MyWebViewController alloc] init];
//    
//    // *or* Use a system webview
//    UIViewController *webViewController = [[UIViewController alloc] init];
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewController.view.bounds];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//    webViewController.view = webView;
//    
//    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) prefersStatusBarHidden {
    return NO;
}

@end
