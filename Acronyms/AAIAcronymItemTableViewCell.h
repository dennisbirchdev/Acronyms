//
//  AAIAcronymItemTableViewCell.h
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAIAcronymItem.h"

@interface AAIAcronymItemTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *titleLabel;

- (void)configureWithAcronymItem:(AAIAcronymItem *)item;

@end
