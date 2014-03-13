//
//  STKBoardNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKBoardNode.h"
#import "STKTileNode.h"

#import "STKBoard.h"
#import "STKTile.h"

#import "NSObject+Observer.h"

#define BOARD_LINE_COLOR [CCColor colorWithWhite:0 alpha:0.3f]
#define LINE_PADDING 64.5f

typedef NS_ENUM(NSInteger, zIndex)
{
	
	Z_INDEX_BOARD_LINE
};

@interface STKBoardNode()

// The background node
@property CCPhysicsNode *background;

// The first drop for all tiles shows all tiles where they should be instead of dropping them all down
@property BOOL isFirstDrop;

@end

@implementation STKBoardNode

#pragma mark init
- (void)onEnter
{
	[super onEnter];
	
	// The initial drop places tiles at the bottom, so you won't see them fall
	self.isFirstDrop = YES;
	
	[self addBoardLines];
}

- (void)addBoardLines
{
	// Vertical lines
	for(CGFloat x = LINE_PADDING; x < self.contentSizeInPoints.width; x += LINE_PADDING)
	{
		CCNodeColor *verticalLine = [CCNodeColor nodeWithColor:BOARD_LINE_COLOR];

		// Size is full height and 1px width
		verticalLine.contentSizeType = CCSizeTypeMake(CCSizeUnitPoints, CCSizeUnitNormalized);
		verticalLine.contentSize = CGSizeMake(0.5, 1);
		
		verticalLine.position = CGPointMake(x, 0);
		verticalLine.zOrder = Z_INDEX_BOARD_LINE;
		
		[self addChild:verticalLine];
	}
	
	// Horizontal lines
	for(CGFloat y = LINE_PADDING; y < self.contentSizeInPoints.height; y += LINE_PADDING)
	{
		CCNodeColor *horizontalLine = [CCNodeColor nodeWithColor:BOARD_LINE_COLOR];
		
		// Size is full width and 1px height
		horizontalLine.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);
		horizontalLine.contentSize = CGSizeMake(1, 0.5);
		
		horizontalLine.position = CGPointMake(0, y);
		horizontalLine.zOrder = Z_INDEX_BOARD_LINE;
		
		[self addChild:horizontalLine];
	}
}

- (void)setBoard:(STKBoard *)board
{
	if(_board)
	{
		NSAssert(false, @"Can only assign board once!");
	}
	
	if(board)
	{
		_board = board;
		[self observeModel:board];
	}
}

#pragma mark model events
- (void)board:(STKBoard *)board valueChangedForFreshTiles:(NSArray *)freshTiles
{
	[self insertNodeFromTiles:freshTiles];
}

- (void)insertNodeFromTiles:(NSArray *)tiles
{
	// The starting Y position (they fall from this height)
	CGFloat startY;
	
	// The initial tiles are drawn where they should be
	if(self.isFirstDrop)
	{
		startY = LINE_PADDING;
	}
	// And the new ones are drawn at top
	else
	{
		startY = self.scene.contentSizeInPoints.height;
	}
	
	// The Y position might be different for different collumns while adding (e.g an L shape)
	NSMutableArray *yPositions = [NSMutableArray arrayWithCapacity:self.board.size.width];
	for(int col = 0; col < self.board.size.width; col++)
	{
		[yPositions addObject:[NSNumber numberWithFloat:startY]];
	}
	
	// Loop through every tile and position them
	for(STKTile *tile in tiles)
	{
		// Create a new tile node for this tile
		STKTileNode *tileNode = [STKTileNode newTileNodeWithTile:tile];
		
		// Get the tile size
		CGSize tileSize = [tileNode contentSizeInPoints];
		
		// Get the Y position for the tile in this collumn
		CGFloat yPosition = [[yPositions objectAtIndex:tile.column] floatValue];
		
		// Get the X position for this tile
		CGFloat xPosition = tileSize.width * tile.column;
		
		// Position the tile
		tileNode.position = CGPointMake(xPosition, yPosition);
		
		// And add it to the physics world
		[self.physicsWorld addChild:tileNode];
		
		// Increase Y Position for this collumn (so we can stack)
		yPosition += tileSize.height;
		[yPositions setObject:[NSNumber numberWithFloat:yPosition] atIndexedSubscript:tile.column];
	}
}


- (void)dealloc
{
	[self removeAsObserverForAllModels];
}
@end
