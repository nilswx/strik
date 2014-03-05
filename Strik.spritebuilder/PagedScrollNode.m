//
//  STKPagedScrollNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 02/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "PagedScrollNode.h"
#import "PagedScrollNodeDataSource.h"

#define CIRCLE_PADDING 2
#define CIRCLE_RADIUS 4

#define DEFAULT_ACTIVE_PAGE_CONTROL_DOT_COLOR [CCColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f]
#define DEFAULT_PAGE_CONTROL_DOT_COLOR [CCColor colorWithRed:170.0f/255.0f green:170.0f/255.0f blue:170.0f/255.0f];

@interface PagedScrollNode()

// The data source for this page system
@property NSObject<PagedScrollNodeDataSource> *dataSource;

// The dots container @ the bottom
@property CCNode *pageControlContainer;

// The left an right button of the page control (to tap to move to another page)
@property CCButton *pageControlLeftButton;
@property CCButton *pageControlRightButton;

// The current page
@property int currentPage;

@end

@implementation PagedScrollNode

- (id)initWithDataSource:(NSObject<PagedScrollNodeDataSource> *)dataSource
{
	CCNode *node = [CCNode node];
	if(self = [super initWithContent:node])
	{
		node.contentSizeType = CCSizeTypePoints;
		self.dataSource = dataSource;
		
		[self reload];
	}
		
	return self;
}

+ (id)pagedScrollNodeWithDataSource:(NSObject<PagedScrollNodeDataSource> *)dataSource
{
	return [[PagedScrollNode alloc] initWithDataSource:dataSource];
}

- (void)reload
{
	// Clear the old content
	[self clearContent];

	// Resize the content to fit every page
	self.content.contentSize = CGSizeMake(self.dataSource.pageSize.width * self.dataSource.numberOfPages, self.dataSource.pageSize.height);
	
	// Ad every page
	for(int i = 0; i < self.dataSource.numberOfPages; i++)
	{
		// Get the node
		CCNode *node = [self.dataSource nodeForPage:i];

		// Position it
		node.anchorPoint = CGPointMake(0, 0);
		node.position = [self positionForPage:i];
		
		// And add to content
		[self.content addChild:node];
	}
	
	// Setup the dots for page control
	[self setupPageControl];
	[self setupPageControlButtons];
}

#pragma mark Page Control
- (void)setupPageControl
{
	// Remove the old page control
	[self.pageControlContainer removeFromParent];
	
	// Calculate width and height for the pageControlContainer
	int numberOfPages = self.dataSource.numberOfPages;
	
	CGSize containerSize;
	CGFloat diameter = CIRCLE_RADIUS * 2;
	
	// The width is calculated differently based on the number of dots (e.g 1, 2 or more dots)
	if(numberOfPages > 0)
	{
		if(numberOfPages == 1)
		{
			containerSize = CGSizeMake(diameter, diameter);
		}
		else if(numberOfPages == 2)
		{
			containerSize = CGSizeMake(diameter * 2 + CIRCLE_PADDING * 2, diameter);
		}
		else
		{
			CGFloat sumCircles = diameter * numberOfPages;
			CGFloat sumPadding = (CIRCLE_PADDING * 2) * (numberOfPages - 1);
			containerSize = CGSizeMake(sumCircles + sumPadding, diameter);
		}
	}
	
	// Create container with correct size
	self.pageControlContainer = [CCNode node];
	self.pageControlContainer.contentSizeType = CCSizeTypePoints;
	self.pageControlContainer.contentSize = containerSize;
	
	// Center it
	self.pageControlContainer.anchorPoint = CGPointMake(0.5, 0.5);
	self.pageControlContainer.position = CGPointMake(self.dataSource.pageSize.width / 2,
									   diameter + CIRCLE_RADIUS);
	
	[self addChild:self.pageControlContainer];
	
	// Add childnodes in it, drawing from left to right
	for (int i = 0; i < numberOfPages; i++)
	{
		CCDrawNode *circle = [CCDrawNode node];
		circle.position = CGPointMake((diameter * i + (CIRCLE_PADDING * 2) * i) + CIRCLE_RADIUS, CIRCLE_RADIUS);
		
		circle.color = [CCColor purpleColor];
		[self.pageControlContainer addChild:circle];
	}
	
	// Make sure the circles have the correct colors
	[self updatePageControlWithPage:0];
}

- (void)updatePageControlWithPage:(int)currentPage
{
	// Get the circle for the current page
	CCDrawNode *activeCircle = [self.pageControlContainer.children objectAtIndex:currentPage];
	
	// Loop through all circles, color them based on state
	for(CCDrawNode *child in self.pageControlContainer.children)
	{
		// Clear the old dot
		[child clear];
			
		// Get the color for this node
		CCColor *currentcolor;
		if(child != activeCircle)
		{
			currentcolor = self.pageControlDotColor;
		}
		else
		{
			currentcolor = self.acctivePageControlDotColor;
		}
		
		// And draw correct color
		[child drawDot:CGPointMake(0, 0) radius:CIRCLE_RADIUS color:currentcolor];
	}
}

- (void)setupPageControlButtons
{
	// Defaults for both buttons
	CGSize buttonSize = CGSizeMake(self.dataSource.pageSize.width / 2, CIRCLE_RADIUS * 8);
	CCPositionType buttonPositionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerBottomLeft);
	CGPoint buttonAnchor = CGPointMake(0, 0);
	
	// Left butotn
	self.pageControlLeftButton = [CCButton node];
	
	// Place and size left button
	self.pageControlLeftButton.contentSize = buttonSize;
	self.pageControlLeftButton.preferredSize = buttonSize;
	self.pageControlLeftButton.anchorPoint = buttonAnchor;
	self.pageControlLeftButton.positionType = buttonPositionType;
	self.pageControlRightButton.position = CGPointMake(0, 0);

	// Set target and add
	[self.pageControlLeftButton setTarget:self selector:@selector(onPageControlLeftButton:)];
	[self addChild:self.pageControlLeftButton];
	
	// Right button
	self.pageControlRightButton = [CCButton node];

	// Place and size
	self.pageControlRightButton.contentSize = buttonSize;
	self.pageControlRightButton.preferredSize = buttonSize;
	self.pageControlRightButton.anchorPoint = buttonAnchor;
	self.pageControlRightButton.positionType = buttonPositionType;
	self.pageControlRightButton.position = CGPointMake(self.dataSource.pageSize.width / 2, 0);
	
	// Set target and add
	[self.pageControlRightButton setTarget:self selector:@selector(onPageControlRightButton:)];
	[self addChild:self.pageControlRightButton];
}

- (void)onPageControlLeftButton:(CCButton *)button
{
	[self scrollToPage:MAX(0, self.currentPage - 1) animated:YES];
}

- (void)onPageControlRightButton:(CCButton *)button
{
	[self scrollToPage:MIN(self.dataSource.numberOfPages - 1, self.currentPage + 1) animated:YES];
}

- (void)scrollToPage:(int)page animated:(BOOL)animated
{
	[self.scrollView scrollRectToVisible:CGRectMake(self.dataSource.pageSize.width * page, 0, self.dataSource.pageSize.width, self.dataSource.pageSize.height) animated:animated];
} 

- (void)clearContent
{
	NSArray *children = [NSArray arrayWithArray:self.content.children];
	for(CCNode *child in children)
	{
		[child removeFromParent];
	}
	
	[self.pageControlContainer removeFromParent];
	[self.pageControlLeftButton removeFromParent];
	[self.pageControlRightButton removeFromParent];
}

- (CGPoint)positionForPage:(int)page
{
	return CGPointMake(self.dataSource.pageSize.width * page, 0);
}

#pragma mark Cocos2d events
- (void)onEnter
{
	[super onEnter];
	
	// We want paging here and no visibe scrollbars
	self.scrollView.pagingEnabled = YES;
	
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
}

#pragma mark UIScrollViewDelegate events
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[super scrollViewDidScroll:scrollView];
	
	// Determine if we scrolled a full page
	float scrolled = (self.scrollView.contentOffset.x / self.dataSource.pageSize.width);
	// When the result is a integral number, that is the page we are on now
	if(scrolled == (int)scrolled)
	{
		int page = (int)scrolled;
		
		// Set the current page as property
		self.currentPage = page;

		// And update the dots
		[self updatePageControlWithPage:page];
	}
}

// Defaulting the colors here
- (CCColor *)pageControlDotColor
{
	if(!_pageControlDotColor)
	{
		return DEFAULT_PAGE_CONTROL_DOT_COLOR;
	}
	return _pageControlDotColor;
}

- (CCColor *)acctivePageControlDotColor
{
	if(!_acctivePageControlDotColor)
	{
		return DEFAULT_ACTIVE_PAGE_CONTROL_DOT_COLOR;
	}
	return _acctivePageControlDotColor;
}

@end
