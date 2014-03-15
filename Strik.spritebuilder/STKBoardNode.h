//
//  STKBoardNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 12/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@class STKBoard;

@interface STKBoardNode : CCNodeColor

// The board for this node (who would have thought that by reading the name)
@property (nonatomic, weak) STKBoard *board;

// The physics world, tiles should be spawned in here
@property (weak) CCPhysicsNode *physicsWorld;

// When a tile is removed, move it foromt he physicsWorld to the background Physicis World, it will fall out of screen
@property (weak) CCPhysicsNode *backgroundPhysicsWorld;

@end
