//
//  TopLevelTableCell.m
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopLevelTableCell.h"

static NSString * const TOPLEVEL_CELL_ID = @"topLevelCell";
const CGFloat LEFT_NAV_LARGE_ROW_HEIGHT = 60;
const CGFloat LEFT_NAV_SMALL_ROW_HEIGHT = 44;
@interface TopLevelTableCell ()

+(id)loadViewFromNib:(NSString*)nibName owner:(id)owner type:(Class)type;

@end

@implementation TopLevelTableCell

@synthesize item;
@synthesize imageView;
@synthesize topLevelText;
@synthesize badgeImageView;

+(TopLevelTableCell *)topLevelTableCellForItem:(TopLevelItem *)cellItem
{
    TopLevelTableCell* cell = 
    [TopLevelTableCell loadViewFromNib:@"TopLevelTableCell" owner:self type:[TopLevelTableCell class]];
    
	cell.item = cellItem;
	cell.topLevelText.text = cellItem.title;
	cell.imageView.image = [TopLevelTableCell imageForTopLevelItem:cellItem
															selected:NO];
    //cell.badgeImageView.image = [UIImage imageNamed:@"unread.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}

+(TopLevelTableCell *)topLevelTableCellForItem:(TopLevelItem *)cellItem isSelected:(BOOL)selected
{
    TopLevelTableCell* cell = 
    [TopLevelTableCell loadViewFromNib:@"TopLevelTableCell" owner:self type:[TopLevelTableCell class]];
    
	cell.item = cellItem;
	cell.topLevelText.text = cellItem.title;
	cell.imageView.image = [TopLevelTableCell imageForTopLevelItem:cellItem
															selected:selected];
    //[cell.imageView sizeToFit];
    //cell.backgroundView = 
    //cell.badgeImageView.image = [UIImage imageNamed:@"unread.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}

+(NSString *)reuseIdentifier
{
	return TOPLEVEL_CELL_ID;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

+(UIImage *)imageForTopLevelItem:(TopLevelItem *)topLevelItem selected:(BOOL)isSelected
{
    switch (topLevelItem.navItemId){
            case NavigationId_Barcode:
                return [UIImage imageNamed:@"195-barcode.png"];
            case NavigationId_Collection:
                return [UIImage imageNamed:@"191-collection.png"];
            case NavigationId_CardClubs:
                return [UIImage imageNamed:@"200-card-clubs.png"];
            case NavigationId_CardDiamonds:
                return [UIImage imageNamed:@"197-card-diamonds.png"];
            case NavigationId_CardHearts:
                return [UIImage imageNamed:@"199-card-hearts.png"];
            case NavigationId_CardSpades:
                return [UIImage imageNamed:@"198-card-spades.png"];
            case NavigationId_CreditCard:
                return [UIImage imageNamed:@"192-credit-card.png"];
            case NavigationId_Location:
                return [UIImage imageNamed:@"193-location-arrow.png"];
            case NavigationId_Note:
                return [UIImage imageNamed:@"194-note-2.png"];
            case NavigationId_Radiation:
                return [UIImage imageNamed:@"196-radiation.png"];
            default:
                return nil;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
	[topLevelText setNeedsDisplay];
	[imageView setNeedsDisplay];
    [badgeImageView setNeedsDisplay];
}

-(void)layoutSubviews
{
	[super layoutSubviews];
	
	float indentPoints = self.indentationLevel * self.indentationWidth;
	
	if (self.indentationLevel > 0) {
		CGFloat imageWidth = 40.0f;
		CGFloat imageHeight = 38.0f;
		self.topLevelText.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
		self.imageView.frame = CGRectMake(30, 3, imageWidth, imageHeight);
		self.topLevelText.frame = CGRectMake(90, 3, 193 - indentPoints, 38);
	}
	
	self.contentView.frame = CGRectMake(indentPoints, 
										self.contentView.frame.origin.y,
										self.contentView.frame.size.width - indentPoints
										, self.contentView.frame.size.height);
    if (self.indentationLevel == 0 && self.imageView.frame.size.width < 48 &&
        self.imageView.frame.origin.x == 30.0) {
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x + floor((48 - self.imageView.frame.size.width) /2), 
                                          self.imageView.frame.origin.y,
                                          self.imageView.frame.size.width,
                                          self.imageView.frame.size.height);
    }
}

+(id)loadViewFromNib:(NSString*)nibName owner:(id)owner type:(Class)type
{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:nil];
    
    for(UIView* view in views)
    {
        if([view isKindOfClass:type])
        {
            return view;
        }
    }
    
    return nil;
}

@end

