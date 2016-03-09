//
//  AAIResultsTableViewController.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIResultsTableViewController.h"
#import "AAIAcronymItemTableViewCell.h"
#import "AAIDetailsViewController.h"
#import "AAIAcronymItem.h"
#import "UIColor+AAIExtensions.h"

@interface AAIResultsTableViewController ()

@property (nonatomic, weak) IBOutlet UILabel *resultsLabel;

@end

@implementation AAIResultsTableViewController

static NSString * const kShowDetailSegue = @"ShowDetailSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.backgroundColor = [UIColor aai_backgroundColor];
	
	// make the table view cells resizable
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 44.0;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSString *localizedString = NSLocalizedString(@"Lookup term: %@", nil);
	NSString *termLabelText = [NSString localizedStringWithFormat:localizedString, self.lookupTerm];
	self.resultsLabel.text = termLabelText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	AAIAcronymItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	[cell configureWithAcronymItem:self.data[indexPath.row]];
	
	return cell;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:kShowDetailSegue]) {
		AAIDetailsViewController *detailVC = segue.destinationViewController;
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		detailVC.detailItem = self.data[indexPath.row];
	}
}


@end
