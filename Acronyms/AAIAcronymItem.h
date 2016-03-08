//
//  AAIAcronymItem.h
//  Acronyms
//
//  Created by Dennis Birch on 3/8/16.
//  Copyright © 2016 Dennis Birch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAIAcronymItem : NSObject

@property (nonatomic, copy) NSString *longForm;
@property (nonatomic, assign) NSInteger frequency;
@property (nonatomic, assign) NSInteger since;

- (instancetype)initWithLFContent:(NSDictionary *)content;

@end
