//
//  CardViewController.m
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardViewController.h"
#import "TopLevelTableCell.h"
#import "SOAppDelegate.h"

@interface CardViewController()
@property (nonatomic,copy) NSArray *datasource;
-(NSArray *)navData;
@end

@implementation CardViewController
@synthesize tableView;
@synthesize datasource;
@synthesize selectedNavItem;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (NSArray *)navData
{
    if (self.datasource == nil) {
		self.datasource = [NSArray arrayWithObjects:
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Hearts",nil)
                          navItemId:NavigationId_CardHearts
                          detail:nil
                          indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Barcode",nil)
                                                            navItemId:NavigationId_Barcode
                                                               detail:nil
                                                               indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Collection", nil)
                                                            navItemId:NavigationId_Collection
                                                               detail:nil
                                                               indent:NO],
                         
                          [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Clubs", nil)
                          navItemId:NavigationId_CardClubs
                          detail:nil
                          indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Credit Card", nil)
                                                            navItemId:NavigationId_CreditCard
                                                               detail:nil
                                                               indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Spades", nil) 
                          navItemId:NavigationId_CardSpades
                          detail:nil
                          indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Location", nil)
                                                            navItemId:NavigationId_Location
                                                               detail:nil
                                                               indent:NO],
                         [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Radiation", nil)
                                                            navItemId:NavigationId_Radiation
                                                               detail:nil
                                                               indent:NO],
                           [[TopLevelItem alloc] initWithTitleAndDetail:NSLocalizedString(@"Diamonds", nil)
                                                              navItemId:NavigationId_CardDiamonds
                                                                 detail:nil
                                                                 indent:NO],
                         nil];
	}
	return self.datasource;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self navData] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LEFT_NAV_LARGE_ROW_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CardViewController *vc = [[CardViewController alloc] init];
    [[SOAppDelegate appDelegate] pushController:vc sender:self];
}
#pragma mark - UITableViewDatasource

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TopLevelTableCell* cell = (TopLevelTableCell *)[self.tableView dequeueReusableCellWithIdentifier:[TopLevelTableCell reuseIdentifier]];
    if (cell == nil) 
    {
        TopLevelItem *item = [[self navData] objectAtIndex:indexPath.row];
        cell = [TopLevelTableCell topLevelTableCellForItem:item isSelected:(self.selectedNavItem==item.navItemId)];
    }
    
    cell.badgeImageView.hidden = YES;
    return cell;
}
@end
