//
//  STKHomeController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKHomeController.h"

#import "STKScene.h"
#import "STKAchievementsScene.h"
#import "STKSessionController.h"
#import "STKLobbyScene.h"
#import "STKHomeScene.h"

#import "STKAlertView.h"
#import "STKPLayer.h"
#import "STKOutgoingMessage.h"

#import "GridNode.h"

#import "STKFriend.h"
#import "STKFacebookController.h"
#import "STKAvatar.h"
#import "STKTimelineItemNode.h"

#import "STKItemType.h"
#import "STKItemRegistry.h"

#import "STKSettingsController.h"
#import "STKAvatarPickerController.h"

#import "STKDirector.h"
#import "STKDirector+Modal.h"

#define TIMELINE_ITEM_ACTOR_KEY @"actor"
#define TIMELINE_ITEM_ACTION_KEY @"action"
#define TIMELINE_ITEM_SUBJECT_KEY @"subject"
#define TIMELINE_ITEM_DATE_KEY @"date"

@interface STKHomeController()

// The grid for the timeline
@property GridNode *timelineGrid;

// The array which will contain the timeline item nodes
@property NSMutableArray *timelineItemNodes;

// The array containing the timeline items itself
@property NSMutableArray *timelineItems;

@end

@implementation STKHomeController

- (void)sceneCreated
{
	// Listen for name changes
	[self routeNetMessagesOf:NAME_CHANGED to:@selector(handleNameChanged:)];
	[self routeNetMessagesOf:NAME_REJECTED to:@selector(handleNameRejected:)];
	
	// Activity stream
	[self routeNetMessagesOf:ACTIVITY_STREAM to:@selector(handleActivityStream:)];
	
	// Let the view observe the userdata models
	STKSessionController *sessionController = self.core[@"session"];
	[self.scene observeModel:(STKModel *)sessionController.user];
	[self.scene observeModel:(STKModel *)sessionController.user.progression];
	[self.scene observeModel:(STKModel *)sessionController.user.avatar];
	
	// Setup the timeline
	[self setupTimeline];
	
	// Get stream begin
	[self requestStreamFrom:0 to:25];
}

- (void)setupTimeline
{
	self.timelineItems = [NSMutableArray array];
	self.timelineItemNodes = [NSMutableArray array];
	
	// Create the timeline grid (filling its container)
	self.timelineGrid = [GridNode gridWithDataSource:self];
	self.timelineGrid.contentSizeType = CCSizeTypeNormalized;
	self.timelineGrid.contentSize = CGSizeMake(1, 1);
	
	// And add it to the home scene timeline container
	STKHomeScene *homeScene = self.scene;
	[homeScene.timelineContainer addChild:self.timelineGrid];
}

#pragma mark buttons
- (void)onAchievementsButton:(CCButton *)button
{
	[self transitionTo:[STKAchievementsScene class] direction:CCTransitionDirectionLeft];
}

- (void)onNewGameButton:(CCButton *)button
{
	[self transitionTo:[STKLobbyScene class] direction:CCTransitionDirectionLeft];
}

- (void)onSettingsButton:(CCButton *)button
{
	STKDirector *director = self.core[@"director"];
	[director overlayScene:[STKSettingsController new]];
}

- (void)onAvatarButton:(CCButton *)button
{
	STKDirector *director = self.core[@"director"];
	[director overlayScene:[STKAvatarPickerController new]];
}

- (void)onScrollTopButton:(CCButton *)button
{
	// Scroll to top when pressing top bar
	[self.timelineGrid.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark Username changes
- (void)onUsernameButton:(CCButton *)button
{
	STKSessionController *sessionController = self.core[@"session"];
	
	STKAlertView *alertView = [STKAlertView promptWithTitle:NSLocalizedString(@"Change Your Name", @"Change your name title") message:NSLocalizedString(@"You can change the name people see in Strik. Think of a good one!", @"Change your name prompt text") defaultValue:sessionController.user.name target:self okSelector:@selector(confirmedUsernameChange:) andCancelSelector:nil];
	[alertView show];
}

- (void)confirmedUsernameChange:(NSString *)newUsername
{
	// Empty string might just be the placeholder. So ignore that
	if(newUsername == nil || ![newUsername isEqualToString:@""])
	{
		[self requestNameChangeTo:newUsername];
	}
}

#pragma mark Networking
- (void)requestNameChangeTo:(NSString*)newName
{
	NSLog(@"Home: asking server for name change to \"%@\"", newName);
	
	// Ask server for a rename
	STKOutgoingMessage* msg = [STKOutgoingMessage withOp:CHANGE_NAME];
	[msg appendStr:newName];
	[self sendNetMessage:msg];
}

- (void)handleNameChanged:(STKIncomingMessage*)msg
{
	// Read new name
	NSString* newName = [msg readStr];
	NSLog(@"Home: name changed to \"%@\"", newName);
	
	// Store new name in session
	STKSessionController* session = self.core[@"session"];
	session.user.name = newName;
}

- (void)handleNameRejected:(STKIncomingMessage*)msg
{
	// Read reason
	// TODO: Do something with the actual message (first change it to enums)
	//	NSString* name = [msg readStr];
	//	NSString* message = [msg readStr];
	
	// Notify user
	STKAlertView *alertview = [STKAlertView alertWithTitle:NSLocalizedString(@"Name Not Allowed", @"Name not allowed title.") andMessage:NSLocalizedString(@"You like naughty names don't you? Well, we don't!", @"Name not allowed message")];
	[alertview show];
}

#pragma mark Timeline grid data source
- (CGSize)cellSize
{
	return CGSizeMake(320, 70);
}

-(int)columnCount
{
	return 1;
}

- (int)rowCount
{
	return self.timelineItems.count;
}

- (CCNode *)nodeForColumn:(int)column andRow:(int)row
{
	
	STKTimelineItemNode *timelineItem;
	
	if(self.timelineItemNodes.count <= row)
	{
		// Get the info for this timeline item
		NSDictionary *nodeInfo = [self.timelineItems objectAtIndex:row];
		
		// Load it and set the properties

		// Get the needed information for this timeline item node
		STKPlayer *actor = nodeInfo[TIMELINE_ITEM_ACTOR_KEY];
		NSString *action = nodeInfo[TIMELINE_ITEM_ACTION_KEY];
		NSString *subject = nodeInfo[TIMELINE_ITEM_SUBJECT_KEY];
		int timestamp = [nodeInfo[TIMELINE_ITEM_DATE_KEY] intValue];
		
		timelineItem = [STKTimelineItemNode newTimelineItemNodeWithActor:actor action:action subject:subject andTimestamp:timestamp];
		
		// Add to cache
		[self.timelineItemNodes addObject:timelineItem];
	}
	else
	{
		timelineItem = [self.timelineItemNodes objectAtIndex:row];
	}
	
	// Make sure the line is correct based on position
	if(self.rowCount == 1)
	{
		timelineItem.timelinePosition = TimelinePositionTypeOnly;
	}
	else
	{
		if(row == 0)
		{
			timelineItem.timelinePosition = TimelinePositionTypeTop;
		}
		else if(row == self.rowCount - 1)
		{
			timelineItem.timelinePosition = TimelinePositionTypeBottom;
		}
		else
		{
			timelineItem.timelinePosition = TimelinePositionTypeCenter;
		}
	}
	
	return timelineItem;
}

#pragma mark timeline handling
- (void)requestStreamFrom:(int)from to:(int)to
{
	// Range to request
	NSLog(@"ActivityStream: requesting stream [%d-%d]", from, to);
	
	// Pretty please!
	STKOutgoingMessage* msg = [STKOutgoingMessage withOp:GET_ACTIVITY_STREAM];
	[msg appendInt:from];
	[msg appendInt:to];
	[self sendNetMessage:msg];
}

- (STKPlayer*)parseActivityActorFromMessage:(STKIncomingMessage*)msg
{
	// Is it about self?
	if([msg readBool] == YES)
	{
		STKSessionController* session = self.core[@"session"];
		return session.user;
	}
	else
	{
		// Parse actor
		STKPlayer* actor = [STKPlayer new];
		actor.playerId = [msg readInt];
		actor.name = [msg readStr];
		actor.avatar = [STKAvatar avatarWithIdentifier:[msg readStr]];
		
		return actor;
	}
	
	// TODO: use a more efficient class (STKActivityActor?)
}

- (STKPlayer*)resolveActivityActor:(int)playerId
{
	STKSessionController* session = self.core[@"session"];
	if(playerId == session.user.playerId)
	{
		return session.user;
	}
	else
	{
		STKFriend* friend = [self.core[@"facebook"] friendByPlayerId:playerId];
		
		STKPlayer* player = [STKPlayer new];
		player.playerId = playerId;
		player.name = friend.fullName;
		player.avatar = friend.avatar;
		
		return player;
	}
	
	
	// TODO: use a more lightweight than STKPlayer
}

- (void)handleActivityStream:(STKIncomingMessage*)msg
{
	// Determine range that was sent
	int start = [msg readInt];
	int end = [msg readInt];
	
	// Parse the items in this range
	int amount = [msg readInt];
	NSLog(@"ActivityStream: received %d items in [%d,%d] range", amount, start, end);
	for(int i = 0; i < amount; i++)
	{
		// Parse timestamp (seconds)
		int timestamp = [msg readInt];
		
		// Parse activity actor
		STKPlayer* actor = [self resolveActivityActor:[msg readInt]];
		
		// Process extra stuff based on type
		char type = [msg readByte];
		
		// Action is e.g joined / reached
		NSString *action;

		// Subject is 'Strik', 'level x', 'item that'
		NSString *subject;
		
		// Todo: localize
		switch(type)
		{
			// Actor joined!
			case 'j':
			{
				action = @"joined";
				subject = @"Strik";
				break;
			}
				
			// Actor leveled up!
			case 'l':
			{
				// Get the level the level
				int level = [msg readInt];
				
				action = @"reached";
				subject= [NSString stringWithFormat:@"level %d", level];

				break;
			}
				
			// Actor received item
			case 'i':
			{
				// Resolve the item
				STKItemType* item = [self.core[@"items"] typeForID:[msg readInt]];
				if(item)
				{
					action = @"received";
					subject = item.name;
				}
				break;
			}
				
			// Match result
			case 'm':
			{
				STKPlayer* loser = [self resolveActivityActor:[msg readInt]];
				
				action = @"beat";
				subject = loser.name; // with x points?

				break;
			}
				
			// Lol?
			default:
			{
				NSLog(@"ActivityStream: unknown item type '%c'", type);
			}
				
		}
		
        // Create it and add it to the array if we could parse the content
        if(action)
        {
			[self.timelineItems addObject:@{
										   TIMELINE_ITEM_ACTION_KEY: action,
										   TIMELINE_ITEM_SUBJECT_KEY: subject,
										   TIMELINE_ITEM_ACTOR_KEY: actor,
										   TIMELINE_ITEM_DATE_KEY: @(timestamp)}];
        }
	}
	
	// Reload the timeline
	[self.timelineGrid reload];
}


@end
