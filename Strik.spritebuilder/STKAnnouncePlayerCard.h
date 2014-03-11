//
//  STKAnnouncePlayerCard.h
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@class STKAvatarNode, STKProgressNode, STKLevelNode;

@interface STKAnnouncePlayerCard : CCNode

// The name
@property (readonly) CCLabelTTF *nameLabel;

// The avatar of the user
@property (readonly) STKAvatarNode *avatarNode;

// The level of the user
@property (readonly) STKLevelNode *levelNode;

// The progress within level
@property (readonly) STKProgressNode *progressNode;

// The bottom color
@property (readonly) CCNodeColor *bottomLine;

@end
