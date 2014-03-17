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

// Falling speed per second in UI points
#define FALLING_SPEED 1000

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_INDEX_BOARD_LINE,
	Z_INDEX_TILE_CONTAINER
};

@interface STKBoardNode()

// The background node
@property CCNodeColor *background;

// The first drop for all tiles shows all tiles where they should be instead of dropping them all down
@property BOOL isFirstDrop;

// The tile container (every tile must be placed in here)
@property CCNode *tileContainer;

@end

@implementation STKBoardNode

#pragma mark init
- (void)onEnter
{
	[super onEnter];
	
	// The initial drop places tiles at the bottom, so you won't see them fall
	self.isFirstDrop = YES;
	
	// Add the board lines
	[self addBoardLines];
	
	// Setup the tile container
	[self setupTileContainer];
}

- (void)addBoardLines
{
	// Vertical lines
	for(CGFloat x = TILE_SIZE; x < self.contentSizeInPoints.width; x += TILE_SIZE)
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
	for(CGFloat y = TILE_SIZE; y < self.contentSizeInPoints.height; y += TILE_SIZE)
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

- (void)setupTileContainer
{
	// Create the tilecontainer
	self.tileContainer = [CCNode node];
	self.tileContainer.contentSizeType = CCSizeTypeNormalized;
	self.tileContainer.contentSize = CGSizeMake(1, 1);
	
	self.tileContainer.anchorPoint = CGPointMake(0, 0);
	
	self.tileContainer.zOrder = Z_INDEX_TILE_CONTAINER;
	
	[self addChild:self.tileContainer];
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
	if(tiles)
	{
		// The starting Y position (they fall from this height)
		CGFloat startY;
		
		// The initial tiles are drawn where they should be
		if(self.isFirstDrop && tiles)
		{
			startY = TILE_SIZE;
			
			// There is only one first drop
			self.isFirstDrop = NO;
		}
		// And the new ones are drawn at top
		else
		{
			startY = self.scene.contentSizeInPoints.height;
		}
		
		// Todo: Fix this somehow that it knows other tiles are in place up there...
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
			STKTileNode *tileNode = [STKTileNode newTileNodeWithTile:tile andBoardNode:self];
			
			// Get the tile size
			CGSize tileSize = [tileNode contentSizeInPoints];
			
			// Get the Y position for the tile in this collumn
			CGFloat yPosition = [[yPositions objectAtIndex:tile.column] floatValue];
			
			// Get the X position for this tile
			CGFloat xPosition = tileSize.width * tile.column;
			
			// Position the tile
			tileNode.position = CGPointMake(xPosition, yPosition);
			
			// And add it to the physics world
			[self.tileContainer addChild:tileNode];
			
			// Increase Y Position for this collumn (so we can stack)
			yPosition += tileSize.height;
			[yPositions setObject:[NSNumber numberWithFloat:yPosition] atIndexedSubscript:tile.column];
		}
	}
}

#pragma mark Moving of tiles
- (void)update:(CCTime)delta
{
	[self moveTiles:delta];
}

- (void)moveTiles:(CCTime)delta
{
	// Note: The tiles are added bottom left (the tiles anchor point is top left) so 0.0 would just move the tile bottom left ouff screen tile height.tile height would move it at bottom left in screen
	
	// The maximum distance to move (when possible)
	CGFloat maxDistanceToMove = delta * FALLING_SPEED;
	
	// Itterate over every tile and move it the required distance
	for(STKTileNode *tileNode in self.tileContainer.children)
	{
		STKTile *tile = tileNode.tile;
		
		CGFloat currentY = tileNode.position.y;
		
		// This is the minimum Y a tile can have for its position (e.g on the bottom of the screen or just above another node)
		CGFloat minY = (tile.row + 1) * TILE_SIZE;
		
		// We can still move a certain distance
		if(currentY > minY)
		{
			// Determine the space available to move
			CGFloat currentSpaceToMove = currentY - minY;
			
			// Calculating the distance to move based on maximum space to move at this speed and the available space
			CGFloat distanceToMove = MIN(maxDistanceToMove, currentSpaceToMove);
			
			// And move given distance
			tileNode.position = CGPointMake(tileNode.position.x, currentY - distanceToMove);
		}
	}
}

- (void)dealloc
{
	[self removeAsObserverForAllModels];
}
@end
