//
//  STKAnnounceMatchController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAnnounceMatchController.h"

#import "STKAnnounceMatchScene.h"
#import "STKAnnouncePlayerCard.h"

#import "STKAvatarNode.h"
#import "STKProgressNode.h"
#import "STKLevelNode.h"

#import "STKSessionController.h"
#import "STKMatchController.h"
#import "STKMatch.h"

#import "STKPLayer.h"
#import "STKMatchPlayer.h"
#import "STKProgression.h"

#import "NSObject+Observer.h"

#import "CCNode+Animation.h"
#import "Linguistics.h"

#define TIMELINE_OPPONENT_FOUND @"OpponentFound"
#define TIMELINE_INTRO @"Default Timeline"

@interface STKAnnounceMatchController()

@property (readonly) STKAnnounceMatchScene *vsScene;

// When set to yes the intro animation is completed
@property BOOL introAnimationCompleted;

@end

@implementation STKAnnounceMatchController

- (void)sceneCreated
{
	// Setup the player one
	[self setupPlayerOne];
}

- (void)enter
{
	// Run the intro animation, when done either show opponent or loading indicator
	[self.scene runTimelineNamed:TIMELINE_INTRO withCallback:^{
		// Listen for changes in match (when this happens we found another player)
		STKMatchController *matchController = self.core[@"match"];
		
		// We have gotten here by an invite, the opponent is already there
		if(matchController.match)
		{
			[self setupMatch:matchController.match];
		}
		// Still waiting for an opponent
		else
		{
			self.introAnimationCompleted = YES;
			[self displayWaitingIndicator];
		}
	}];
}

- (void)displayWaitingIndicator
{
	// Todo: Display waiting indicator
}

- (void)setupPlayerOne
{
	STKSessionController *sessionController = self.core[@"session"];
	
	// Setup card for player one
	STKPlayer *playerOne = sessionController.player;
	STKAnnouncePlayerCard *playerOneCard = self.vsScene.playerOneCard;
	[self setupVSCard:playerOneCard withPlayer:playerOne darkColor:PLAYER_ONE_COLOR andLightColor:PLAYER_ONE_LIGHT_COLOR];
	
	// Setup country for player one
	[self setupCountryName:self.vsScene.playerOneCountryLabel andFlag:self.vsScene.playerOneFlagContainer withPlayer:playerOne];
}


- (void)setupMatch:(STKMatch *)match
{
	// Setup opponent card
	STKPlayer *opponent = match.opponent.info;
	STKAnnouncePlayerCard *playerTwoCard = self.vsScene.playerTwoCard;
	[self setupVSCard:playerTwoCard withPlayer:opponent darkColor:PLAYER_TWO_COLOR andLightColor:PLAYER_TWO_LIGHT_COLOR];
	
	// Setup opponent country
	[self setupCountryName:self.vsScene.playerTwoCountryLabel andFlag:self.vsScene.playerTwoFlagContainer withPlayer:opponent];
	
	// Animate the card in
	[self.scene runTimelineNamed:TIMELINE_OPPONENT_FOUND withCallback:^{
		
		// Tell the server we are ready freddy!
		STKMatchController *matchController = self.core[@"match"];
		[matchController playerIsReady];
	}];
}

- (void)setupVSCard:(STKAnnouncePlayerCard *)vsCard withPlayer:(STKPlayer *)player darkColor:(CCColor *)darkColor andLightColor:(CCColor *)lightColor
{
	// The name
	vsCard.nameLabel.string = player.name;
	
	// The avatar
	vsCard.avatarNode.borderColor = darkColor;
	vsCard.avatarNode.backgroundColor = darkColor;
	vsCard.avatarNode.avatar = player.avatar;
	
	// Progress
	// Todo: get actual value
	vsCard.progressNode.lightShade = lightColor;
	vsCard.progressNode.darkShade = darkColor;
	
	[vsCard.progressNode setValue:player.progression.xp ofTotalValue:player.progression.maxExperienceForLevel animated:NO];
	
	// Level
	vsCard.levelNode.backgroundColor = darkColor;
	vsCard.levelNode.fontColor = [CCColor whiteColor];
	vsCard.levelNode.text = [NSString stringWithFormat:@"%d", player.progression.level];
	
	// Bottom stroke
	vsCard.bottomLine.color = darkColor;
}

- (void)setupCountryName:(CCLabelTTF *)countryLabel andFlag:(CCNode *)flagContainer withPlayer:(STKPlayer *)player
{
	// Set country label
	countryLabel.string = [Linguistics localizedNameFromCountryCode:player.country];
	
	// Create a masked flag
	CCSprite *flagMask = [CCSprite spriteWithImageNamed:@"Global/Images/flag-mask.png"];
	CCSprite *flag = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"Global/Images/Flags/%@.png", player.country]];
	
	CCClippingNode *clippingNode = [CCClippingNode clippingNodeWithStencil:flagMask];
	
	// Don't know what idiot thought defaulting this to one was a good idea
	clippingNode.alphaThreshold = 0;
	
	[clippingNode addChild:flag];
	
	// Make sure it is positioned correctly
	flag.anchorPoint = CGPointMake(0, 0);
	flagMask.anchorPoint = CGPointMake(0, 0);

	// And size the flag a bit down
	flag.scale = 0.36f;
	
	// And add to scene
	[flagContainer addChild:clippingNode];
}

- (STKAnnounceMatchScene *)vsScene
{
	return self.scene;
}

- (void)dealloc
{
	[self removeAsObserverForAllModels];
}

- (void)setMatch:(STKMatch *)match
{
	_match = match;
	
	if(self.introAnimationCompleted)
	{
		[self setupMatch:self.match];
	}
}

@end
