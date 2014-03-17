//
//  STKGameScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 10/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class STKMatch, STKBoardNode;

@interface STKGameScene : STKScene

// The match object
@property (weak, nonatomic) STKMatch *match;

// The board node for this scene
@property (readonly) STKBoardNode *boardNode;

// Call this to start the local timer
- (void)startTimer;

@end
