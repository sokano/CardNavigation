//
//  CardScrollViewController.m
//  CardNavigation
//
//  Created by Steve Okano on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

const CGFloat SLIDEVIEW_CARD_WIDTH = 480.0f;

#import "CardScrollViewController.h"
#import "CardScrollObject.h"

static const CFTimeInterval STACKSCROLLVIEW_CARRYOVER_TIME = 0.5;
static const CGFloat STACKSCROLLVIEW_DAMPING = 0.2;

@interface CardScrollViewController ()

-(void)handlePanFrom:(UIPanGestureRecognizer *)recognizer;
-(UIViewController *)viewControllerForView:(UIView *)slideView;
-(NSInteger)indexForView:(UIView *)slideView;
-(NSArray *)showingViewControllers;
-(NSArray *)allViewControllers;
-(NSValue *)keyForView:(UIView *)view;
-(void)handleViewWillNotification:(NSNotification *)notification;
-(void)handleViewDidNotification:(NSNotification *)notification;
-(void)handleSearchNotification:(NSNotification *)notification;
@end

@implementation CardScrollViewController

@synthesize slideViews, slideStartPosition;


#pragma mark - LifeCycle

-(id)init {
	
	if((self= [super init])) {
		
		viewsToViewControllers = [[NSMutableDictionary alloc] initWithCapacity:10];
		slideViews = [[SlideView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		[slideViews setBackgroundColor:[UIColor clearColor]];
		[self.view setBackgroundColor:[UIColor clearColor]];
        self.view.autoresizesSubviews = YES;
		self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.view.clipsToBounds = NO;
        slideViews.clipsToBounds = NO;
        slideViews.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewWillNotification:) name:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleViewDidNotification:) name:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil];
		
		UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
		[panRecognizer setMaximumNumberOfTouches:1];
		[panRecognizer setDelaysTouchesBegan:YES];
		[panRecognizer setDelaysTouchesEnded:NO];
		[panRecognizer setCancelsTouchesInView:NO];
		[self.view addGestureRecognizer:panRecognizer];
		
		[self.view addSubview:slideViews];
		
	}
	
	return self;
}

-(void)setViewControllersFromArray:(NSArray *)controllers
{
    [viewsToViewControllers removeAllObjects];
    UIViewController *previous = nil;
    for (NSUInteger i = 0; i < [controllers count]; i++) {
        UIViewController *vc = (UIViewController *)[controllers objectAtIndex:i];
        [self addViewInSlider:vc invokeByController:previous isStackStartView:(i == 0)];
        previous = vc;
    }
}

-(NSArray *)viewControllersArray
{
    NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:[viewsToViewControllers count]];
    for (UIView *v in [slideViews subviews]) {
        UIViewController *vc = [self viewControllerForView:v];
        if (vc != nil) {
            [controllers addObject:vc];
        }
    }
    return [NSArray arrayWithArray:controllers];
}

- (void)loadView {
	
	[super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    for (UIViewController * vc in [self showingViewControllers]) {
        [vc viewWillAppear:animated];    
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (UIViewController * vc in [self showingViewControllers]) {
        [vc viewDidAppear:animated];
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UIViewController * vc in [self showingViewControllers]) {
        [vc viewWillDisappear:animated];
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    for (UIViewController * vc in [self showingViewControllers]) {
        [vc viewDidDisappear:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	for (UIViewController* subController in [self allViewControllers]) {
		[subController viewDidUnload];
	}
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - animation/gestures

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [slideViews stopAnimation];
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
	CGPoint translatedPoint = [recognizer translationInView:[self.view superview]];
	
	//CGPoint location =  [recognizer locationInView:self.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            ;           
            [slideViews stopAnimation];
            startPosition = translatedPoint.x;
            lastPosition = translatedPoint;
            break;
        case UIGestureRecognizerStateChanged:
            ;
            if (lastPosition.x > startPosition) {
                slideViews.dragDirection = SlideScrollDirectionRight;
            }
            else {
                slideViews.dragDirection = SlideScrollDirectionLeft;
            }
            slideViews.currentPosition += (lastPosition.x - translatedPoint.x);
            lastPosition = translatedPoint;
            
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            ;
            slideViews.dragDirection = SlideScrollDirectionNone;
            CGPoint velocity = [recognizer velocityInView:[self.view superview]];
            CGFloat newPos = slideViews.currentPosition - (velocity.x * STACKSCROLLVIEW_DAMPING * STACKSCROLLVIEW_CARRYOVER_TIME); 
            [slideViews setPosition:newPos animated:YES duration:STACKSCROLLVIEW_CARRYOVER_TIME withReposition:YES];
            
            break;
        default:
            break;
    }
}

- (void)addViewInSlider:(UIViewController*)controller invokeByController:(UIViewController*)invokeByController isStackStartView:(BOOL)isStackStartView{
	
    
	NSInteger indexToInsert = 0;
    if (isStackStartView) {
        indexToInsert = 0;
    }
    else if ([invokeByController parentViewController])
    {
        indexToInsert = [self indexForView:[[invokeByController parentViewController] view]] + 1;
    }
    else {
        indexToInsert = [self indexForView:[invokeByController view]] + 1;
    }
	
    [viewsToViewControllers setObject:[[CardScrollObject alloc] initWithController:controller andIndex:indexToInsert] forKey:[self keyForView:controller.view]];
    CGRect frame = controller.view.frame;
    frame.size.width = SLIDEVIEW_CARD_WIDTH;
    controller.view.frame = frame;
    [slideViews addViewInSlider:[controller view] atIndex:indexToInsert];
}

-(UIViewController *) popViewController
{
    if ([viewsToViewControllers count] != 0) {
        NSInteger indexToRetrieve = [viewsToViewControllers count] - 1;
        UIViewController *vc = [self viewControllerForView:[slideViews viewWithTag:indexToRetrieve]];
        [slideViews removeViewsUpToIndex:indexToRetrieve];
        
        return vc;
    }
    return nil;
}

-(UIViewController *) popViewController:(UIViewController*)controller
{
    NSUInteger index = [self indexForView:controller.view];
    if(index != NSNotFound)
    {
        [slideViews removeViewsUpToIndex:index];
        
        return controller;
    }
    return nil;
}

#pragma mark -
#pragma mark Rotation support


// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
    [slideViews setViewsHidden:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[slideViews subviews] count])] hidden:YES];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {	
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (UIView * view in [slideViews showingViews]) {
        [[self viewControllerForView:view] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
        [indexes addIndex:view.tag];
    }
    [slideViews setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [slideViews setViewsHidden:indexes hidden:NO];
    [slideViews handlePanEnd];
}

-(void)clearView
{
    
    [slideViews removeViewsUpToIndex:0];
    
    [viewsToViewControllers removeAllObjects];
}

#pragma mark - finding a view controller for a view

-(UIViewController *)viewControllerForView:(UIView *)slideView 
{
    CardScrollObject *stackObj =  (CardScrollObject *)[viewsToViewControllers objectForKey:[self keyForView:slideView]];
    return stackObj.viewController;
}

-(NSInteger)indexForView:(UIView *)slideView
{
    CardScrollObject *stackObj =  (CardScrollObject *)[viewsToViewControllers objectForKey:[self keyForView:slideView]];
    if (stackObj == nil) {
        return NSNotFound;
    }
    return stackObj.index;
}

-(NSArray *)showingViewControllers
{
    NSMutableArray *returned = [NSMutableArray arrayWithCapacity:[viewsToViewControllers count]];
    for (UIView *view in [slideViews showingViews]) {
        [returned addObject:[self viewControllerForView:view]];
    }
    return [NSArray arrayWithArray:returned];
}

-(NSArray *)allViewControllers{
    NSMutableArray *returnedArray = [NSMutableArray arrayWithCapacity:10];
    for (CardScrollObject *scrollObj in [viewsToViewControllers allValues]) {
        [returnedArray addObject:scrollObj.viewController];
    }
    return [NSArray arrayWithArray:returnedArray];
}

-(NSValue *)keyForView:(UIView *)view
{
    return [NSValue valueWithPointer:(__bridge const void *)view];
}

#pragma mark - Methods

-(BOOL) hasViewController:(UIViewController *)viewController
{
    UIViewController *vc;
    vc = [self viewControllerForView:viewController.view];
    if (vc == nil && [viewController parentViewController]) {
        vc = [self viewControllerForView:[[viewController parentViewController] view]];
    }
    return (vc != nil);
}

-(void)handleViewWillNotification:(NSNotification *)notification
{
    UIView *view;
    //NSNumber *isPermanent;
    NSNumber *willHide;
    UIViewController *vc;
    if (notification != nil) {
        view = [notification.userInfo objectForKey:SLIDEVIEW_NOTIFICATION_KEY];
        //isPermanent = [notification.userInfo objectForKey:SLIDEVIEW_NOTIFICATION_PERMANENT_KEY];
        willHide = [notification.userInfo objectForKey:SLIDEVIEW_NOTIFICATION_HIDE_KEY];
        vc = [self viewControllerForView:view];
        if ([willHide boolValue]) {
            [vc viewWillDisappear:NO];
        }
        else {
            [vc viewWillAppear:NO];
        }
    }
}

-(void)handleViewDidNotification:(NSNotification *)notification
{
    UIView *view;
    NSNumber *isPermanent, *willHide;
    UIViewController *vc;
    if (notification != nil) {
        view = [notification.userInfo objectForKey:SLIDEVIEW_NOTIFICATION_KEY];
        isPermanent = [notification.userInfo objectForKey:SLIDEVIEW_NOTIFICATION_PERMANENT_KEY];
        willHide = [notification.userInfo objectForKey:SLIDEVIEW_NOTIFICATION_HIDE_KEY];
        vc = [self viewControllerForView:view];
        if ([willHide boolValue]) {
            [vc viewDidDisappear:NO];
        }
        else {
            [vc viewDidAppear:NO];
        }
        
        if ([isPermanent boolValue] && [willHide boolValue]) {
            [viewsToViewControllers removeObjectForKey:[self keyForView:view]];
        }
    }
}

-(void)handleSearchNotification:(NSNotification *)notification
{
    [self showFirstCardWithAnimation:YES];
}


-(void)showFirstCard
{
    [self showFirstCardWithAnimation:NO];
}

-(void)showFirstCardWithAnimation:(BOOL)animate
{
    if ([[slideViews subviews] count] > 1 && slideViews.currentPosition != SLIDE_VIEWS_MINUS_X_POSITION) {
        [slideViews setPosition:SLIDE_VIEWS_MINUS_X_POSITION animated:animate duration:0.75];
    } else if (slideViews.currentPosition != SLIDE_VIEWS_START_X_POS) {
        [slideViews setPosition:SLIDE_VIEWS_START_X_POS animated:animate duration:0.75];
    }
}
@end
