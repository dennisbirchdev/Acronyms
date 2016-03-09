//
//  AAIResultsTableViewController.h
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAIResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *lookupTerm;

@end
