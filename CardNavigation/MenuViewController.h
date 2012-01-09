//
//  MenuViewController.h
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftPaneController.h"

extern const CGFloat MENUVIEW_WIDTH;

@interface MenuViewController : UIViewController {
    LeftPaneController *leftPaneController;
    UIView *navigationView;
}

@property (nonatomic, strong) LeftPaneController *leftPaneController;

+(CGRect)defaultRectWithOrientation:(UIInterfaceOrientation)orientation;

@end
