//
//  TopLevelItem.h
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationId.h"

@interface TopLevelItem : NSObject {
    NavigationId navItemId;
	NSString *detail;
	NSString *title;
    BOOL indent;
}

-(id)initWithTitleAndDetail:(NSString *)theTitle 
                  navItemId:(NavigationId)inNavItemId 
                     detail:(NSString *)theDetail 
                     indent:(BOOL)inIndent;

@property (nonatomic, assign) NavigationId navItemId;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL indent;
@end