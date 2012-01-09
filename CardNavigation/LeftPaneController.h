//
//  LeftPaneController.h
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationId.h"
extern NSString* const NOTIFICATION_TOP_LEVEL_NAV;

@interface LeftPaneController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	NSArray* navItems;
	UITableView *navTableView;
    NSIndexPath* lastSelectedIndexPath;
    NavigationId initialNavItem;
    NavigationId selectedNavItem;
}

@property (nonatomic, assign) NavigationId initialNavItem;
@property (nonatomic, assign) NavigationId selectedNavItem;

-(void)resetHighlightedLink;

@end
