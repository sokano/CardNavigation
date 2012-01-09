//
//  CardRootViewController.h
//  CardNavigation
//
//  Created by Steve Okano on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardScrollViewController.h"
#import "MenuViewController.h"
@class UIViewExt;

@interface CardRootViewController : UIViewController {
    UIViewExt* rootView;
	UIView* leftMenuView;
	UIView* rightSlideView;
	
	MenuViewController* menuViewController;
	CardScrollViewController* cardScrollViewController;
	
}

@property (nonatomic, strong) MenuViewController* menuViewController;
@property (nonatomic, strong) CardScrollViewController* cardScrollViewController;

@end
