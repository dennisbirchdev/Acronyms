//
//  AAIDataManager.h
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAIDataManager : NSObject

+ (void)lookupEntry:(NSString *)entry completion:(void (^) (NSArray *results, NSError *error)) completion;

@end
