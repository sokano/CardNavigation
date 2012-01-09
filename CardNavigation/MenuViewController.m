//
//  MenuViewController.m
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

const CGFloat MENUVIEW_WIDTH = 292;

@interface MenuViewController () 

-(void)setUpViewsWithOrientation:(UIInterfaceOrientation)orientation;

@end

@implementation MenuViewController
@synthesize leftPaneController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        navigationView = [[UIView alloc] init];
        [navigationView setBackgroundColor:[UIColor clearColor]];
        navigationView.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpViewsWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [leftPaneController viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpViewsWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
    [leftPaneController viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [leftPaneController viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [leftPaneController viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    navigationView = nil;
    [leftPaneController viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
    [self setUpViewsWithOrientation:interfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self setUpViewsWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

#pragma mark - methods

+(CGRect)defaultRectWithOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return CGRectMake(0, 0, MENUVIEW_WIDTH, 748);
    }
    return CGRectMake(0, 0, MENUVIEW_WIDTH, 1004);
}

-(void)setUpViewsWithOrientation:(UIInterfaceOrientation)orientation
{
    CGRect frame = [MenuViewController defaultRectWithOrientation:orientation];
    if ([self.view subviews] == nil || [[self.view subviews] count] == 0) {
        [self.view addSubview:navigationView];
    }
    [navigationView setFrame:CGRectMake(0, 45, MENUVIEW_WIDTH, frame.size.height - 45)];
    if (leftPaneController == nil) {
        self.leftPaneController = [[LeftPaneController alloc] init];
        self.leftPaneController.view = navigationView;
    }
}

@end
