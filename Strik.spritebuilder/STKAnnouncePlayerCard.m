//
//  STKAnnouncePlayerCard.m
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAnnouncePlayerCard.h"

#import "STKAvatarNode.h"
#import "STKProgressNode.h"
#import "STKLevelNode.h"

@interface STKAnnouncePlayerCard()

// The name
@property CCLabelTTF *nameLabel;

// The avatar of the user
@property STKAvatarNode *avatarNode;

// The level of the user
@property STKLevelNode *levelNode;

// The progress within level
@property STKProgressNode *progressNode;

// The bottom color
@property CCNodeColor *bottomLine;

@end

@implementation STKAnnouncePlayerCard

@end
