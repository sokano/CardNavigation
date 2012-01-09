//
//  SlideView.m
//  CardNavigation
//
//  Created by Steve Okano on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SlideView.h"

static inline float easeOutCubic(float time, float startValue, float change, float duration)
{
    time /= duration;
    time--;
    return change * (powf(time, 3.0) + 1) + startValue;
}


NSString * SLIDEVIEW_VIEW_WILL_NOTIFICATION = @"SLIDEVIEW_VIEW_WILL_NOTIFICATION";
NSString * SLIDEVIEW_VIEW_DID_NOTIFICATION = @"SLIDEVIEW_VIEW_DID_NOTIFICATION";
const NSString * SLIDEVIEW_NOTIFICATION_KEY = @"SLIDEVIEW_NOTIFICATION_KEY";
const NSString * SLIDEVIEW_NOTIFICATION_PERMANENT_KEY = @"SLIDEVIEW_NOTIFICATION_PERMANENT_KEY";
const NSString * SLIDEVIEW_NOTIFICATION_HIDE_KEY = @"SLIDEVIEW_NOTIFICATION_HIDE_KEY";


const NSInteger SLIDE_VIEWS_MINUS_X_POSITION = -217;
const NSInteger SLIDE_VIEWS_START_X_POS = 0;
const CGFloat SLIDE_VIEWS_SHADOW_WIDTH = 90.0f;
const static CFTimeInterval STACKSCROLLVIEW_DEFAULT_TIME = 0.75;
const static CFTimeInterval STACKSCROLLVIEW_LONGER_TIME = 1.0;
const static NSInteger DROPCARD_BOUNDARY = -600;

@interface SlideView ()
-(void)animate:(CADisplayLink *)link;
-(void)sendNotificationForView:(UIView *)view willHide:(BOOL)willHide isPermanent:(BOOL)isPermanent;
-(NSDictionary *)notificationForView:(UIView *)view willHide:(BOOL)willHide isPermanent:(BOOL)isPermanent;
-(void)handlePanRedraw;
-(CGFloat)offsetOfCardAtIndex:(NSInteger)index;
-(CGFloat)positionOfCardAtIndex:(NSInteger)index;
-(void)setFrameForViewAtIndex:(NSInteger)index withPosition:(CGFloat)pos;
-(UIView *)viewAtIndex:(NSInteger)index;
-(UIView *)viewClosestToPosition:(CGFloat)pos;
-(CGFloat)endPositionClosestToPosition:(CGFloat)pos;
@end

@implementation SlideView

@synthesize currentPosition;
@synthesize dragDirection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentPosition = SLIDE_VIEWS_START_X_POS;
        startPosition = 0;
        self.autoresizesSubviews = YES;
        viewAtLeft = nil;
        viewAtRight = nil;
        viewAtLeft2 = nil;
        viewAtRight2 = nil;
    }
    return self;
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    [self handlePanRedraw];
}
-(void)setCurrentPosition:(CGFloat)pos
{
    [displayLink invalidate];
    displayLink = nil;
    currentPosition = pos;
    [self setNeedsLayout];
}

-(void)setPosition:(CGFloat)pos animated:(BOOL)animated duration:(CFTimeInterval)duration
{
    [self setPosition:pos animated:animated duration:duration withReposition:NO];
}

-(void)setPosition:(CGFloat)pos animated:(BOOL)animated duration:(CFTimeInterval)duration withReposition:(BOOL)willReposition
{
    [self stopAnimation];
    repositionAfter = YES;
    if (animated) {
        animateDuration = duration;
        startTimestamp = CACurrentMediaTime();
        startPosition = currentPosition;
        endPosition = pos;
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animate:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    } else {
        currentPosition = pos;
        [self setNeedsLayout];
    } 
}

-(void)stopAnimation
{
    [displayLink invalidate];
    displayLink = nil;
    repositionAfter = NO;
}

-(void)animate:(CADisplayLink *)link
{
    
    float dt = (link.timestamp - startTimestamp);
    if (dt > animateDuration) {
        [self stopAnimation];
        self.currentPosition = endPosition;
        if (repositionAfter) {
            [self handlePanEnd];
        }
        return;
    }
    currentPosition = easeOutCubic(dt, startPosition, (endPosition - startPosition), animateDuration);
    if (abs(currentPosition - endPosition) < 1 && repositionAfter) {
        [self handlePanEnd];
    }
    [self setNeedsLayout];
}

-(void)handlePanRedraw
{
    UIView *newLeft2 = viewAtLeft2, *newLeft = viewAtLeft, *newRight = viewAtRight, *newRight2 = viewAtRight2;
    
    NSInteger index = [viewAtLeft tag];
    CGFloat leftViewPosition = [self positionOfCardAtIndex:index];
    NSInteger count = [[self subviews] count];
    
    if(leftViewPosition < currentPosition)
    {
        // set left = left2, right = left, right2 = right if left2 position < currentPosition
        // and theres a card before this one
        CGFloat rightViewPosition = [self positionOfCardAtIndex:viewAtRight.tag];
        if (viewAtRight != nil && rightViewPosition < currentPosition && viewAtRight.tag + 1 < [[self subviews] count]) {
            
            newLeft2 = viewAtLeft;
            newLeft = viewAtRight;
            newRight = viewAtRight2;
            if (index + 2 < count) {
                newRight2 = [[self subviews] objectAtIndex:index+2];
                [self sendNotificationForView:newRight2 willHide:NO isPermanent:NO];
            }
            else {
                newRight2 = nil;
            }
            // hide viewAtLeft2
            if (viewAtLeft2 != nil) {
                [self sendNotificationForView:viewAtLeft2 willHide:YES isPermanent:NO];
            }
            if (newLeft2 != nil) {
                NSDictionary *userDict = [self notificationForView:newLeft2 willHide:YES isPermanent:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:userDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:userDict];
            }
            if (newRight != nil) {
                NSDictionary *rightDict = [self notificationForView:newRight willHide:NO isPermanent:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:rightDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:rightDict];
            }
        }
        
        // set right2 hidden if it exists
        // set left2 not hidden if it exists
    }
    else if (leftViewPosition > currentPosition)
    {
        // set left2 hidden if exists
        // set right2 not hidden if it exists
        CGFloat left2Pos = [self positionOfCardAtIndex:viewAtLeft2.tag];
        if (viewAtLeft2 != nil && left2Pos > currentPosition &&
            viewAtLeft2.tag - 1 >= 0) {
            newRight2 = viewAtRight;
            newRight = viewAtLeft;
            newLeft = viewAtLeft2;
            if (index - 2 >= 0) {
                newLeft2 = [[self subviews] objectAtIndex:index - 2];
                [self sendNotificationForView:newLeft2 willHide:NO isPermanent:NO];
            }
            else {
                newLeft2 = nil;
            }
            if (viewAtRight2 != nil) {
                [self sendNotificationForView:viewAtRight2 willHide:YES isPermanent:NO];
            }
            if (newRight2 != nil) {
                NSDictionary *userDict = [self notificationForView:newRight2 willHide:YES isPermanent:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:userDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:userDict];
            }
            if (newLeft != nil) {
                NSDictionary *leftDict = [self notificationForView:newLeft willHide:NO isPermanent:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:leftDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:leftDict];
            }
        } 
    }
    
    if (newLeft2 != nil) {
        [self setFrameForViewAtIndex:[newLeft2 tag] withPosition:currentPosition];
        [self sendNotificationForView:newLeft2 willHide:NO isPermanent:NO];
    }
    if (newLeft != nil) {
        [self setFrameForViewAtIndex:[newLeft tag] withPosition:currentPosition];
        [self sendNotificationForView:newLeft willHide:NO isPermanent:NO];
    }
    if (newRight != nil) {
        [self setFrameForViewAtIndex:[newRight tag] withPosition:currentPosition];
        [self sendNotificationForView:newRight willHide:NO isPermanent:NO];
    }
    if (newRight2 != nil) {
        [self setFrameForViewAtIndex:[newRight2 tag] withPosition:currentPosition];
        [self sendNotificationForView:newRight2 willHide:NO isPermanent:NO];
    }
    
    viewAtLeft = newLeft;
    viewAtRight = newRight;
    viewAtLeft2 = newLeft2;
    viewAtRight2 = newRight2;
    
}

-(void)handlePanEnd
{
    CGFloat dropCardPosition;
    [self stopAnimation];
    if ([[self subviews] count] > 1) {
        dropCardPosition = DROPCARD_BOUNDARY;// SLIDE_VIEWS_MINUS_X_POSITION - self.frame.size.width + 200;
    }
    else {
        dropCardPosition = DROPCARD_BOUNDARY - SLIDE_VIEWS_MINUS_X_POSITION; //SLIDE_VIEWS_START_X_POS - self.frame.size.width + 200;
    }
    if (currentPosition < dropCardPosition) {
        [self removeViewsUpToIndex:1];
        [self setPosition:[self positionOfCardAtIndex:0] animated:YES duration:STACKSCROLLVIEW_LONGER_TIME];
    }
    else {
        
        CGFloat pos = [self endPositionClosestToPosition:currentPosition];
        
        [self setPosition:pos animated:YES duration:STACKSCROLLVIEW_DEFAULT_TIME];
    }
}

-(NSArray *)showingViews
{
    NSMutableArray *returned = [NSMutableArray arrayWithCapacity:[[self subviews] count]];
    for (UIView *view in [self subviews]) {
        if (view == viewAtLeft || view == viewAtRight || view == viewAtLeft2 || view == viewAtRight2) {
            [returned addObject:view];
        }
    }
    return [NSArray arrayWithArray:returned];
}

- (void)addViewInSlider:(UIView *)view atIndex:(NSInteger)index
{
    if (index > [self.subviews count]) {
        return;
    }
	
    for (int i = [self.subviews count]-1; i >= index; i--){
        UIView *viewToRemove = [[self subviews] objectAtIndex:i];
        [self sendNotificationForView:viewToRemove willHide:YES isPermanent:YES];
    }
    
    [view setTag:(index)];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    if ([[self subviews] count] == 0) {
        view.frame = CGRectMake(0, 0, view.frame.size.width, self.frame.size.height);
    } else {
        view.frame = CGRectMake(self.frame.size.width - SLIDE_VIEWS_MINUS_X_POSITION
                                , 0, view.frame.size.width, self.frame.size.height);
    }
    
    NSDictionary *userDict = [self notificationForView:view willHide:NO isPermanent:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:userDict];
    [self addSubview:view];
    [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:userDict];
    CGFloat newPosition,offset;
    
    if (index == 0) {
        newPosition = SLIDE_VIEWS_START_X_POS;
        viewAtLeft = [self viewAtIndex:0];
        viewAtRight = nil;
        viewAtRight2 = nil;
        viewAtLeft2 = nil;
        offset = 0;
    }
    else {
        viewAtLeft = [self viewAtIndex:index-1];
        viewAtLeft2 = [self viewAtIndex:index-2];
        
        viewAtRight = [self viewAtIndex:index];
        viewAtRight2 = [self viewAtIndex:index+1];
        newPosition = [self positionOfCardAtIndex:index -1];
        //offset = view.frame.size.width + [self viewAtIndex:index - 1].frame.size.width - self.frame.size.width - SLIDE_VIEWS_MINUS_X_POSITION;
        offset = viewAtLeft.frame.size.width + viewAtRight.frame.size.width - (self.frame.size.width - SLIDE_VIEWS_MINUS_X_POSITION);
        if (viewAtLeft2 != nil) {
            NSDictionary *leftDict = [self notificationForView:viewAtLeft2 willHide:YES isPermanent:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:leftDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:leftDict];
        }
        if (viewAtRight2 != nil) {
            NSDictionary *rightDict = [self notificationForView:viewAtRight2 willHide:YES isPermanent:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:rightDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:rightDict];
        }
    }
    
    [self setNeedsDisplay];
	[self setPosition:newPosition+offset animated:YES duration:STACKSCROLLVIEW_LONGER_TIME];
}

-(NSDictionary *)notificationForView:(UIView *)view willHide:(BOOL)willHide isPermanent:(BOOL)isPermanent
{
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:view,[NSNumber numberWithBool:isPermanent],[NSNumber numberWithBool:willHide], nil]
                                       forKeys:[NSArray arrayWithObjects:SLIDEVIEW_NOTIFICATION_KEY,SLIDEVIEW_NOTIFICATION_PERMANENT_KEY,
                                                SLIDEVIEW_NOTIFICATION_HIDE_KEY, nil]];
}

-(void)sendNotificationForView:(UIView *)view willHide:(BOOL)willHide isPermanent:(BOOL)isPermanent
{
    NSDictionary *userData = [self notificationForView:view willHide:willHide isPermanent:isPermanent];
    BOOL isHidden = view.hidden;
    if (isHidden != willHide || isPermanent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_WILL_NOTIFICATION object:nil userInfo:userData];
    }
    
    if (isPermanent && willHide) {
        [view removeFromSuperview];
    }
    else if (isPermanent && !willHide) {
        [self addSubview:view];
    }
    else {
        [view setHidden:willHide];
    }
    
    if (isHidden != willHide || isPermanent) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SLIDEVIEW_VIEW_DID_NOTIFICATION object:nil userInfo:userData];
    }
}

-(CGFloat)offsetOfCardAtIndex:(NSInteger)index
{
    if (index < 0 || index > [[self subviews] count] - 1) {
        return CGFLOAT_MIN;
    }
    CGFloat sum = 0;
    for (NSUInteger i = 0; i < index; i++) {
        UIView * view = (UIView *)[[self subviews] objectAtIndex:i];
        sum += view.frame.size.width;
    }
    return sum;
}

-(CGFloat)positionOfCardAtIndex:(NSInteger)index
{
    CGFloat startPos;
    if ([[self subviews] count] > 1) {
        startPos = SLIDE_VIEWS_MINUS_X_POSITION;
    }
    else {
        startPos = SLIDE_VIEWS_START_X_POS;
    }
    return [self offsetOfCardAtIndex:index] + startPos;
}

-(void)showCardWithIndex:(NSUInteger)cardIndex
{
    if (cardIndex < [[self subviews] count]) {
        [self stopAnimation];
        [self setPosition:[self positionOfCardAtIndex:cardIndex] animated:YES duration:STACKSCROLLVIEW_LONGER_TIME];
    }
}

-(void)removeViewsUpToIndex:(NSInteger)index
{
    CGFloat lastPos;
    for (NSInteger i = [[self subviews] count] -1; i >= index; i--) {
        UIView *view = (UIView *)[[self subviews] objectAtIndex:i];
        [self sendNotificationForView:view willHide:YES isPermanent:YES];        
    }
    if ([[self subviews] count] > 1) {
        NSInteger index = [[self subviews] count] -2;
        lastPos = [self positionOfCardAtIndex:index];
        viewAtLeft = [self viewAtIndex:index];
        viewAtRight = [self viewAtIndex:index+1];
        viewAtRight2 = [self viewAtIndex:index+2];
        viewAtLeft2 = [self viewAtIndex:index-1];
    }
    else if ([[self subviews] count] == 1){
        lastPos = SLIDE_VIEWS_START_X_POS;
        viewAtLeft = [self viewAtIndex:0];
        viewAtRight = nil;
        viewAtLeft2 = nil;
        viewAtRight2 = nil;
    }
    else {
        lastPos = SLIDE_VIEWS_START_X_POS;
        viewAtLeft = viewAtRight = viewAtLeft2 = viewAtRight2 = nil;
    }
    if (currentPosition > lastPos) {
        [self handlePanEnd];
    }
}


-(void)setViewsHidden:(NSIndexSet *)indexSet hidden:(BOOL)hidden
{
    
    for (UIView *view in [[self subviews] objectsAtIndexes:indexSet]) {
        if (view.hidden != hidden) {
            [self sendNotificationForView:view willHide:hidden isPermanent:NO];
        }
    }
}

-(void)setFrameForViewAtIndex:(NSInteger)index withPosition:(CGFloat)pos
{
    if (index < 0 || index >= [[self subviews] count]) {
        return;
    }
    UIView *view = (UIView *)[[self subviews] objectAtIndex:index];
    
    if (view != nil) {
        CGFloat x = [self positionOfCardAtIndex:index];
        
        CGFloat intermediateValue;
        // offset cards if they are 
        if ([[self subviews] count] > 1) {
            x += SLIDE_VIEWS_MINUS_X_POSITION;
        }
        intermediateValue = x - pos;
        
        // make it so views can never slide past the minus x position
        if (intermediateValue < SLIDE_VIEWS_MINUS_X_POSITION) {
            intermediateValue = SLIDE_VIEWS_MINUS_X_POSITION;
        }
        
        view.frame = CGRectMake(intermediateValue, view.frame.origin.y, view.frame.size.width, self.frame.size.height);
    }
}

/// Gets the subview at index but returns nil if argument is out of range instead of error
-(UIView *)viewAtIndex:(NSInteger)index
{
    NSInteger count = [[self subviews] count];
    if (index < 0 || index >= count) {
        return nil;
    }
    else {
        return [[self subviews] objectAtIndex:index];
    }
}

// Returns the view closest to the currentPosition
-(UIView *)viewClosestToPosition:(CGFloat)pos
{
    if ([[self subviews] count] == 0) {
        return nil;
    }
    UIView *closest = [[self subviews] objectAtIndex:0];
    CGFloat minValue = abs([self positionOfCardAtIndex:0] - pos);
    for (UIView *view in [self subviews]) {
        CGFloat local = abs([self positionOfCardAtIndex:[view tag]] - pos);
        if (local < minValue) {
            minValue = local;
            closest = view;
        }
    }
    return closest;
}

-(CGFloat)endPositionClosestToPosition:(CGFloat)pos
{
    CGFloat startPos, intermediatePos, minDiff = CGFLOAT_MAX;
    if ([[self subviews] count] <= 1) {
        return SLIDE_VIEWS_START_X_POS;
    }
    CGFloat endPos = SLIDE_VIEWS_MINUS_X_POSITION;
    startPos = SLIDE_VIEWS_MINUS_X_POSITION;
    CGFloat screenSize = self.frame.size.width - SLIDE_VIEWS_MINUS_X_POSITION;
    for (NSInteger i = 0; i < [[self subviews] count]; i++) {
        UIView *view = [self viewAtIndex:i];
        if (i < [[self subviews] count] - 1) {
            intermediatePos = startPos + [self viewAtIndex:i+1].frame.size.width + view.frame.size.width - screenSize;
            if (abs(currentPosition - intermediatePos) < minDiff) {
                minDiff = abs(currentPosition - intermediatePos);
                endPos = intermediatePos;
            }
        }
        
        if (abs(currentPosition - startPos) < minDiff) {
            minDiff = abs(currentPosition - startPos);
            endPos = startPos;
        }
        startPos += view.frame.size.width;
    }
    return endPos;
}

@end
