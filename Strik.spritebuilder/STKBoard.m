//
//  STKBoard.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/11/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKBoard.h"

#import "NSStack.h"

@interface STKBoard()

@property (nonatomic, strong) NSMutableArray *tiles; // [col][tiles in col]
@property (nonatomic, strong) NSMutableDictionary *tileIndex; // Just a fast lookup

@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) NSStack *selectedTiles;
@property (nonatomic, strong) STKTileSelectionBuffer *selectionBuffer;

@property (nonatomic, strong) NSArray *freshTiles;

@end

@implementation STKBoard

#pragma Init
- (id)initWithSize:(CGSize)size andPlayer:(STKMatchPlayer*)player andOpponent:(STKMatchPlayer*)opponent andSelectionBuffer:(STKTileSelectionBuffer*)selectionBuffer
{
    self = [super init];
    if(self)
    {
        self.selectedTiles = [NSStack stack];
		
		self->_player = player;
		self->_opponent = opponent;
		
		self.selectionBuffer = selectionBuffer;
		
		[self setupDataContainerWithSize:size];
    }
    return self;
}

+ (id)boardWithSize:(CGSize)size andPlayer:(STKMatchPlayer*)player andOpponent:(STKMatchPlayer*)opponent andSelectionBuffer:(STKTileSelectionBuffer*)selectionBuffer
{
    return [[STKBoard alloc] initWithSize:size andPlayer:player andOpponent:opponent andSelectionBuffer:selectionBuffer];
}

- (void)setupDataContainerWithSize:(CGSize)size
{
	self.size = size;
	
	self.tiles = [NSMutableArray arrayWithCapacity:self.size.width];
	for(int col = 0; col < self.size.width; col++)
	{
		self.tiles[col] = [NSMutableArray arrayWithCapacity:self.size.height];
	}
	
	self.tileIndex = [NSMutableDictionary dictionary];
}

#pragma mark Deletion and insertion of tiles
- (void)removeTiles:(NSArray *)tiles
{
	for(STKTile *tile in tiles)
	{
		[self removeTile:tile];
	}
}

- (void)removeTile:(STKTile *)tile
{
	// Remove it from the array and dict
	[self.tileIndex removeObjectForKey:@(tile.tileId)];
	[self.tiles[tile.position.column] removeObject:tile];
	
	// Get rid of it
	tile.isRemoved = YES;
}

- (void)addNewTiles:(NSArray *)tiles
{
	for(STKTile *tile in tiles)
	{
		[self addTile:tile];
	}
	self.freshTiles = tiles;
}

- (void)addTile:(STKTile *)tile
{
	if(tile.column < self.size.width)
	{
		NSMutableArray *column = [self.tiles objectAtIndex:tile.column];
		[column addObject:tile];

		NSNumber *ID = [NSNumber numberWithInt:tile.tileId];
		self.tileIndex[ID] = tile;
	}
}

#pragma Information about Tiles
- (int)rowForTile:(STKTile *)tile
{
	NSMutableArray *column = self.tiles[tile.column];
	return (int)[column indexOfObject:tile];
}

- (STKTile *)tileAtPoint:(STKTilePosition)position
{
	return self.tiles[position.column][position.row];
}

- (STKTile *)tileWithTileId:(SInt8)tileId
{
	NSNumber *ID = [NSNumber numberWithInt:tileId];
	
	return self.tileIndex[ID];
}

- (STKBoardDirection)directionFromTile:(STKTile *)originTile toTile:(STKTile *)tile;
{
	static int8_t STKBOARD_DIRECTIONS[8][3] = {
		// North
		{0, 1},
		// North East
		{1, 1},
		// East
		{1, 0},
		// South East
		{1, -1},
		// South
		{0, -1},
		// South West
		{-1, -1},
		// West
		{-1, 0},
		// North West
		{-1, 1}
	};
	
	for(int currentDirection = 0; currentDirection < STKBoardDirectionUnknown; currentDirection++)
	{
		int8_t *directionOffset = STKBOARD_DIRECTIONS[currentDirection];
		if(
		   (tile.column == originTile.column + directionOffset[0]) &&
		   (tile.row == originTile.row + directionOffset[1])
		   )
		{
			return currentDirection;
		}
	}
	
	return STKBoardDirectionUnknown;
}

#pragma mark Selection of Tiles
- (void)selectTile:(STKTile *)tile
{
	// Already select it clientside (no latency!)
	[tile selectFor:self.player];
	
	// Maintain selected tiles here
	[self.selectedTiles pushObject:tile];
	
    // Add it to the tile selection buffer so it can find its way over the world wide web
    // TODO: aaah
}

- (void)clearSelectionFor:(STKMatchPlayer*)player
{
	// Clear this players selection on all tiles
	for(STKTile* tile in [self.tileIndex allValues])
	{
		[tile deselectFor:player];
	}
	[self.selectedTiles clear];
}

- (void)endSelection
{
    // Make sure any tile selection is flushed now
	// TODO: aaah
}

@end
