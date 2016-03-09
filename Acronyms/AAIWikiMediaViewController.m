//
//  AAIWikiMediaViewController.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIWikiMediaViewController.h"
#import "AAIActivityIndicatorManager.h"
#import "NSString+AAIExtensions.h"
#import "UIColor+AAIExtensions.h"

@interface AAIWikiMediaViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIView *overlay;

@end

@implementation AAIWikiMediaViewController

static NSString * const kBaseURL = @"https://en.wikipedia.org/wiki/";

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.overlay.backgroundColor = [UIColor aai_backgroundColor];
	
	self.webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// load the Wikipedia page for our term
	NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:[self.lookupTerm aai_underScoreString]]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	
	// and show an activity indicator until it finishes loading
	NSString *loading = NSLocalizedString(@"Loading...", nil);
	[[AAIActivityIndicatorManager sharedInstance] displayIndicatorInView:self.overlay withText:loading];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[AAIActivityIndicatorManager sharedInstance] dismisssIndicator];
	// fade out the overlay
	[UIView animateWithDuration:0.2 animations:^{
		self.overlay.alpha = 0;
	}];
}

@end
