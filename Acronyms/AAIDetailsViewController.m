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

@interface AAIDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *termLabel;
@property (nonatomic, weak) IBOutlet UILabel *frequencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *sinceLabel;
@property (nonatomic, weak) IBOutlet UIButton *wikipediaButton;

@end

@implementation AAIDetailsViewController

static NSString * const kWikepediaLookupSegue = @"WikepediaLookupSegue";
static NSString * const kSearchTermPlaceholder = @"<SEARCHTERM>";
static NSString * const kWikipediaAPIBaseURL = @"https://en.wikipedia.org/";

- (void)viewDidLoad {
    [super viewDidLoad];

	[self checkWikipediaAvailability];
	self.termLabel.text = [self.detailItem.longForm capitalizedStringWithLocale:[NSLocale systemLocale]];
	self.frequencyLabel.text = [NSString stringWithFormat:@"%ld", self.detailItem.frequency];
	self.sinceLabel.text = [NSString stringWithFormat:@"%ld", self.detailItem.since];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kWikepediaLookupSegue]) {
		AAIWikiMediaViewController *webVC = segue.destinationViewController;
		webVC.lookupTerm = self.detailItem.longForm;
	}
}

- (void)checkWikipediaAvailability
{
	// control the visibility of the "Wikipedia Lookup" depending on whether or not a pre-search finds a source page
	self.wikipediaButton.hidden = YES;
	NSString *searchTerm = [self.detailItem.longForm aai_underScoreString];

	NSURL *wikipediaAPIURL = [NSURL URLWithString:kWikipediaAPIBaseURL];
	AAINetworkSessionManager *wikiManager = [[AAINetworkSessionManager alloc] initWithBaseURL:wikipediaAPIURL];
	NSDictionary *params = @{@"action" : @"query",
							 @"format" : @"json",
							 @"titles" : searchTerm};
	[wikiManager GET:@"w/api.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		if ([responseObject isKindOfClass:[NSDictionary class]]) {
			NSDictionary *dict = responseObject;
			NSDictionary *pagesDict = dict[@"query"][@"pages"];
			NSNumber *pageID = pagesDict.allKeys.firstObject;
			if ([pageID integerValue] > 0) {
				self.wikipediaButton.hidden = NO;
			}
		}
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"Wikipedia API error: %@", [error localizedDescription]);
	}];
}

@end
