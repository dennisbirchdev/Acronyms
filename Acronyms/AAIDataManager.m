//
//  AAIDataManager.m
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import "AAIDataManager.h"
#import "AAINetworkSessionManager.h"
#import "AAIAcronymItem.h"

@implementation AAIDataManager

+ (void)lookupEntry:(NSString *)entry completion:(void (^) (NSArray *results, NSError *error)) completion
{
	NSParameterAssert(entry.length > 0);
	
	NSDictionary *params = @{@"sf" : entry};
	
	[[AAINetworkSessionManager sharedInstance] GET:@""
										parameters:params
										  progress:nil // connect to HUD
										   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
											   NSMutableArray *output = [NSMutableArray new];
											   NSArray *contentArray = responseObject;
											   NSDictionary *content = contentArray.firstObject;
											   contentArray = content[@"lfs"];
											   for (NSDictionary *item in contentArray) {
												   AAIAcronymItem *acronym = [[AAIAcronymItem alloc] initWithLFContent:item];
												   [output addObject:acronym];
											   }
											   
											   completion([output copy], nil);
										   }
										   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
											   // failure code
											   NSLog(@"Failed with error: %@", [error localizedDescription]);
											   completion(nil, error);
										   }];
}

@end

/*
 
 
 Acromine REST Service (Request Access)
 
 Acromine REST Service provides a RESTful interface, where you can use the Acromine dictionary from your client programs.
 Client sample
 
 The response from the service for the abbreviation "HMM"
 JavaScript with prototype.js [View source] [Run]
 Python 2.6 or later (with JSON support) [View source] [Run]
 
 Acromine REST API
 
 This Web service receives a query abbreviation or fullform as parameters, and returns abbreviation definitions in JSON format.
 Request URL (GET)
 
 To obtain abbreviation definitions, send an HTTP GET request to the following URL:
 
 http://www.nactem.ac.uk/software/acromine/dictionary.py
 
 Request parameters
 
 This table explains the parameters for the service.
 Name 	Type 	Description
 sf 	string 	Abbreviation for which definitions are to be retrieved.
 lf 	string 	Fullforms for which abbreviations to be retrieved.
 Response
 
 The service returns an array in JSON format. Each element in the array consists of the following members:
 Name 	Type 	Description
 sf 	string 	Abbreviation.
 lfs 	array of longform objects 	The array of longforms associated with the shortform.
 
 Longform objects have the following members:
 Name 	Type 	Description
 lf 	string 	Representative form of the full form.
 freq 	integer 	The number of occurrences of the definition in the corpus.
 since 	integer 	The year when the definition appeared for the first time in the corpus.
 vars 	array of variation objects 	An array of variation objects that gather surface expressions of the full form in the corpus.
 
 Variation objects have the following members:
 Name 	Type 	Description
 lf 	string 	The surface form of the full form.
 freq 	integer 	The number of occurrences of the surface form in the abbreviation definition in the corpus.
 since 	integer 	The year when the surface form appeared for the first time in the corpus.
 
 JISC
 */
