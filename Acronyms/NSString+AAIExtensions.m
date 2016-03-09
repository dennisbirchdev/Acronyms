//
//  NSString+AAIExtensions.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "NSString+AAIExtensions.h"

@implementation NSString (AAIExtensions)

- (NSString *)aai_underScoreString
{
	return [self stringByReplacingOccurrencesOfString:@" " withString:@"_"];
}


@end
