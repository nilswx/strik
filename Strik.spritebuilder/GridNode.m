//
//  STKGridNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 13/11/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "GridNode.h"

#import "STKTimelineItemNode.h"

// The distance to load ahead (e.g it loads x% of the container node size before it is displayed so it wont' pop in during scrolling)
#define PRELOAD_DISTANCE 1.2

@interface GridNode()

@property (nonatomic, weak) NSObject<GridNodeDataSource> *dataSource;

// Keeping track of the current top row, so we only update when this has changed and not every scroll pixel, but we need to have moved at least enough for a new node to appear
@property int currentTopRow;

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

- (void)setupScrollView
{
	[super setupScrollView];
	[self setupTapDetection];
}

- (void)setupTapDetection
{
	// Detect single tapping
	UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewWasTapped:)];
	
	singleTap.numberOfTapsRequired = 1;
	singleTap.numberOfTouchesRequired = 1;
	singleTap.cancelsTouchesInView = YES;
	
	[self.scrollView addGestureRecognizer:singleTap];
}

- (void)scrollViewWasTapped:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		CGPoint point = [sender locationInView:[[self.scrollView subviews] firstObject]];
		CGPoint nodeLocation = CGPointMake([self columnForXOffset:point.x], [self rowForYOffset:point.y + self.scrollView.frame.size.height]);
		
		if(self.delegate)
		{
			if(nodeLocation.y <= self.dataSource.rowCount && nodeLocation.x <= self.dataSource.columnCount)
			{
				[self.delegate tappedNodeAtColumn:nodeLocation.x andRow:nodeLocation.y];
			}
		}
	}
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
	// Determine if we moved enough to display a new node
	if([self gridNodeNeedsUpdate])
	{
		// Remove nodes who are off screen
		[self removeHiddenNodes];
		
		// And display the nodes who are new and not yet on screen but within view bounds
		
		// Todo: In some distant future scroll vertically (not needed atm)
	//	for(CGFloat xOffset = visibleFrame.origin.x; xOffset < visibleFrame.origin.x + visibleFrame.size.width; xOffset += self.dataSource.cellSize.width)
		{
			for(CGFloat yOffset = self.visibleFrame.origin.y; yOffset < self.visibleFrame.origin.y + self.visibleFrame.size.height; yOffset += self.dataSource.cellSize.height)
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
}

- (BOOL)gridNodeNeedsUpdate
{
	// This determines if we need an update for the nodes since we scrolled a big enough distance (we don't want to update after every scroll)
	CGFloat topRow = [self rowForYOffset:self.visibleFrame.origin.y];
	if(topRow != self.currentTopRow)
	{
		self.currentTopRow = topRow;
		return YES;
	}
	
	return NO;
}

- (CGRect)visibleFrame
{
	// We are preloading a bit, so increasing visibel frame by preload distance
	CGRect visibleFrame = [super visibleFrame];
	return CGRectMake(visibleFrame.origin.x - (PRELOAD_DISTANCE / 2), visibleFrame.origin.y - (PRELOAD_DISTANCE / 2), visibleFrame.size.width * PRELOAD_DISTANCE, visibleFrame.size.height * PRELOAD_DISTANCE);
}

- (void)reload
{
	// We need something which will not be a valid row number
	self.currentTopRow = INT8_MIN;
	
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

- (void)removeHiddenNodes
{
	NSArray *children = [NSArray arrayWithArray:self.content.children];
	for(CCNode *child in children)
	{
		if(!CGRectIntersectsRect(self.visibleFrame, child.boundingBox))
		{
			[child removeFromParent];
		}
	}
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
