//
//  STKGameScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 10/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKGameScene.h"

#import "STKAvatarNode.h"
#import "STKLevelNode.h"

#import "STKMatch.h"

#import "STKMatchPlayer.h"
#import "STKPlayer.h"

#import "STKBoardNode.h"

#define RED_WARNING_COLOR PLAYER_OFFLINE_COLOR

// The relative increase for time scaling
#define TIME_SCALE_SIZE 0.4f

@interface STKGameScene()

// Player one
@property CCLabelTTF *playerOneLabel;
@property STKAvatarNode *playerOneAvatar;
@property STKLevelNode *playerOneScore;

// Player two
@property CCLabelTTF *playerTwoLabel;
@property STKAvatarNode *playerTwoAvatar;
@property STKLevelNode *playerTwoScore;

// Timeline
@property CCNodeColor *timerBarContainer;
@property CCNodeColor *timerBar;
@property CCLabelTTF *timerLabel;

// Current game time
@property int currentTime;

// The container for the board
@property CCNode *boardContainer;

// Board
@property STKBoardNode *boardNode;

// The scale action, created when first accesing property
@property (nonatomic) CCAction *timerScaleAction;

// The container for the header
@property CCNode *headerContainer;

// The header background
@property CCSprite *headerBackground;

// The advertisment node
@property CCNode *advertisment;

// The VS label
@property CCLabelTTF *vsLabel;

@end

@implementation STKGameScene

#pragma mark init
- (void)sceneLoaded
{
	// Determine screen size, if it doesn't fit remove the ad (It aint the prettiest thing ever written, but it does the job for now)
	if([UIScreen mainScreen].bounds.size.height < 568)
	{
		// Get advertismentSize size
		CGSize advertismentSize = self.advertisment.contentSizeInPoints;
		
		// Remove the avatar
		[self.advertisment removeFromParent];
		
		// Move board the available space down
		self.boardNode.position = CGPointMake(self.boardNode.position.x, self.boardNode.position.y - advertismentSize.height);
		
		// Decrease header container size
		self.headerContainer.contentSize = CGSizeMake(self.headerContainer.contentSize.width, self.headerContainer.contentSizeInPoints.height - 38.5f);
		
		// Remove the VS label
		[self.vsLabel removeFromParent];
		
		// Get the smaller texture for the header
		[self.headerBackground removeFromParent];
		self.headerBackground = [CCSprite spriteWithImageNamed:@"Game Scene/game-header-small.png"];
		self.headerBackground.anchorPoint = CGPointMake(0, 0);
		self.headerBackground.zOrder = -1;
		[self.headerContainer addChild:self.headerBackground];
		
		// Re-align the nodes
		[self relocateLabels];
		
		// And relocate avatars
		[self relocateAvatars];
		
		// And score
		[self relocateScore];
	}
}

- (void)relocateLabels
{
	NSArray *nodes = @[self.playerOneLabel, self.playerTwoLabel];
	for(CCNode *node in nodes)
	{
		node.position = CGPointMake(node.position.x, node.position.y - 13);
	}
}

- (void)relocateAvatars
{
	NSArray *avatars = @[self.playerOneAvatar, self.playerTwoAvatar];
	for(CCNode *node in avatars)
	{
		node.position = CGPointMake(node.position.x, node.position.y - 20);
		node.scale = 0.5f;
	}
}

- (void)relocateScore
{
	self.playerOneScore.position = CGPointMake(self.playerOneScore.position.x - 4, self.playerOneScore.position.y - 17);
	self.playerOneScore.scale = 0.7f;
	
	self.playerTwoScore.position = CGPointMake(self.playerTwoScore.position.x + 4, self.playerTwoScore.position.y - 17);
	self.playerTwoScore.scale = 0.7f;
}

- (void)enter
{
	// Don't know why, but the timer bar doesn't start full width, this forces it
	self.timerBar.contentSize = CGSizeMake(320, 3);
}

- (void)startTimer
{
	[self schedule:@selector(updateTime:) interval:1 repeat:-1 delay:0];
}

#pragma mark Model changes
- (void)match:(STKMatch *)match valueChangedForPlayer:(STKMatchPlayer *)player
{
	// Setup player one
	self.playerOneLabel.string = player.info.name;
	
	self.playerOneAvatar.backgroundColor = PLAYER_ONE_COLOR;
	self.playerOneAvatar.borderColor = PLAYER_ONE_COLOR;
	self.playerOneAvatar.avatar = player.info.avatar;
	
	self.playerOneScore.backgroundColor = PLAYER_ONE_COLOR;
	self.playerOneScore.fontColor = [CCColor whiteColor];
	self.playerOneScore.text = @"0";
}

- (void)match:(STKMatch *)match valueChangedForOpponent:(STKMatchPlayer *)oppponent
{
	// Setup player two
	self.playerTwoLabel.string = oppponent.info.name;
	
	self.playerTwoAvatar.backgroundColor = PLAYER_TWO_COLOR;
	self.playerTwoAvatar.borderColor = PLAYER_TWO_COLOR;
	self.playerTwoAvatar.avatar = oppponent.info.avatar;
	
	self.playerTwoScore.backgroundColor = PLAYER_TWO_COLOR;
	self.playerTwoScore.fontColor = [CCColor whiteColor];
	self.playerTwoScore.text = @"0";
}

- (void)match:(STKMatch *)match valueChangedForGameTime:(NSNumber *)gametime
{
	self.currentTime = match.gameTime;
	[self setTime:self.currentTime ofTotalTime:match.gameTime];
}

- (void)matchPlayer:(STKMatchPlayer *)matchPlayer valueChangedForScore:(NSNumber *)score
{
	NSString *newScore = [NSString stringWithFormat:@"%d", matchPlayer.score];
	
	// Only animate when the score is not 0 (e.g not the first time)
	BOOL animated = YES;
	if(matchPlayer.score == 0)
	{
		animated = NO;
	}

	// Update player one
	if(matchPlayer == self.match.player)
	{
		[self.playerOneScore setText:newScore animated:animated];
	}
	// Update player two
	else
	{
		[self.playerTwoScore setText:newScore animated:animated];
	}

}

#pragma mark time handling
- (void)setTime:(int)time ofTotalTime:(int)totalTime
{
	int minute = floor(time / 60);
	int seconds = time % 60;
	
	// Update the label
	if(minute > 0)
	{
		self.timerLabel.string = [NSString stringWithFormat:@"%d:%02d", minute, seconds];
	}
	else if(time == 0)
	{
		self.timerLabel.string = NSLocalizedString(@"Time's up!", nil);
	}
	else
	{
		self.timerLabel.string = [NSString stringWithFormat:@"%d", seconds];
	}
		
	// When time is 10, tween colors of timeline and label to red
	if(time == 10)
	{
		// Color the bar red
		CCActionTintTo *redBar = [CCActionTintTo actionWithDuration:0.5 color:RED_WARNING_COLOR];
		[self.timerBar runAction:redBar];
		
		// Color the label red (supposedly you can only add an action to one node)
		CCActionTintTo *redLabel = [CCActionTintTo actionWithDuration:0.5 color:RED_WARNING_COLOR];
		[self.timerLabel runAction:redLabel];
	}
	// Animate it a bit
	else if(time < 10)
	{
		[self.timerLabel runAction:self.timerScaleAction];
	}
	
	// Shorten the timeline bar (perhaps color it based on time?)
	float currentWidth = self.timerBar.contentSize.width;
	
	// 1 is substracted from time since it takes time to get to the correct position
	float relativeTime = (float)(time - 1)/ (float)totalTime;
	float totalWidth = self.timerBarContainer.contentSizeInPoints.width;
	
	float newWidth = totalWidth * relativeTime;
	
	CCActionTween *tween = [CCActionTween actionWithDuration:1 key:@"width" from:currentWidth to:newWidth];
	[self.timerBar runAction:tween];
	
	
}

- (void)updateTime:(CCTime)time
{
	if(self.currentTime > 0)
	{
		self.currentTime--;
		[self setTime:self.currentTime ofTotalTime:self.match.gameTime];
	}
}


- (void)setMatch:(STKMatch *)match
{
	// Stop listening to old match if we are
	if(_match)
	{
		[self removeAsObserverForModel:_match];
		[self removeAsObserverForModel:_match.player];
		[self removeAsObserverForModel:_match.opponent];
	}
	
	_match = match;
	
	// When setting the match model we start listening
	if(_match)
	{
		[self observeModel:match];
		[self observeModel:match.player];
		[self observeModel:match.opponent];
	}
}

- (CCAction *)timerScaleAction
{
	if(!_scaleAction)
	{
		// Get the current scale
		CGFloat currentScale = self.timerLabel.scale;
		
		// Fist scale up, then down
		CCActionScaleTo	*bigger = [CCActionScaleTo actionWithDuration:0.15 scale:currentScale + TIME_SCALE_SIZE];
		CCActionScaleTo *normal = [CCActionScaleTo actionWithDuration:0.15 scale:currentScale];

		CCActionSequence *both = [CCActionSequence actionWithArray:@[bigger, normal]];
		
		// Aply a little easing
		CCActionEaseOut *easing = [CCActionEaseOut actionWithAction:both rate:0.7];
		
		_scaleAction = easing;
	}
	
	return _scaleAction;
}
@end
