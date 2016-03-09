//
//  AAIAcronymLookupViewController.m
//  Acronyms
//
//  Created by Dennis Birch on 3/2/16.
//  Copyright (c) 2016 Dennis Birch. All rights reserved.
//

#import "AAIAcronymLookupViewController.h"
#import "AAIDataManager.h"
#import "AAIResultsTableViewController.h"
#import "AAIActivityIndicatorManager.h"
#import "AFNetworking.h"
#import "UIColor+AAIExtensions.h"

@interface AAIAcronymLookupViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *termField;
@property (nonatomic, weak) IBOutlet UIButton *lookupButton;

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

@end

@implementation AAIAcronymLookupViewController

static NSString * const kDisplayResultsSegue = @"DisplayResultsSegue";

- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor aai_backgroundColor];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(textFieldValueChanged:)
												 name:UITextFieldTextDidChangeNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(networkReachabilityChanged:)
												 name:AFNetworkingReachabilityDidChangeNotification
											   object:nil];
	}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// when we're on this view, use the "full title"
	self.title = NSLocalizedString(@"Acronym Lookup", nil);
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	// when we pop on the list view, use an abbreviated title
	self.title = NSLocalizedString(@"Lookup", nil);
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}




#pragma mark - Actions

- (IBAction)lookupButtonTapped:(id)sender
{
	// show the user we're working on their request
	NSString *pleaseWait = NSLocalizedString(@"Please wait", nil);
	[[AAIActivityIndicatorManager sharedInstance] displayIndicatorInView:self.view withText:pleaseWait];
	
	[self.termField resignFirstResponder];
	
	__weak typeof(self) weakSelf = self;
	
	[AAIDataManager lookupEntry:self.termField.text completion:^(NSArray *results, NSError *error) {

		// we've received a respons or an error, so dismiss the activity indicator
		[[AAIActivityIndicatorManager sharedInstance] dismisssIndicator];
		
		if (error != nil) {
			NSLog(@"Error fetching term \"%@\": %@", weakSelf.termField.text, [error localizedDescription]);
			// show error message to user
			[weakSelf showFetchErrorMessage];
			return;
		}
		
		NSLog(@"Acronym lookup results count: %ld", results.count);

		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf != nil) {
			if (results.count == 0) {
				[strongSelf showNoResultsMessageForTerm:weakSelf.termField.text];
				return;
			}
			
			// display the results in the resultsTableViewController
			[strongSelf performSegueWithIdentifier:kDisplayResultsSegue sender:results];
		}
	}];
}

#pragma mark - Alerts

- (void)showFetchErrorMessage
{
	NSString *title = NSLocalizedString(@"Error", nil);
	NSString *message = NSLocalizedString(@"We experienced an unexpected error while attempting this lookup. Please try again later.", nil);
	[self showBasicAlertWithTitle:title message:message];
}

- (void)showNoInternetAvailableAlert
{
	NSString *title = NSLocalizedString(@"No Internet Connection", nil);
	NSString *message = NSLocalizedString(@"You are not connected to the Internet. Please try again later.", nil);
	[self showBasicAlertWithTitle:title message:message];
}

- (void)showNoResultsMessageForTerm:(NSString *)term
{
	NSString *title = NSLocalizedString(@"No Results", nil);
	NSString *localizedString = NSLocalizedString(@"There were no results for the term \"%@\".", nil);
	NSString *message = [NSString localizedStringWithFormat:localizedString, term];
	[self showBasicAlertWithTitle:title message:message];
}


- (void)showBasicAlertWithTitle:(NSString *)title message:(NSString *)message
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kDisplayResultsSegue]) {
		NSParameterAssert([sender isKindOfClass:[NSArray class]]);
		AAIResultsTableViewController *resultsVC = segue.destinationViewController;
		resultsVC.data = sender;
	}
}

#pragma mark - Notifications

- (void)textFieldValueChanged:(NSNotification *)notification
{
	UITextField *textField = notification.object;
	self.lookupButton.enabled = textField.text.length > 0 &&
		self.networkStatus >= AFNetworkReachabilityStatusReachableViaWWAN;
}

- (void)networkReachabilityChanged:(NSNotification *)notification
{
	// enable the Lookup button by default
	self.lookupButton.enabled = self.termField.text.length > 0;
	
	self.networkStatus = (AFNetworkReachabilityStatus)[notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
	NSLog(@"Network reachability changed to: %ld", self.networkStatus);
	if (self.networkStatus < AFNetworkReachabilityStatusReachableViaWWAN) {
		NSLog(@"Not connected to the Internet.");
		[self showNoInternetAvailableAlert];
		// disable the Lookup button when we don't have network reachability
		self.lookupButton.enabled = NO;
	}
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// handle Return key tap as Lookup button tap
	[self lookupButtonTapped:nil];
	return YES;
}

@end
