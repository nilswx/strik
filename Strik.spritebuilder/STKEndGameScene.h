//
//  STKEndGameScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 18/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class STKAvatarNode, STKSplittedProgressNode;

@interface STKEndGameScene : STKScene

// Player one info
@property (readonly) CCLabelTTF *playerOneLabel;
@property (readonly) STKAvatarNode *playerOneAvatar;

// Player two info
@property (readonly) CCLabelTTF *playerTwoLabel;
@property (readonly) STKAvatarNode *playerTwoAvatar;

// The progress bars
@property (readonly) STKSplittedProgressNode *wordsFoundProgress;
@property (readonly) STKSplittedProgressNode *lettersFoundProgress;
@property (readonly) STKSplittedProgressNode *scoreProgress;

// The results label
@property (readonly) CCLabelTTF *resultsLabel;

// The rematch button
@property (readonly) CCButton *rematchButton;
@property (nonatomic, readonly) BOOL rematchButtonIsActive;

// Returns all progress nodes on the scene
@property (readonly) NSArray *allProgressNodes;

- (NSArray *)allProgressNodes;

- (void)setRematchButtonActive:(BOOL)active;

@end
