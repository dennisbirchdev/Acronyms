//
//  AAINetworkSessionManager.h
//  
//
//  Created by Dennis Birch on 3/3/16.
//
//

#import "AFHTTPSessionManager.h"

@interface AAINetworkSessionManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

@end
