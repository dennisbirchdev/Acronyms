//
//  AAIAcronymItemTableViewCell.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIAcronymItemTableViewCell.h"
#import "UIColor+AAIExtensions.h"

@interface AAIAcronymItemTableViewCell ()


@end

@implementation AAIAcronymItemTableViewCell

- (void)awakeFromNib
{
	self.backgroundColor = [UIColor aai_backgroundColor];

	// use a custom image for the disclosure arrow to better stand out
	UIImage *image = [UIImage imageNamed:@"Disclosure"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	self.accessoryView = imageView;
}

- (void)configureWithAcronymItem:(AAIAcronymItem *)item
{
	self.titleLabel.text = [item.longForm capitalizedStringWithLocale:[NSLocale systemLocale]];
}

@end
