//
//  STKGridNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 13/11/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "GridNode.h"

// The distance to load ahead (e.g it loads x% of the container node size before it is displayed so it wont' pop in during scrolling)
#define PRELOAD_DISTANCE 1.1f

@interface GridNode()

@property (nonatomic, weak) NSObject<GridNodeDataSource> *dataSource;

@end

@implementation GridNode

- (id)initWithDataSource:(NSObject<GridNodeDataSource> *)dataSource
{
	CCNode *contentNode = [CCNode node];
	
	contentNode.contentSizeType = CCSizeTypePoints;
	contentNode.contentSize = CGSizeMake(dataSource.columnCount * dataSource.cellSize.width, dataSource.rowCount * dataSource.cellSize.height);
	 
	if(self = [super initWithContent:contentNode])
	{
		self.dataSource = dataSource;
	}
	
	return self;
}

+ (id)gridWithDataSource:(NSObject<GridNodeDataSource> *)dataSource
{
	return [[GridNode alloc] initWithDataSource:dataSource];
}

- (void)onEnter
{
	[super onEnter];
	[self reload];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[super scrollViewDidScroll:scrollView];

	[self displayNodes];
}

- (void)displayNodes
{
	// We want to preload a few nodes ahead
	CGRect visibleFrame = CGRectMake(self.visibleFrame.origin.x, self.visibleFrame.origin.y, self.visibleFrame.size.width * PRELOAD_DISTANCE, self.visibleFrame.size.height * PRELOAD_DISTANCE);

	// Todo, make it possible to scroll vertical in the grid node
	// Add any new nodes in the visible bounds
//	for(CGFloat xOffset = visibleFrame.origin.x; xOffset < visibleFrame.origin.x + visibleFrame.size.width; xOffset += self.dataSource.cellSize.width)
	{
		for(CGFloat yOffset = visibleFrame.origin.y; yOffset < visibleFrame.origin.y + visibleFrame.size.height; yOffset += self.dataSource.cellSize.height)
		{
			// Get the node for this row and collumn
			int row = [self rowForYOffset:yOffset];
//			int col = [self columnForXOffset:xOffset];
			int col = 0;
			
			// Break when there is more space then available nodes
			if(row == self.dataSource.rowCount)
			{
				break;
			}
						
			// Make sure there is a node to display (e.g there is only one node but room to display three)
			if((row < self.dataSource.rowCount && row >= 0) && (col < self.dataSource.columnCount && col >= 0))
			{
				CCNode *node = [self.dataSource nodeForColumn:col andRow:row];

				// Only add the node if it has not been added before
				if(!node.parent)
				{
					node.positionType = CCPositionTypeMake(CCPositionUnitPoints, CCPositionUnitPoints, CCPositionReferenceCornerTopLeft);
					node.anchorPoint = CGPointMake(0, 1);
					
					node.position = [self pointForNodeAtColumn:col andRow:row];
					[self.content addChild:node];
				}
			}
		}
	}
}

- (void)reload
{
	// Resize the content node so it updates the scroll area size
	self.content.contentSize = CGSizeMake(self.dataSource.columnCount * self.dataSource.cellSize.width, self.dataSource.rowCount * self.dataSource.cellSize.height);
	
	// And display the nodes if needed
	[self displayNodes];
}

- (void)clearContent
{
	NSArray *children = [NSArray arrayWithArray:self.content.children];
	for(CCNode *child in children)
	{
		[child removeFromParent];
	}
}

- (BOOL)isOnScreen:(SKNode *)node
{
	// TODO: For better performance determine if the node is visible so invisible nodes can be removed. (Al least i suspect that it improves performance)
	return YES;
}

- (int)columnForXOffset:(CGFloat)xOffset
{
	return MIN(MAX(0, floorf(xOffset / self.dataSource.cellSize.width)), self.dataSource.columnCount);
}

- (int)rowForYOffset:(CGFloat)yOffset
{
	return MAX(0, floorf(yOffset / self.dataSource.cellSize.height));
}

- (CGPoint)pointForNodeAtColumn:(int)column andRow:(int)row
{
	return CGPointMake(column * self.dataSource.cellSize.width, row * self.dataSource.cellSize.height);
}

@end
