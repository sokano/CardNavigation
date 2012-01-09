//
//  TopLevelTableCell.h
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopLevelItem.h"
extern const CGFloat LEFT_NAV_LARGE_ROW_HEIGHT;
extern const CGFloat LEFT_NAV_SMALL_ROW_HEIGHT;

@interface TopLevelTableCell : UITableViewCell {
	TopLevelItem *item;
	UIImageView *imageView;
	UILabel *topLevelText;
    UIImageView* badgeImageView;
}

@property (nonatomic, strong) TopLevelItem *item;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *topLevelText;
@property (nonatomic, strong) IBOutlet UIImageView* badgeImageView;

+(TopLevelTableCell *)topLevelTableCellForItem:(TopLevelItem *)cellItem;
+(TopLevelTableCell *)topLevelTableCellForItem:(TopLevelItem *)cellItem isSelected:(BOOL)selected;
+(UIImage *)imageForTopLevelItem:(TopLevelItem *)topLevelItem selected:(BOOL)isSelected;
+(NSString *)reuseIdentifier;

@end
