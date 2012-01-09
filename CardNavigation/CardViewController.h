//
//  CardViewController.h
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationId.h"

@interface CardViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
    NSArray *datasource;
    NavigationId selectedNavItem;
}

@property (nonatomic,strong) IBOutlet UITableView *tableView; 
@property (nonatomic,assign) NavigationId selectedNavItem;
@end
