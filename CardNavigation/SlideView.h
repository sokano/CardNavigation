//
//  SlideView.h
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

extern NSString * SLIDEVIEW_VIEW_WILL_NOTIFICATION;
extern NSString * SLIDEVIEW_VIEW_DID_NOTIFICATION;
extern const NSString * SLIDEVIEW_NOTIFICATION_KEY;
extern const NSString * SLIDEVIEW_NOTIFICATION_PERMANENT_KEY;
extern const NSString * SLIDEVIEW_NOTIFICATION_HIDE_KEY;

extern const NSInteger SLIDE_VIEWS_MINUS_X_POSITION;
extern const NSInteger SLIDE_VIEWS_START_X_POS;
extern const CGFloat SLIDE_VIEWS_SHADOW_WIDTH;

enum SlideScrollDirection {
    SlideScrollDirectionNone = 0,
    SlideScrollDirectionLeft = 1,
    SlideScrollDirectionRight = 2
};
typedef NSUInteger SlideScrollDirection;

@interface SlideView : UIView {
    CFTimeInterval startTimestamp;
    CFTimeInterval animateDuration;
    CADisplayLink *displayLink;
    CGFloat startPosition;
    CGFloat currentPosition;
    CGFloat endPosition;
    
    UIView* viewAtLeft;
	UIView* viewAtRight;
	UIView* viewAtLeft2;
	UIView* viewAtRight2;	
    
   	SlideScrollDirection dragDirection;
    BOOL repositionAfter;
}

-(void)setPosition:(CGFloat)pos animated:(BOOL)animated duration:(CFTimeInterval)duration withReposition:(BOOL)willReposition;
-(void)setPosition:(CGFloat)pos animated:(BOOL)animated duration:(CFTimeInterval)duration;
-(void)setViewsHidden:(NSIndexSet *)indexSet hidden:(BOOL)hidden;
-(void)stopAnimation;
-(void)addViewInSlider:(UIView *)view atIndex:(NSInteger)index;
-(void)removeViewsUpToIndex:(NSInteger)index;
-(void)showCardWithIndex:(NSUInteger)cardIndex;
-(NSArray *)showingViews;
-(void)handlePanEnd;

@property (nonatomic,assign) CGFloat currentPosition;
@property (nonatomic,assign) SlideScrollDirection dragDirection;

@end