//
//  LeftPaneController.m
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeftPaneController.h"
#import "TopLevelTableCell.h"
#import "CardViewController.h"
#import "SOAppDelegate.h"

static const NSInteger IQ_INDENT_LEVEL = 2;

NSString* const NOTIFICATION_TOP_LEVEL_NAV = @"NOTIFICATION_TOP_LEVEL_NAV";

@interface LeftPaneController  ()

/**
 * datasource for tableview: filled with TopLevelItems
 */
@property (nonatomic,strong) NSArray* navItems;

@property (nonatomic, strong) UITableView* navTableView;

@property (nonatomic, strong) NSIndexPath* lastSelectedIndexPath;

-(NSArray *)navItemsDataSource;
-(void)navigateToScreen:(UIViewController*)screen;
-(BOOL)indexIsMainNavItem:(NSUInteger)rowIndex;
-(BOOL)indexIsSubscriptionNavItem:(NSUInteger)rowIndex;
-(void)selectNavItem:(NavigationId)itemId;
-(UITableViewCell *)cellForNavItem:(NavigationId)navItem;
@end

@implementation LeftPaneController

@synthesize initialNavItem;
@synthesize selectedNavItem;
@synthesize navItems;
@synthesize navTableView;
@synthesize lastSelectedIndexPath;

#pragma mark - Life Cycle

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

-(id)init
{
	if ((self = [super init])) {
        self.initialNavItem = NavigationId_Nothing;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedNavItem = self.initialNavItem;
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
	self.navTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
	self.navTableView.dataSource = self;
	self.navTableView.delegate = self;
	self.navTableView.bounces = YES;
	self.navTableView.opaque = NO;
	self.navTableView.backgroundColor = [UIColor clearColor];
	self.navTableView.backgroundView = nil;
    self.navTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.navTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(initialNavItem != NavigationId_Nothing)
    {
        [self selectNavItem:initialNavItem];
        //self.initialNavItem = NavigationId_Nothing;
    }
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    
    self.navTableView = nil;
}

#pragma mark - private methods

- (NSArray *) navItemsDataSource
{
	if (self.navItems == nil) {
		self.navItems = [NSArray arrayWithObjects:
                         /*[[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"CapitalIQ.com",nil)
                          navItemId:NavigationId_CapitalIQPlatform
                          detail:nil
                          indent:NO],*/
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Barcode",nil)
                                                              navItemId:NavigationId_Barcode
                                                                 detail:nil
                                                                 indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Collection", nil)
                                                              navItemId:NavigationId_Collection
                                                                 detail:nil
                                                                 indent:NO],
                         /*
                          [[TopLevelItem alloc] initWithTitleAndDetail:@"Test Controllers"
                          navItemId:NavigationId_TestControllers
                          detail:@"debug screens"
                          indent:NO],*/
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Credit Card", nil)
                                                              navItemId:NavigationId_CreditCard
                                                                 detail:nil
                                                                 indent:NO],
                         /*[[[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Starred Documents", nil) 
                          navItemId:NavigationId_StarredDocuments
                          detail:nil
                          indent:NO] 
                          autorelease],*/
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Location", nil)
                                                              navItemId:NavigationId_Location
                                                                 detail:nil
                                                                 indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Radiation", nil)
                                                              navItemId:NavigationId_Radiation
                                                                 detail:nil
                                                                 indent:NO],
                         nil];
	}
	return self.navItems;
}

-(void)navigateToScreen:(UIViewController*)screen
{
    
}

-(BOOL)indexIsMainNavItem:(NSUInteger)rowIndex
{
    return rowIndex < [[self navItemsDataSource] count];
}

-(BOOL)indexIsSubscriptionNavItem:(NSUInteger)rowIndex
{
    return ![self indexIsMainNavItem:rowIndex];
}

-(BOOL)subscriptionIndexFromIndex:(NSUInteger)rowIndex
{
    return rowIndex - [[self navItemsDataSource] count];
}

-(void)update
{
    NSIndexPath* selectedPath = [self.navTableView indexPathForSelectedRow];
    
    [self.navTableView reloadData];
    // keep nav item selected
    [self.navTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [[self navItemsDataSource] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TopLevelTableCell* cell = (TopLevelTableCell *)[tableView dequeueReusableCellWithIdentifier:[TopLevelTableCell reuseIdentifier]];
    if (cell == nil) 
    {
        TopLevelItem *item = [[self navItemsDataSource] objectAtIndex:indexPath.row];
        cell = [TopLevelTableCell topLevelTableCellForItem:item isSelected:(self.selectedNavItem==item.navItemId)];
    }
    
    cell.badgeImageView.hidden = YES;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.navTableView)
    {
        self.lastSelectedIndexPath = [tableView indexPathForSelectedRow];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self indexIsMainNavItem:[indexPath row]])
    {
        TopLevelItem* item = [[self navItemsDataSource] objectAtIndex:[indexPath row]];
        
        switch(item.navItemId)
        {
            case NavigationId_Barcode:
                ;
                
                break;
            case NavigationId_Collection: 
                ;
                break;
            case NavigationId_CreditCard: 
                ;
                break;
            case NavigationId_Location: 
                ;
                break;
            case NavigationId_Note:
                ;
                break;
            case NavigationId_Radiation:
                ;
                break;
            default:
                return;
        }
        if (self.lastSelectedIndexPath != nil) {
            [tableView deselectRowAtIndexPath:self.lastSelectedIndexPath animated:YES];
            self.lastSelectedIndexPath = indexPath;
        }
        self.selectedNavItem = item.navItemId;
        CardViewController *newCard = [[CardViewController alloc] init];
        [[SOAppDelegate appDelegate] pushController:newCard sender:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LEFT_NAV_LARGE_ROW_HEIGHT;
}

#pragma mark - Methods

-(void)selectNavItem:(NavigationId)itemId
{
    NSUInteger index = [[self navItemsDataSource] indexOfObjectPassingTest:^(id obj, NSUInteger index, BOOL* stop)
                        {
                            TopLevelItem* item = (TopLevelItem*)obj;
                            if(item.navItemId == itemId)
                            {
                                *stop = YES;
                                return YES;
                            }
                            return NO;
                        }];
    
    [self.navTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] 
                                   animated:YES 
                             scrollPosition:UITableViewScrollPositionNone];
}

-(UITableViewCell *)cellForNavItem:(NavigationId)navItem
{
	NSUInteger index = [[self navItemsDataSource] indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
		TopLevelItem* item = (TopLevelItem*)obj;
		if (item.navItemId == navItem) {
			*stop = YES;
			return YES;
		}
		return NO;
	}];
	if (index != NSNotFound) {
		return (UITableViewCell *)[self.navTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
	}
	return nil;
}

-(void)resetHighlightedLink
{
    self.selectedNavItem = self.initialNavItem;
    [navTableView reloadData];
}
@end
