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
#import "STKPLayer.h"

#define RED_WARNING_COLOR [CCColor colorWithRed:241.0f/255.0f green:75.0f/255.0f blue:75.0f/255.0f]

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

// The scale action, created when first accesing property
@property (nonatomic) CCAction *scaleAction;

@end

@implementation STKGameScene

- (void)enterTransitionDidFinish
{
	// Tick time every second
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
		[self.timerLabel runAction:self.scaleAction];
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
		[self removeAsObserverForModel:match];
	}
	
	_match = match;
	
	// When setting the match model we start listening
	if(_match)
	{
		[self observeModel:match];
	}
}

- (CCAction *)scaleAction
{
	if(!_scaleAction)
	{
		// Fist scale up, then down
		CCActionScaleTo *bigger = [CCActionScaleTo actionWithDuration:0.15 scale:1.4];
		CCActionScaleTo *normal = [CCActionScaleTo actionWithDuration:0.14 scale:1];
		
		CCActionSequence *both = [CCActionSequence actionWithArray:@[bigger, normal]];
		
		// Aply a little easing
		CCActionEaseOut *easing = [CCActionEaseOut actionWithAction:both rate:0.7];
		
		_scaleAction = easing;
	}
	
	return _scaleAction;
}
@end
