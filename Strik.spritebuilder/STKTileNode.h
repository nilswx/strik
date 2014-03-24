//
//  STKTileNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

#define TILE_SIZE 64.5f

// Don't change the order, thank you :)
typedef NS_ENUM(NSInteger, ShadowPosition)
{
	ShadowPositionTop = 0,
	ShadowPositionRight = 1,
	ShadowPositionBottom = 2,
	ShadowPositionLeft = 3
};

@class STKTile, STKBoardNode;

@interface STKTileNode : CCNode

// The current tile model for this node
@property (weak, readonly) STKTile *tile;

+ (id)newTileNodeWithTile:(STKTile *)tile andBoardNode:(STKBoardNode *)boardNode;

// Clear the shadows from this tile
- (void)clearShadows;

// Add a new shadow
- (void)addShadowForPosition:(ShadowPosition)shadowPosition;

@end
