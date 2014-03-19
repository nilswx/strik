//
//  STKEndGameScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 18/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKEndGameScene.h"

#import "STKSplittedProgressNode.h"
#import "STKAvatarNode.h"

@interface STKEndGameScene()

// Player one info
@property CCLabelTTF *playerOneLabel;
@property STKAvatarNode *playerOneAvatar;

// Player two info
@property CCLabelTTF *playerTwoLabel;
@property STKAvatarNode *playerTwoAvatar;

// The progress bars
@property STKSplittedProgressNode *wordsFoundProgress;
@property STKSplittedProgressNode *lettersFoundProgress;
@property STKSplittedProgressNode *scoreProgress;

// The results label
@property CCLabelTTF *resultsLabel;

// The rematch button
@property CCButton *rematchButton;

@end

@implementation STKEndGameScene


- (NSArray *)allProgressNodes
{
	// Todo: change me some day
	return @[self.wordsFoundProgress, self.lettersFoundProgress, self.scoreProgress];
}

@end
