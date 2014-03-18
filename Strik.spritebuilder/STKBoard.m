//
//  STKBoard.m
//  Strik
//
//  Created by Matthijn Dijkstra on 13/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKBoard.h"

#import "NSStack.h"
#import "STKOutgoingMessage.h"

#import "STKGameController.h"

@interface STKBoard()

// The tiles
@property (nonatomic, strong) NSMutableArray *tiles; // [col][tiles in col]
@property (nonatomic, strong) NSMutableDictionary *tileIndex; // Just a fast lookup

// The size of the board (col and rows)
@property (nonatomic, assign) CGSize size;

// The tiles currently selected by the player
@property (nonatomic, strong) NSStack *selectedTiles;

// New tiles which just arrived from the server
@property (nonatomic, strong) NSArray *freshTiles;

// The players
@property STKMatchPlayer *player;
@property STKMatchPlayer *opponent;

@end

@implementation STKBoard

#pragma mark init
- (id)initWithSize:(CGSize)size player:(STKMatchPlayer *)player andOpponent:(STKMatchPlayer *)opponent
{
	if(self = [super init])
	{
		// Create the stack
		self.selectedTiles = [NSStack stack];
		
		// Set the players
		self.player = player;
		self.opponent = opponent;
		
		// Setup the arrays to hold the tiles
		[self setupDataContainerWithSize:size];
	}
	return self;
}

+ (id)boardWithSize:(CGSize)size player:(STKMatchPlayer *)player andOpponent:(STKMatchPlayer *)opponent
{
	return [[STKBoard alloc] initWithSize:size player:player andOpponent:opponent];
}

- (void)setupDataContainerWithSize:(CGSize)size
{
	// Set the size
	self.size = size;
	
	// Fill the array with x and y
	self.tiles = [NSMutableArray arrayWithCapacity:self.size.width];
	for(int col = 0; col < self.size.width; col++)
	{
		self.tiles[col] = [NSMutableArray arrayWithCapacity:self.size.height];
	}
	
	// And create the dict for fast lookup
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

// Animate found tiles
- (void)wordFoundWithTiles:(NSArray *)tiles byPlayer:(STKMatchPlayer *)player
{
	NSLog(@"Tiles for word: %@", tiles);
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
	if(tile != [self.selectedTiles peek])
	{
		// Determine if the tile is the tile before the current tile. If so deselect the last tile on the stack
		if(tile == [self.selectedTiles peekAtIndex:self.selectedTiles.count - 2])
		{
			STKTile *lastTile = [self.selectedTiles pop];
			[lastTile deselectFor:self.player];
		}
		// It is a new tile, mark it as selected
		else
		{
			// Already select it clientside (no latency!)
			[tile selectFor:self.player];
			
			// Maintain selected tiles here
			[self.selectedTiles pushObject:tile];
		}
	}
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

#pragma mark networking
- (void)sendSelection
{
	NSLog(@"Sending words %@", self.selectedTiles);
	
	if(self.selectedTiles.count > 0)
	{
		// Create the outgoing message
		STKOutgoingMessage *message = [STKOutgoingMessage withOp:SELECT_TILES];
		[message appendByte:self.selectedTiles.count];
		
		// Itterate of tiles
		for(STKTile *tile in self.selectedTiles.internalData)
		{
			[message appendByte:tile.tileId];
		}
		
		// Send it out to the great wide world, bye bye!
		[self.gameController sendNetMessage:message];
		
		// and clear
		[self.selectedTiles clear];
	}
}

@end
