//
//  STKEndGameController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 18/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKEndGameController.h"
#import "STKEndGameScene.h"

#import "STKMatchPlayer.h"
#import "STKPLayer.h"
#import "STKMatch.h"

#import "STKMatchController.h"

#import "STKAvatarNode.h"
#import "STKSplittedProgressNode.h"

#import "CCNode+Animation.h"

#define DISPLAY_WINNER_TIMELINE @"Display Winner"

@interface STKEndGameController()

// For convenience
@property (nonatomic, readonly) STKEndGameScene *endGameScene;
@property (nonatomic, readonly) STKMatch *match;

@end

@implementation STKEndGameController

- (void)sceneWillBegin
{
	// Setup the player information
	[self setupPlayers];
	
	// Setup the progress bars
	[self setupProgressBars];
}

- (void)setupPlayers
{
	// Player one
	STKAvatarNode *pOneAvatar = self.endGameScene.playerOneAvatar;
	STKPlayer *player = self.match.player.info;

	pOneAvatar.borderColor = PLAYER_ONE_COLOR;
	pOneAvatar.backgroundColor = PLAYER_ONE_COLOR;
	pOneAvatar.avatar = player.avatar;

	self.endGameScene.playerOneLabel.string = player.name;
	
	// Player two
	STKAvatarNode *pTwoAvatar = self.endGameScene.playerTwoAvatar;
	STKPlayer *opponent = self.match.opponent.info;
	
	pTwoAvatar.borderColor = PLAYER_TWO_COLOR;
	pTwoAvatar.backgroundColor = PLAYER_TWO_COLOR;
	pTwoAvatar.avatar = opponent.avatar;
}

- (void)setupProgressBars
{
	// First setup the correct colors for every progress node
	for(STKSplittedProgressNode *progressNode in self.endGameScene.allProgressNodes)
	{
		progressNode.fillShade = PLAYER_ONE_COLOR;
		progressNode.backgroundShade = PLAYER_TWO_COLOR;
	}
	
	[self displayProgress:YES];

}

- (void)displayProgress:(BOOL)animated
{
	STKMatchPlayer *player = self.match.player;
	STKMatchPlayer *opponent = self.match.opponent;
	
	// Now we will animate every progress node (words first, then letter and finaly score, after score display winner)
	
	// The words found
	[self.endGameScene.wordsFoundProgress setLeftValue:player.wordsFound andRightValue:opponent.wordsFound animated:animated withAnimationCompletion:^{
		
		// The letters found
		[self.endGameScene.lettersFoundProgress setLeftValue:player.lettersFound andRightValue:opponent.lettersFound animated:animated withAnimationCompletion:^{
			
			// The score
			[self.endGameScene.scoreProgress setLeftValue:player.score andRightValue:opponent.score animated:animated withAnimationCompletion:^{
				self.endGameScene.resultsLabel.string = [self endGameMessage];
				
				if(animated)
				{
					[self.endGameScene runTimelineNamed:DISPLAY_WINNER_TIMELINE];
				}
				else
				{
					self.endGameScene.resultsLabel.scale = 1;
				}
			}];
			
		}];
		
	}];
}

- (NSString *)endGameMessage
{
	NSString *endGameResults;
	
	// Display winner
	if(self.match.player.score == self.match.opponent.score)
	{
		endGameResults = NSLocalizedString(@"It's a Draw!", nil);
	}
	else if(self.match.player.score > self.match.opponent.score)
	{
		endGameResults = NSLocalizedString(@"You Won!", nil);
	}
	else
	{
		endGameResults = NSLocalizedString(@"You Lost!", nil);
	}
	
	return endGameResults;
}

#pragma mark User interaction
- (void)onCloseButton:(CCButton *)button
{
	NSLog(@"Close please");
}

- (void)onRematchButton:(CCButton *)button
{
	NSLog(@"Rematch please");
}

- (STKEndGameScene *)endGameScene
{
	return self.scene;
}

- (STKMatch *)match
{
	return ((STKMatchController *)(self.core[@"match"])).match;
}

- (void)onStopAnimatingButton:(CCButton *)button
{
	// Stop the animation (go to animation completed state)
	for(STKProgressNode *progress in self.endGameScene.allProgressNodes)
	{
		[progress stopAnimation];
	}
	
	// And display end results without animation
	[self displayProgress:NO];
}

- (void)dealloc
{
	// Clear up the match when leaving this scene
	((STKMatchController *)(self.core[@"match"])).match = nil;
}

@end
