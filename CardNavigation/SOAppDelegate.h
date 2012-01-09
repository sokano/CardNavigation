//
//  SOAppDelegate.h
//  CardNavigation
//
//  Created by Steve Okano on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardRootViewController.h"
#import "MenuViewController.h"
@interface SOAppDelegate : UIResponder <UIApplicationDelegate> {
    CardRootViewController *rootController;
}

@property (strong, nonatomic) UIWindow *window;
+(SOAppDelegate *)appDelegate;
-(void)pushController:(UIViewController *)viewController sender:(UIViewController *)sender;

@end
