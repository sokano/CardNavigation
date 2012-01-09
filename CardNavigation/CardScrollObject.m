//
//  CardScrollObject.m
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardScrollObject.h"

@implementation CardScrollObject

@synthesize viewController;
@synthesize index;

-(id)initWithController:(UIViewController *)vc andIndex:(NSUInteger)idx
{
    self = [super init];
    if (self) {
        self.viewController = vc;
        self.index = idx;
    }
    return self;
}
@end
