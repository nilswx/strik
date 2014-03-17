//
//  STKTile.h
//  Strik
//
//  Created by Matthijn Dijkstra on 13/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKModel.h"

typedef struct {
    int column;
    int row;
} STKTilePosition;

@class STKBoard, STKMatchPlayer, STKTileNode;

@interface STKTile : STKModel

// The Id for the tile
@property (nonatomic, readonly) SInt8 tileId;

// The board where the tile is on
@property (nonatomic, weak, readonly) STKBoard *board;

// The position of the tile
@property (nonatomic, readonly) STKTilePosition position;
@property (nonatomic, readonly) int column;
@property (nonatomic, readonly) int row;

// The letter of the tile
@property (nonatomic, assign) char letter;

// Determine if it is still on the board
@property (nonatomic) BOOL isRemoved;

// Will be set when there is a node for this tile
@property (weak) STKTileNode *node;

// Init
- (id)initWithBoard:(STKBoard *)board column:(int)column andTileId:(SInt8)tileId;
+ (id)tileForBoard:(STKBoard *)board column:(int)column andTileId:(SInt8)tileId;

// Selection
- (void)selectFor:(STKMatchPlayer*)player;
- (void)deselectFor:(STKMatchPlayer*)player;

// Determine selection
- (BOOL)isSelectedBy:(STKMatchPlayer*)player;

@end
