//
//  STKBoard.h
//  Strik
//
//  Created by Matthijn Dijkstra on 13/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKModel.h"

#import "STKTile.h"

typedef NS_ENUM(int8_t, STKBoardDirection)
{
	STKBoardDirectionNorth = 0,
	STKBoardDirectionNorthEast = 1,
	STKBoardDirectionEast = 2,
	STKBoardDirectionSouthEast = 3,
	STKBoardDirectionSouth = 4,
	STKBoardDirectionSouthWest = 5,
	STKBoardDirectionWest = 6,
	STKBoardDirectionNorthWest = 7,
	STKBoardDirectionUnknown = 8
};

@class STKMatchPlayer, NSStack, STKGameController;

@interface STKBoard : STKModel

// The tiles which just where received from the server will be stored in here
@property (readonly) NSArray *freshTiles;

// The size of the board (in collumns and rows)
@property (readonly) CGSize size;

// So we can determine who is who
@property (readonly) STKMatchPlayer *player;
@property (readonly) STKMatchPlayer *opponent;

// The tiles currently selected by the player
@property (readonly) NSStack *selectedTiles;

// The game controller for this board
@property (weak) STKGameController *gameController;

// Init
- (id)initWithSize:(CGSize)size player:(STKMatchPlayer *)player andOpponent:(STKMatchPlayer *)opponent;
+ (id)boardWithSize:(CGSize)size player:(STKMatchPlayer *)player andOpponent:(STKMatchPlayer *)opponent;

// Get tiles
- (STKTile *)tileWithTileId:(SInt8)tileId;
- (STKTile *)tileAtPoint:(STKTilePosition)position;
- (int)rowForTile:(STKTile *)tile;

// Add tiles
- (void)addNewTiles:(NSArray *)tiles;

// Select tiles
- (void)selectTile:(STKTile *)tile;
- (void)clearSelectionFor:(STKMatchPlayer*)player;

// Send selection to server
- (void)sendSelection;

// Remove tiles
- (void)removeTile:(STKTile *)tile;
- (void)removeTiles:(NSArray *)tiles;

// Animate found tiles
- (void)wordFoundWithTiles:(NSArray *)tiles byPlayer:(STKMatchPlayer *)player;

// Determine the relative position of the tile seen from the other tile. E.g if you stand on "other tile" which direction do you have to look to see the tile?
// Works only for direct neightbors!
- (STKBoardDirection)directionFromTile:(STKTile *)originTile toTile:(STKTile *)tile;

@end
