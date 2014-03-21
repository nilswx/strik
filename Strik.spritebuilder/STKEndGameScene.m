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

#define PLAYER_INFO_OFFSET_SMALL_SCREEN 10

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

// The top bar
@property CCNode *topBar;

// The player info container
@property CCNode *playerInfoContainer;

// The button container
@property CCNode *buttonContainer;

@end

@implementation STKEndGameScene

- (void)sceneLoaded
{
	// Fix smaller screens
	if([UIScreen mainScreen].bounds.size.height < 568)
	{
		// Remove top bar
		[self.topBar removeFromParent];
		
		// Move the player info container a tad down
		self.playerInfoContainer.position = CGPointMake(self.playerInfoContainer.position.x, self.playerInfoContainer.position.y - PLAYER_INFO_OFFSET_SMALL_SCREEN);
	}
}

- (NSArray *)allProgressNodes
{
	// Todo: change me some day
	return @[self.wordsFoundProgress, self.lettersFoundProgress, self.scoreProgress];
}

@end
