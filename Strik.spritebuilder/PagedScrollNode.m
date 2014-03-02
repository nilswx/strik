//
//  STKPagedScrollNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 02/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "PagedScrollNode.h"
#import "PagedScrollNodeDataSource.h"

@interface PagedScrollNode()

@property NSObject<PagedScrollNodeDataSource> *dataSource;

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
}

- (void)setupPageControl
{
	
}

- (void)clearContent
{
	NSArray *children = [NSArray arrayWithArray:self.content.children];
	for(CCNode *child in children)
	{
		[child removeFromParent];
	}
}

- (CGPoint)positionForPage:(int)page
{
	return CGPointMake(self.dataSource.pageSize.width * page, 0);
}

- (void)onEnter
{
	[super onEnter];
	
	// We want paging here
	self.scrollView.pagingEnabled = YES;
}

@end
