//
//  AAIActivityIndicatorManager.h
//  Acronyms
//
//  Created by Dennis Birch on 3/9/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAIActivityIndicatorManager : NSObject

+ (instancetype)sharedInstance;
- (void)displayIndicatorInView:(UIView *)view withText:(NSString *)text;
- (void)dismisssIndicator;

@end
