//
//  STKTimelineItemNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 24/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKTimelineItemNode.h"

#import "STKAvatarNode.h"
#import "STKAvatar.h"

@interface STKTimelineItemNode()

// The avatar node
@property STKAvatarNode *avatarNode;

// The connecting line node
@property CCNode *connectingLine;

// Label holding the content
@property CCLabelTTF *contentLabel;

@end

@implementation STKTimelineItemNode


- (void)setContent:(NSString *)content
{
	_content = content;
	self.contentLabel.string = content;
}

- (void)setActor:(STKPlayer *)actor
{
	_actor = actor;
	
	[actor.avatar fetchAvatarWithCallback:^(CCTexture *avatarTexture, AvatarType avatarType) {
		self.avatarNode.borderColor = PLAYER_ONE_COLOR;
		self.avatarNode.backgroundColor = PLAYER_ONE_LIGHT_COLOR;
		self.avatarNode.maskedImage = [CCSprite spriteWithTexture:avatarTexture];
	}];
}

- (void)setTimelinePosition:(TimelinePositionType)timelinePosition
{
	_timelinePosition = timelinePosition;
	
	// The width and x pos doesn't change
	CGFloat width = self.connectingLine.contentSize.width;
	CGFloat x = self.connectingLine.position.x;
	
	if(timelinePosition == TimelinePositionTypeTop)
	{
		self.connectingLine.contentSize = CGSizeMake(width, 0.5);
		self.connectingLine.position = CGPointMake(x, 0);
	}
	else if(timelinePosition == TimelinePositionTypeCenter)
	{
		self.connectingLine.contentSize = CGSizeMake(width, 1);
		self.connectingLine.position = CGPointMake(x, 0);
	}
	else if(timelinePosition == TimelinePositionTypeBottom)
	{
		self.connectingLine.contentSize = CGSizeMake(width, 0.5);
		self.connectingLine.position = CGPointMake(x, 50);
	}
}

@end
