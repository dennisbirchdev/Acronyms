//
//  AAINetworkSessionManager.m
//  
//
//  Created by Dennis Birch on 3/3/16.
//
//

#import "AAINetworkSessionManager.h"
#import "AFNetworking.h"

static NSString * const kAcronymServiceURI = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";

@implementation AAINetworkSessionManager

- (instancetype)init
{
	NSURL *url = [NSURL URLWithString:kAcronymServiceURI];
	self = [super initWithBaseURL:url];
	if (self) {
		[self addTextPlainContentType];
	}
	
	return self;
}

+ (instancetype)sharedInstance
{
	static AAINetworkSessionManager *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[AAINetworkSessionManager alloc] init];
	});
	
	return sharedInstance;
}

- (void)addTextPlainContentType
{
	AFHTTPResponseSerializer *serializer = self.responseSerializer;
	NSSet *contentTypes = serializer.acceptableContentTypes;
	NSMutableArray *mutableTypes = [[contentTypes allObjects] mutableCopy];
	[mutableTypes addObject:@"text/plain"];
	serializer.acceptableContentTypes = [NSSet setWithArray:[mutableTypes copy]];
}

@end


