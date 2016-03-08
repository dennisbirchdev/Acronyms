//
//  AAIAcronymItemTableViewCell.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIAcronymItemTableViewCell.h"

@interface AAIAcronymItemTableViewCell ()


@end

@implementation AAIAcronymItemTableViewCell


- (void)configureWithAcronymItem:(AAIAcronymItem *)item
{
	self.titleLabel.text = [item.longForm capitalizedStringWithLocale:[NSLocale systemLocale]];
}

@end
