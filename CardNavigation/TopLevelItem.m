//
//  TopLevelItem.m
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopLevelItem.h"

@implementation TopLevelItem

@synthesize title;
@synthesize navItemId;
@synthesize detail;
@synthesize indent;

-(id)initWithTitleAndDetail:(NSString *)theTitle 
                  navItemId:(NavigationId)inNavItemId 
                     detail:(NSString *)theDetail
                     indent:(BOOL)inIndent
{
	if ((self = [super init])) {
		title = theTitle;
        navItemId = inNavItemId;
		detail = theDetail;
        indent = inIndent;
    }
	return self;
}

@end