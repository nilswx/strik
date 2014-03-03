//
//  ScrollNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 25/12/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "ScrollNode.h"
#import "CCNode+ClipVisit.h"
#import "ScrollNodeScrollView.h"

@interface ScrollNode()

// The content to display
@property (nonatomic) CCNode *content;

// Using the UISCrollView to do the hard work
@property ScrollNodeScrollView *scrollView;

@end

@implementation ScrollNode

- (id)initWithContent:(CCNode *)content
{
	if(self = [super init])
	{
		// Set the content to display
		self.content = content;
		
		// Listening to content size changes and update our scroll node content accordingly
		[self.content addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionInitial context:NULL];
	}
	return self;
}

+ (id)scrollNodeWithContent:(CCNode *)content
{
	return [[ScrollNode alloc] initWithContent:content];
}

- (void)setContent:(CCNode *)content
{
	// Clear the old content
	[self clear];
	
	// Scroll to top (if there is a scrollview)
	if(self.scrollView)
	{
		[self.scrollView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
	}

	// Set the correct starting position, working from topleft is easier since UIScrollView does that too
	content.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerTopLeft);
	
	content.anchorPoint = CGPointMake(0, 1);

	[self addChild:content];
	
	// And finaly set the content
	_content = content;
}

- (void)visit
{
	[self preVisitWithClippingRect:self.boundingBox];
	
	[super visit];
	
	[self postVisit];
}

- (void)onEnter
{
	[self setupScrollView];
	[super onEnter];
}

- (void)onExitTransitionDidStart
{	
	[self removeScrollView];
	[super onExitTransitionDidStart];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	self.content.position = CGPointMake(-self.scrollView.contentOffset.x, -self.scrollView.contentOffset.y);
}

- (void)removeFromParentAndCleanup:(BOOL)cleanup
{
	[self removeScrollView];
	[super removeFromParentAndCleanup:cleanup];
}

- (void)enableScrolling:(BOOL)enableScrolling
{
	if(enableScrolling)
	{
		[self setupScrollView];
	}
	else
	{
		[self removeScrollView];
	}
}

- (void)setupScrollView
{
	// We need to get the world point and inverse the y to get the UIPoint
	CGPoint worldPoint = [self.parent convertToWorldSpace:self.position];
	CGSize size = [CCDirector sharedDirector].view.bounds.size;
	
	CGPoint UIPoint = CGPointMake(worldPoint.x, size.height - worldPoint.y);
	
	// Create a scrollview on the position of the cropped node (we capture it's scroll events to position the cropped content)
	
	// The view has a topleft anchor point the UIPoint is bottomleft, so substracting height of the view to get topleft
	self.scrollView = [[ScrollNodeScrollView alloc] initWithFrame:CGRectMake(UIPoint.x, UIPoint.y - self.contentSizeInPoints.height, self.contentSizeInPoints.width, self.contentSizeInPoints.height)];
	
	// Set the content size in the UIScrollView this creates scrollbars and scroll area of the right size
	self.scrollView.contentSize = CGSizeMake(self.content.contentSizeInPoints.width, self.content.contentSizeInPoints.height);
	
	// Add it to the same view this director is on
	[[CCDirector sharedDirector].view addSubview:self.scrollView];
	
	// Be the delegate of the scrollview to capture scroll events
	self.scrollView.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// Update the scrollview content size if the content size of the content node changes
	if([keyPath isEqualToString:@"contentSize"] && self.scrollView)
	{
		// The scroll view contentsize will be at least the same size as the view, so you can allwasy "scroll" which is prettier then static
		self.scrollView.contentSize = CGSizeMake(self.content.contentSizeInPoints.width, MAX(self.content.contentSizeInPoints.height, self.scrollView.frame.size.height + 1));
	}
}

- (void)removeScrollView
{
	// Scroll non-animated to the current position, so it stops scrolling and can be removed (when removing while scrolling the system hangs, this is a workaround)
	[self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, 0, 0) animated:NO];
		
	// Remove scrollview
	[self.scrollView removeFromSuperview];
	self.scrollView = nil;
}

- (void)clear
{
	[self.content removeFromParent];
	[self removeScrollView];
}

- (CGRect)visibleFrame
{
	return CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.boundingBox.size.width, self.boundingBox.size.height);
}

- (void)dealloc
{
	[self.content removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
}

@end
