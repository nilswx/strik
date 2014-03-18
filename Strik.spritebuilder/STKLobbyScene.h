//
//  STKLobbyScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class GridNode;

@interface STKLobbyScene : STKScene

@property GridNode *friendsGridNode;

// This node will be place at the bottom of the screen behind the table @ 50% height, so when the last item color is blue-ish, it doesnt end @ scrolling bottom
@property CCNodeColor *bottomColorNode;

// When friends are available, show friends! (call this)
- (void)showFriends;

@end
