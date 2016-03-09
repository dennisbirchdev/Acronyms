//
//  AAIDetailsViewController.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIDetailsViewController.h"
#import "AAIAcronymItem.h"
#import "AAIWikiMediaViewController.h"
#import "NSString+AAIExtensions.h"
#import "AAINetworkSessionManager.h"
#import "UIColor+AAIExtensions.h"
#import "AFNetworking.h"

@interface AAIDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *termLabel;
@property (nonatomic, weak) IBOutlet UILabel *frequencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *sinceLabel;
@property (nonatomic, weak) IBOutlet UIButton *wikipediaButton;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@end

@implementation AAIDetailsViewController

static NSString * const kWikepediaLookupSegue = @"WikepediaLookupSegue";
static NSString * const kWikipediaAPIBaseURL = @"https://en.wikipedia.org/";

#pragma mark - ViewController Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(networkReachabilityChanged:)
												 name:AFNetworkingReachabilityDidChangeNotification
											   object:nil];

	self.view.backgroundColor = [UIColor aai_backgroundColor];
	
	[self checkWikipediaAvailability];
	
	// populate the view
	self.termLabel.text = [self.detailItem.longForm capitalizedStringWithLocale:[NSLocale systemLocale]];
	self.frequencyLabel.text = [NSString stringWithFormat:@"%ld", self.detailItem.frequency];
	self.sinceLabel.text = [NSString stringWithFormat:@"%ld", self.detailItem.since];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kWikepediaLookupSegue]) {
		AAIWikiMediaViewController *webVC = segue.destinationViewController;
		webVC.lookupTerm = self.detailItem.longForm;
	}
}

#pragma mark - Helpers

- (void)checkWikipediaAvailability
{
	// control the visibility of the "Wikipedia Lookup" button depending on whether or not a pre-search finds a source page
	self.wikipediaButton.hidden = YES;
	
	// keep it hidden and bail if we don't have network connectivity
	if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus < AFNetworkReachabilityStatusReachableViaWWAN) {
		return;
	}
	
	NSURL *wikipediaAPIURL = [NSURL URLWithString:kWikipediaAPIBaseURL];
	
	// perform a query on the Wikipedia API with a custom instance of the network manager
	AAINetworkSessionManager *wikiManager = [[AAINetworkSessionManager alloc] initWithBaseURL:wikipediaAPIURL];

	NSString *searchTerm = [self.detailItem.longForm aai_underScoreString];
	NSDictionary *params = @{@"action" : @"query",
							 @"format" : @"json",
							 @"titles" : searchTerm};
	[wikiManager GET:@"w/api.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			NSDictionary *dict = responseObject;
			// take apart the response to see if we received a reference to a Wikipedia page
			NSDictionary *pagesDict = dict[@"query"][@"pages"];
			NSNumber *pageID = pagesDict.allKeys.firstObject;
			if ([pageID integerValue] > 0) {
				// if there is a page reference, we want to show the Wikipedia Lookup button
				self.wikipediaButton.hidden = NO;
			}
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"Wikipedia API error: %@", [error localizedDescription]);
	}];
}

#pragma mark - Notifications

- (void)networkReachabilityChanged:(NSNotification *)notification
{
	self.networkStatus = (AFNetworkReachabilityStatus)[notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
	if (self.networkStatus < AFNetworkReachabilityStatusReachableViaWWAN) {
		// disable the Wikipedia Lookup button when we don't have network reachability
		self.wikipediaButton.enabled = NO;
	} else {
		// if connectivity has been restored, check for a Wikipedia page again
		[self checkWikipediaAvailability];
	}
}


@end
