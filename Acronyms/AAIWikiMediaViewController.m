//
//  AAIWikiMediaViewController.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIWikiMediaViewController.h"
#import "MBProgressHUD.h"
#import "NSString+AAIExtensions.h"

@interface AAIWikiMediaViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation AAIWikiMediaViewController

static NSString * const kBaseURL = @"https://en.wikipedia.org/wiki/";

- (void)viewDidLoad {
    [super viewDidLoad];
	
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
	[MBProgressHUD showHUDAddedTo:self.view animated: YES];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
