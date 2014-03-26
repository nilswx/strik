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

#import "STKTileNode.h"

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
	[self checkPlayerSelectionWithChangedTiles:tiles];
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

- (void)checkPlayerSelectionWithChangedTiles:(NSArray *)tiles
{
	// No need to unselect if there is nothing selected
	if(self.selectedTiles.count > 0)
	{
		// Determine if one of the tiles are below or at the position of one of the player selected tiles. This would cause the selection to change so we cancel it
		
		// Itterate through each selected tile
		for(STKTile *selectedTile in self.selectedTiles.internalData)
		{
			// And compare it with each tile which changed
			for(STKTile *changedTile in tiles)
			{
				// If the changedTile is at the same column and same row (or below) it affects player selection
				if(changedTile.column == selectedTile.column && changedTile.row <= selectedTile.row)
				{
					// So cancel player selection
					[self clearSelectionFor:self.player];
					
					// And no need to search for more after one hit
					return;
				}
			}
		}
	}
}

// Animate found tiles
- (void)wordFoundWithTiles:(NSArray *)tiles byPlayer:(STKMatchPlayer *)player
{
	[self updateShadowsForTiles:tiles forPlayer:player];

	// When the opponent made a selection we might need to unselect ours
	if(player != self.player)
	{
		[self checkPlayerSelectionWithChangedTiles:tiles];
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
	if(self.tiles.count > position.column && ((NSArray *)self.tiles[position.column]).count > position.row)
	{
		return self.tiles[position.column][position.row];
	}
	return nil;
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
		
		[self updateShadowsForTiles:self.selectedTiles.internalData forPlayer:self.player];
	}
}

- (void)updateShadowsForTiles:(NSArray *)tiles forPlayer:player
{
	// Go through every tile and determine if it should have a selection
	for(STKTile *tile in tiles)
	{
		// Clear the old shadows
		[tile.node clearShadows];
		
		// Don't change the order it matches the ShadowPosition
		static int DIRECTIONS[4][2] = {
			{0, +1}, // North
			{+1, 0}, // East
			{0, -1}, // South
			{-1, 0} // West
		};
		
		for(int i = 0; i < 4; i++)
		{
			int *direction = DIRECTIONS[i];
			
			STKTilePosition neighbourPosition;
			neighbourPosition.column = tile.column + direction[0];
			neighbourPosition.row = tile.row + direction[1];
			
			STKTile *neighbour = [self tileAtPoint:neighbourPosition];
			if(neighbour && ![neighbour isSelectedBy:player])
			{
				[tile.node addShadowForPosition:i];
			}
		}
	}
}

- (void)clearSelectionFor:(STKMatchPlayer*)player
{
	// Clear this players selection on all tiles
	for(STKTile* tile in [self.tileIndex allValues])
	{
		[tile deselectFor:player];
		[tile.node clearShadows];
	}
	
	if(player == self.player)
	{
		[self.selectedTiles clear];
	}
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
