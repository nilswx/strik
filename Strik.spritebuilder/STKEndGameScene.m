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

#import "CCNode+Animation.h"

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
@property CCNode *rematchContainer;
@property CCSprite *rematchCheckMark;

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
	if(screen_height_less(568))
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

- (BOOL)rematchButtonIsActive
{
	return (self.rematchContainer.contentSizeInPoints.width > 100);
}

- (void)setRematchButtonActive:(BOOL)active
{
	CGFloat startWidth;
	CGFloat endWidth;
	CGFloat scale;
	
	if(active)
	{
		startWidth = 100;
		endWidth = 125;
		scale = 0.5f;
	}
	else
	{
		startWidth = 125;
		endWidth = 100;
		scale = 0;
	}
	
	// Resize the container
	CCActionTween *resize = [CCActionTween actionWithDuration:0.5f key:@"width" from:startWidth	to:endWidth];
	CCActionEaseElasticOut *eased = [CCActionEaseElasticOut actionWithAction:resize period:0.7f];
	[self.rematchContainer runAction:eased];
	
	// Somehow (even when set to percentages) the button does not autofit in container, so resizing that manually too
	CCActionTween *resizeButton = [CCActionTween actionWithDuration:0.5f key:@"width" from:startWidth to:endWidth];
	CCActionEaseElasticOut *easedButton = [CCActionEaseElasticOut actionWithAction:resizeButton period:0.7f];
	[self.rematchButton runAction:easedButton];
	
	// And animate the checkmark <3
	CCActionScaleTo *scaleAction = [CCActionScaleTo actionWithDuration:0.5f scale:scale];
	CCActionEaseElasticOut *easedScale = [CCActionEaseElasticOut actionWithAction:scaleAction period:0.7f];
	[self.rematchCheckMark runAction:easedScale];
}

@end
