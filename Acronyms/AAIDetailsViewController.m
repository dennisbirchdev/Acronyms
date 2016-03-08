//
//  AAIDetailsViewController.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIDetailsViewController.h"
#import "AAIAcronymItem.h"

@interface AAIDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *termLabel;
@property (nonatomic, weak) IBOutlet UILabel *frequencyLabel;
@property (nonatomic, weak) IBOutlet UILabel *sinceLabel;

@end

@implementation AAIDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.termLabel.text = [self.detailItem.longForm capitalizedStringWithLocale:[NSLocale systemLocale]];
	self.frequencyLabel.text = [NSString stringWithFormat:@"%ld", self.detailItem.frequency];
	self.sinceLabel.text = [NSString stringWithFormat:@"%ld", self.detailItem.since];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
