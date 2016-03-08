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
#import "MBProgressHUD.h"

@interface AAIAcronymLookupViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *termField;
@property (nonatomic, weak) IBOutlet UIButton *lookupButton;

@property (nonatomic, strong) NSArray *data;

@end

@implementation AAIAcronymLookupViewController

static NSString * const kDisplayResultsSegue = @"DisplayResultsSegue";

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
	self.title = NSLocalizedString(@"Acronym Lookup", nil);
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
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	[self.termField resignFirstResponder];
	
	__weak typeof(self) weakSelf = self;
	
	[AAIDataManager lookupEntry:self.termField.text completion:^(NSArray *results, NSError *error) {
		[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
		if (error != nil) {
			NSLog(@"Error fetching term \"%@\": %@", weakSelf.termField.text, [error localizedDescription]);
			// show error message to user
			[weakSelf showFetchErrorMessage];
			return;
		}
		
		NSLog(@"Acronym lookup results count: %ld", results.count);

		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (strongSelf != nil) {
			strongSelf.data = [NSArray new];
			
			if (results.count == 0) {
				[strongSelf showNoResultsMessageForTerm:weakSelf.termField.text];
				return;
			}
			
			[strongSelf performSegueWithIdentifier:kDisplayResultsSegue sender:results];
		}
	}];
}

#pragma mark - Helpers

- (void)showFetchErrorMessage
{
	NSString *title = NSLocalizedString(@"Error", nil);
	NSString *message = NSLocalizedString(@"We experienced an unexpected error while attempting this lookup. Please try again later.", nil);
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)showNoResultsMessageForTerm:(NSString *)term
{
	NSString *title = NSLocalizedString(@"No Results", nil);
	NSString *localizedString = NSLocalizedString(@"There were no results for the term \"%@\".", nil);
	NSString *message = [NSString localizedStringWithFormat:localizedString, term];
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
	self.lookupButton.enabled = textField.text.length > 0;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// handle Return key tap as Lookup button tap
	[self lookupButtonTapped:nil];
	return YES;
}

@end
