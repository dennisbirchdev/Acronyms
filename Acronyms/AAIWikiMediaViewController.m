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
	
	NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:[self.lookupTerm aai_underScoreString]]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[self.webView loadRequest:request];
	NSString *pleaseWait = NSLocalizedString(@"Please wait", nil);
	[[AAIActivityIndicatorManager sharedInstance] displayIndicatorInView:self.overlay withText:pleaseWait];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[AAIActivityIndicatorManager sharedInstance] dismisssIndicator];
	self.overlay.alpha = 0;
}

@end
