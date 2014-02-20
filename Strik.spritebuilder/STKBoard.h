//
//  STKBoard.h
//  Strik
//
//  Created by Matthijn on Oct 23, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
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

@class STKTileSelectionBuffer, NSStack;

@interface STKBoard : STKModel

@property (readonly) CGSize size;
@property (readonly) NSArray *freshTiles;

// Who's wo?
@property (readonly) STKMatchPlayer* player;
@property (readonly) STKMatchPlayer* opponent;

@property (readonly) NSStack *selectedTiles;

- (id)initWithSize:(CGSize)size andPlayer:(STKMatchPlayer*)player andOpponent:(STKMatchPlayer*)opponent andSelectionBuffer:(STKTileSelectionBuffer*)selectionBuffer;
+ (id)boardWithSize:(CGSize)size andPlayer:(STKMatchPlayer*)player andOpponent:(STKMatchPlayer*)opponent  andSelectionBuffer:(STKTileSelectionBuffer*)selectionBuffer;

- (STKTile *)tileWithTileId:(SInt8)tileId;
- (STKTile *)tileAtPoint:(STKTilePosition)position;
- (int)rowForTile:(STKTile *)tile;

- (void)addNewTiles:(NSArray *)tiles;

- (void)selectTile:(STKTile *)tile;
- (void)clearSelectionFor:(STKMatchPlayer*)player;
- (void)endSelection;

- (void)removeTile:(STKTile *)tile;
- (void)removeTiles:(NSArray *)tiles;

// Determine the relative position of the tile seen from the other tile. E.g if you stand on "other tile" which direction do you have to look to see the tile?
// Works only for direct neightbors!
- (STKBoardDirection)directionFromTile:(STKTile *)originTile toTile:(STKTile *)tile;

@end