//
//  STKTileNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@class STKTile;

@interface STKTileNode : CCNode

// The current tile model for this node
@property (weak, readonly) STKTile *tile;

+ (id)newTileNodeWithTile:(STKTile *)tile;

@end
