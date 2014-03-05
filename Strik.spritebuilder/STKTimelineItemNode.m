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

#import "Fluent.h"

#import "NSObject+Observer.h"

@interface STKTimelineItemNode()

// The player for this timeline event
@property (nonatomic) STKPlayer *actor;

// The content for this timeline
@property (nonatomic) NSString *content;

// The avatar node
@property STKAvatarNode *avatarNode;

// The connecting line node
@property CCNode *connectingLine;

// Label holding the content
@property CCLabelTTF *contentLabel;

@end

@implementation STKTimelineItemNode

+ (id)newTimelineItemNodeWithActor:(STKPlayer *)actor action:(NSString *)action subject:(NSString *)subject andTimestamp:(int)timestamp
{
	STKTimelineItemNode *timelineItemNode = (STKTimelineItemNode *)[CCBReader load:@"Home Scene/TimelineItemNode.ccbi"];
	timelineItemNode.actor = actor;
	
	timelineItemNode.content = [Fluent fluentStringWithActor:actor.name action:action subject:subject atTime:[NSDate dateWithTimeIntervalSince1970:timestamp]];
	
	return timelineItemNode;
}

- (void)setContent:(NSString *)content
{
	_content = content;
	self.contentLabel.string = content;
}

- (void)setActor:(STKPlayer *)actor
{
	if(actor)
	{
		[self removeAsObserverForModel:actor];
	}
	
	_actor = actor;

	if(actor)
	{
		[self observeModel:actor];
	}

}

- (void)player:(STKPlayer *)player valueChangedForAvatar:(STKAvatar *)avatar
{
	// Todo: Move this to player status and change based on player status
	self.avatarNode.borderColor = PLAYER_ONLINE_COLOR;
	self.avatarNode.backgroundColor = PLAYER_ONLINE_COLOR;
	
	self.avatarNode.avatar = player.avatar;
}

- (void)setTimelinePosition:(TimelinePositionType)timelinePosition
{
	self.connectingLine.opacity = 1;
	
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
		self.connectingLine.position = CGPointMake(x, 0.5);
	}
	else if(timelinePosition == TimelinePositionTypeOnly)
	{
		self.connectingLine.opacity = 0;
	}
}

- (void)dealloc
{
	[self removeAsObserverForAllModels];
}

@end
