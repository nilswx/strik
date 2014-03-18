//
//  STKEndGameScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 18/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class STKAvatarNode, STKProgressNode;

@interface STKEndGameScene : STKScene

// Player one info
@property (readonly) CCLabelTTF *playerOneLabel;
@property (readonly) STKAvatarNode *playerOneAvatar;

// Player two info
@property (readonly) CCLabelTTF *playerTwoLabel;
@property (readonly) STKAvatarNode *playerTwoAvatar;

// The progress bars
@property (readonly) STKProgressNode *wordsFoundProgress;
@property (readonly) STKProgressNode *lettersFoundProgress;
@property (readonly) STKProgressNode *scoreProgress;

// The results label
@property (readonly) CCLabelTTF *resultsLabel;

// The rematch button
@property (readonly) CCButton *rematchButton;

@end
