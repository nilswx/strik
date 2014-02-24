//
//  STKLobbyPersonNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 24/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@class STKFriend, STKAvatarNode;

@interface STKLobbyPersonNode : CCNode

// The friend for this cell
@property (nonatomic) STKFriend *friend;

// The nodes
@property STKAvatarNode *avatarNode;

@property CCLabelTTF *playerNameLabel;

@property CCLabelTTF *realNameLabel;

@property CCNodeColor *bottomLine;

@property CCNodeColor *backgroundNode;

@property CCSprite *icon;

// Loads the ccbi from nib and sets friend property
+ (STKLobbyPersonNode *)newLobbyPersonNodeWithFriend:(STKFriend *)friend;

@end
