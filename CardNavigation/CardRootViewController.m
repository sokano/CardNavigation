//
//  CardRootViewController.m
//  CardNavigation
//
//  Created by Steve Okano on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardRootViewController.h"
#import "MenuViewController.h"
#import "CardScrollViewController.h"

@interface UIViewExt : UIView {} 
@end


@implementation UIViewExt
- (UIView *) hitTest: (CGPoint) pt withEvent: (UIEvent *) event 
{   
	
	UIView* viewToReturn=nil;
	CGPoint pointToReturn;
	
    
	UIView* uiLeftView = (UIView*)[[self subviews] objectAtIndex:1];
    
	if ([uiLeftView subviews] != nil && [[uiLeftView subviews] objectAtIndex:0]) {
		
		UIView* uiScrollView = [[uiLeftView subviews] objectAtIndex:0];	
		
		if ([[uiScrollView subviews] objectAtIndex:0]) {	 
			
			UIView* uiMainView;
            if ([[uiScrollView subviews] count] <= 1)
                uiMainView = [[uiScrollView subviews] objectAtIndex:0];	
            else
                uiMainView = [[uiScrollView subviews] objectAtIndex:1];
			
			for (UIView* subView in [uiMainView subviews]) {
				CGPoint point  = [subView convertPoint:pt fromView:self];
				if ([subView pointInside:point withEvent:event]) {
					viewToReturn = subView;
					pointToReturn = point;
				}
				
			}
		}
		
	}
	
	if(viewToReturn != nil) {
		return [viewToReturn hitTest:pointToReturn withEvent:event];		
	}
	
	return [super hitTest:pt withEvent:event];
	
}

@end

static NSString* const IQ_CARD_DROP_ANIMATION_KEYPATH = @"transform.rotation.z";
static NSString* const IQ_CARD_DROP_ANIMATION_KEY = @"IQ_CARD_DROP_ANIMATION_KEY";
static CGFloat const IQ_CARD_DROP_ANIMATION_DURATION = 0.1;
static double const PI = 3.14159265358979323846264338327950288;

@implementation CardRootViewController
@synthesize cardScrollViewController;
@synthesize menuViewController;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {		
        
    }
    return self;
}

-(void)viewDidUnload
{
    self.menuViewController = nil;
    self.cardScrollViewController = nil;
    [rootView removeFromSuperview];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	rootView = [[UIViewExt alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
	rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	[rootView setBackgroundColor:[UIColor clearColor]];
	
    leftMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MENUVIEW_WIDTH, 1024)];
	self.menuViewController = [[MenuViewController alloc]
                          init];
	self.menuViewController.view.frame = CGRectMake(0, 0, leftMenuView.frame.size.width, leftMenuView.frame.size.height);
    
	[menuViewController.view setBackgroundColor:[UIColor whiteColor]];
    [menuViewController viewDidLoad];
	[leftMenuView addSubview:menuViewController.view];
	
	rightSlideView = [[UIView alloc] initWithFrame:CGRectMake(leftMenuView.frame.size.width, 0, rootView.frame.size.width - leftMenuView.frame.size.width, rootView.frame.size.height)];
	rightSlideView.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	self.cardScrollViewController = [[CardScrollViewController alloc] init];
	[cardScrollViewController.view setFrame:CGRectMake(0, 0, rightSlideView.frame.size.width, rightSlideView.frame.size.height)];
	[cardScrollViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight];    
	[rightSlideView addSubview:cardScrollViewController.view];
	
	[rootView addSubview:leftMenuView];
	[rootView addSubview:rightSlideView];
	self.view.backgroundColor = [[UIColor scrollViewTexturedBackgroundColor] colorWithAlphaComponent:0.5];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth + UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:rootView];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    [menuViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    [cardScrollViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    return YES;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [menuViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [cardScrollViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[cardScrollViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [menuViewController viewWillAppear:animated];
    [cardScrollViewController viewDidAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [menuViewController viewDidAppear:animated];
    [cardScrollViewController viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [menuViewController viewWillDisappear:animated];
    [cardScrollViewController viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [menuViewController viewDidDisappear:animated];
    [cardScrollViewController viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
