//
//  SOAppDelegate.m
//  CardNavigation
//
//  Created by Steve Okano on 1/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SOAppDelegate.h"
#import "CardRootViewController.h"

@interface SOAppDelegate()
-(void)setUpMainScreen;
@end

@implementation SOAppDelegate

@synthesize window = _window;

+(SOAppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUpMainScreen];
    self.window.rootViewController = rootController;
    if (rootController == nil || rootController.menuViewController == nil
        || rootController.cardScrollViewController == nil) {
		[self setUpMainScreen];
    }
    if (self.window.rootViewController != rootController) {
        self.window.rootViewController = rootController;
    }
    if (![self.window isKeyWindow]) {        
        [self.window makeKeyAndVisible];
    }
	
    [rootController viewWillAppear:NO];
    if ([[rootController.cardScrollViewController viewControllersArray] count] == 0) {
        
    }
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)setUpMainScreen
{
    rootController = [[CardRootViewController alloc] init];
    [rootController viewDidLoad];
    
    if (rootController.menuViewController == nil) {
        rootController.menuViewController = [[MenuViewController alloc] init];
        [rootController.menuViewController viewDidLoad];
    }
    if (rootController.cardScrollViewController == nil) {
        rootController.cardScrollViewController = [[CardScrollViewController alloc] init];
        [rootController.cardScrollViewController viewDidLoad];
    }
}

-(void)pushController:(UIViewController *)viewController sender:(UIViewController *)sender
{
    if ([rootController.cardScrollViewController viewControllersArray] != nil && 
        [[rootController.cardScrollViewController viewControllersArray] count] > 0) {
        if (sender == nil) {
            sender = [[rootController.cardScrollViewController viewControllersArray] lastObject];
        }
        else {
            UIView *senderView = nil;
            if ([sender respondsToSelector:@selector(view)]) {
                senderView = [sender view];
            }
            NSUInteger index = [[rootController.cardScrollViewController viewControllersArray] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                UIViewController *vc = (UIViewController *)obj;
                if (senderView != nil && [senderView isDescendantOfView:vc.view]) {
                    *stop = YES;
                    return YES;
                }
                return NO;
            }];
            if (index == NSNotFound) {
                //sender = [[rootController.cardScrollViewController viewControllersArray] lastObject];
                [rootController.cardScrollViewController addViewInSlider:viewController invokeByController:sender isStackStartView:YES];
                return;
            }
            else {
                sender = [[rootController.cardScrollViewController viewControllersArray] objectAtIndex:index];
                
            }
        }
        [rootController.cardScrollViewController addViewInSlider:viewController 
                                              invokeByController:sender isStackStartView:NO];
    }
    else
    {
        [rootController.cardScrollViewController addViewInSlider:viewController
                                                        invokeByController:rootController.menuViewController
                                                          isStackStartView:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
