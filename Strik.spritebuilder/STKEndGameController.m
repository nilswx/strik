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
#import "STKPlayer.h"
#import "STKMatch.h"

#import "STKMatchController.h"

#import "STKAvatarNode.h"
#import "STKSplittedProgressNode.h"

#import "CCNode+Animation.h"

#import "STKDirector.h"
#import "STKHomeController.h"

#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"

#define DISPLAY_WINNER_TIMELINE @"Display Winner"

@interface STKEndGameController()

// For convenience
@property (nonatomic, readonly) STKEndGameScene *endGameScene;
@property (nonatomic) STKMatch *match;

@end

@implementation STKEndGameController

- (id)initWithMatch:(STKMatch*)match
{
	if(self = [super init])
	{
		self.match = match;
	}
	
	return self;
}

- (void)sceneCreated
{
	// Handle network messages of the challenge system (rematch)
	[self routeNetMessagesOf:CHALLENGE_OK to:@selector(handleChallengeOK:)];
	[self routeNetMessagesOf:CHALLENGE_FAILED to:@selector(handleChallengeFailed:)];
	[self routeNetMessagesOf:CHALLENGE_REDIRECT to:@selector(handleChallengeRedirect:)];
	[self routeNetMessagesOf:CHALLENGE_LOCALE_MISMATCH to:@selector(handleChallengeLocaleMismatch:)];
}

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
	
	self.endGameScene.playerTwoLabel.string = opponent.name;
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
	if(self.match.winner == nil)
	{
		endGameResults = NSLocalizedString(@"Draw!", nil);
	}
	else if(self.match.winner == self.match.player)
	{
		endGameResults = NSLocalizedString(@"You win!", nil);
	}
	else
	{
		endGameResults = NSLocalizedString(@"You lose!", nil);
	}
	
	return endGameResults;
}

#pragma mark User interaction
- (void)onCloseButton:(CCButton *)button
{
	// Go home
	[((STKDirector *)(self.core[@"director"])) presentScene:[STKHomeController new] withTransition:[CCTransition transitionCrossFadeWithDuration:0.25f]];
}

- (void)onRematchButton:(CCButton *)button
{
	if(true) // TODO: if not already checkmarked
	{
		NSLog(@"Rematch please");
		
		STKMatchPlayer* opponent = self.match.opponent;
		
		// Ask for a rematch...
		STKOutgoingMessage* msg = [STKOutgoingMessage withOp:CHALLENGE_PLAYER];
		[msg appendInt:opponent.playerId];
		[self sendNetMessage:msg];
	}
}

- (STKEndGameScene *)endGameScene
{
	return self.scene;
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

- (void)handleChallengeOK:(STKIncomingMessage*)msg
{
	int playerId = [msg readInt];
	if(playerId == self.match.opponent.playerId)
	{
		NSLog(@"Rematch: challenge delivered, place own checkmark now! (waiting...)");
	}
}

- (void)handleChallengeFailed:(STKIncomingMessage*)msg
{
	int playerId = [msg readInt];
	if(playerId == self.match.opponent.playerId)
	{
		NSLog(@"Rematch: challenge failed to deliver, disable rematch button to avoid spamming?");
	}
}

- (void)handleChallengeRedirect:(STKIncomingMessage*)msg
{
	int playerId = [msg readInt];
	if(playerId == self.match.opponent.playerId)
	{
		NSLog(@"Rematch: opponent is now on a different server, wat?");
	}
}

- (void)handleChallengeLocaleMismatch:(STKIncomingMessage*)msg
{
	int playerId = [msg readInt];
	if(playerId == self.match.opponent.playerId)
	{
		NSLog(@"Rematch: opponent is now using a different locale, wat?");
	}
}

@end
