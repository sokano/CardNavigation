//
//  CardScrollViewController.h
//  CardNavigation
//
//  Created by Steve Okano on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideView.h"

extern const CGFloat SLIDEVIEW_CARD_WIDTH;

@interface CardScrollViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
	
    NSMutableDictionary *viewsToViewControllers;
	SlideView* slideViews;
	
	SlideScrollDirection dragDirection;
    CGFloat startPosition;
    CGPoint lastPosition;
	
}

- (void) addViewInSlider:(UIViewController*)controller invokeByController:(UIViewController*)invokeByController isStackStartView:(BOOL)isStackStartView;
//- (void)bounceBack:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;
- (UIViewController *)popViewController;
@property (nonatomic, retain) UIView* slideViews;
@property (nonatomic, assign) CGFloat slideStartPosition;

-(void)clearView;
-(UIViewController *) popViewController:(UIViewController*)controller;
-(void)showFirstCard;
-(void)showFirstCardWithAnimation:(BOOL)animate;
-(void)setViewControllersFromArray:(NSArray *)controllers;
-(NSArray *)viewControllersArray;
-(BOOL)hasViewController:(UIViewController *)viewController;
@end
