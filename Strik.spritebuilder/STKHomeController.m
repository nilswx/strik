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

#import "ScrollNode.h"

@interface STKHomeController()

//@property GridNode *timelineGrid;

@end

@implementation STKHomeController

- (void)sceneCreated
{
	// Listen for name changes
	[self routeNetMessagesOf:NAME_CHANGED to:@selector(handleNameChanged:)];
	[self routeNetMessagesOf:NAME_REJECTED to:@selector(handleNameRejected:)];
	
	// Let the view observe the userdata models
	STKSessionController *sessionController = self.core[@"session"];
	[self.scene observeModel:(STKModel *)sessionController.user];
	[self.scene observeModel:(STKModel *)sessionController.user.progression];
	
	// Setup the timeline
	[self setupTimeline];
}

- (void)setupTimeline
{
	CCNodeGradient *node = [CCNodeGradient nodeWithColor:[CCColor redColor] fadingTo:[CCColor yellowColor]];
	node.contentSizeType = CCSizeTypePoints;
	node.contentSize = CGSizeMake(1000, 1000);
	
	ScrollNode *scroller = [ScrollNode scrollNodeWithContent:node];
	scroller.contentSizeType = CCSizeTypeNormalized;
	scroller.contentSize = CGSizeMake(1, 1);
	
	STKHomeScene *homeScene = self.scene;
	[homeScene.timelineContainer addChild:scroller];
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

@end
