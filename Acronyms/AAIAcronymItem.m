//
//  AAIAcronymItem.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIAcronymItem.h"

@implementation AAIAcronymItem

- (instancetype)initWithLFContent:(NSDictionary *)content
{
	self = [super init];
	if (self) {
		_longForm = content[@"lf"];
		_frequency = [content[@"freq"] integerValue];
		_since = [content[@"since"] integerValue];
	}
	
	return self;
}

@end
