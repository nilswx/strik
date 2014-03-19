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

// When friends are available, show friends! (call this)
- (void)showFriends;

- (void)showBottom;

- (void)hideBottom;

// Scroll all the way to the top of the table
- (void)scrollUp;

@end
