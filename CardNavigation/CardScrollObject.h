//
//  CardScrollObject.h
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardScrollObject : NSObject {
UIViewController *viewController;
NSUInteger index;
}

-(id)initWithController:(UIViewController *)vc andIndex:(NSUInteger)idx;

@property (nonatomic,retain) UIViewController *viewController;
@property (nonatomic,assign) NSUInteger index;
@end