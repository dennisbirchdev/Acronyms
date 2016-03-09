//
//  AAIActivityIndicatorManager.m
//  Acronyms
//
//  Created by Dennis Birch on 3/9/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIActivityIndicatorManager.h"
#import "MBProgressHud.h"

@interface AAIActivityIndicatorManager ()

@property (nonatomic, strong) MBProgressHUD *activityIndicator;

@end

@implementation AAIActivityIndicatorManager

+ (instancetype)sharedInstance
{
	static AAIActivityIndicatorManager *instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [self new];
	});
	
	return instance;
}

- (void)displayIndicatorInView:(UIView *)view withText:(NSString *)text
{
	// only show one at a time!!
	if (self.activityIndicator != nil) {
		return;
	}

	// prepare indicator
	MBProgressHUD *indicator = [[MBProgressHUD alloc] initWithView:view];
	indicator.detailsLabel.text = text;
	[view addSubview:indicator];
	
	self.activityIndicator = indicator;
	
	dispatch_async(dispatch_get_main_queue(), ^{
		// show it on the main queue
		[indicator showAnimated:YES];
	});
}


- (void)dismisssIndicator
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.activityIndicator hideAnimated:YES];
		self.activityIndicator = nil;
	});
}

@end
