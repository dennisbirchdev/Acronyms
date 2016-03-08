//
//  AAIAcronymLookupViewController.m
//  Acronyms
//
//  Created by Dennis Birch on 3/2/16.
//  Copyright (c) 2016 Dennis Birch. All rights reserved.
//

#import "AAIAcronymLookupViewController.h"
#import "AAIDataManager.h"
#import "AAIAcronymItem.h"

@interface AAIAcronymLookupViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *termField;
@property (nonatomic, weak) IBOutlet UIButton *lookupButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation AAIAcronymLookupViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//	[super viewDidAppear:animated];
//}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	cell.textLabel.text = self.data[indexPath.row];
	
	return cell;
}

#pragma mark - Actions

- (IBAction)lookupButtonTapped:(id)sender
{
	self.tableView.hidden = YES;
	
	__weak typeof(self) weakSelf = self;
	
	[AAIDataManager lookupEntry:self.termField.text completion:^(NSArray *results, NSError *error) {
		if (error != nil) {
			
			// show error message to user
			
			NSLog(@"Error fetching term \"%@\": %@", weakSelf.termField.text, [error localizedDescription]);
			return;
		}
		
		if (results.count == 0) {
			// show No Results message
		}
		
		NSMutableArray *output = [NSMutableArray new];
		for (AAIAcronymItem *item in results) {
			[output addObject:item.longForm];
		}
		
		if (weakSelf != nil) {
			__strong typeof(weakSelf) strongSelf = weakSelf;
			strongSelf.data = [output copy];
			strongSelf.tableView.hidden = NO;
			[strongSelf.tableView reloadData];
		}
	}];
}

#pragma mark - Notifications

- (void)textFieldValueChanged:(NSNotification *)notification
{
	UITextField *textField = notification.object;
	self.lookupButton.enabled = textField.text.length > 0;
}


@end
