//
//  STKChallengeScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 31/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class STKAvatarNode;

@interface STKChallengeScene : STKScene

@property (readonly) STKAvatarNode *avatarNode;
@property (readonly) CCLabelTTF *playerName;
@property (readonly) CCLabelTTF *responseLabel;

@end
