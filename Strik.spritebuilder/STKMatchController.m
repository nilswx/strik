//
//  STKMatchController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 10/22/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKMatchController.h"

#import "STKOutgoingMessage.h"
#import "STKIncomingMessage.h"
#import "STKMatch.h"
#import "STKDirector.h"
#import "STKPlayer.h"
#import "STKMatchPlayer.h"
#import "STKSessionController.h"
#import "STKAlertView.h"

#import "STKAnnounceMatchController.h"
#import "STKHomeController.h"
#import "STKGameController.h"

#import "STKFriend.h"
#import "STKFacebookController.h"

@interface STKMatchController()

@end

@implementation STKMatchController

- (void)componentDidInstall
{
    [self routeNetMessagesOf:ANNOUNCE_MATCH to:@selector(announcedMatch:)];
	[self routeNetMessagesOf:QUEUE_ENTERED to:@selector(enteredQueue:)];
	[self routeNetMessagesOf:QUEUE_EXITED to:@selector(exitedQueue:)];
	
	// Challenge system
	[self routeNetMessagesOf:CHALLENGE to:@selector(handleChallenge:)];
	[self routeNetMessagesOf:CHALLENGE_DECLINED to:@selector(handleChallengeDeclined:)];
}

- (void)exitMatch
{
	if(self.match)
	{
		NSLog(@"Match: exiting match #%ld", self.match.matchId);
		[self sendNetMessage:[STKOutgoingMessage withOp:EXIT_MATCH]];
	}
}

- (void)requestNewMatch
{
	if(!self.match)
	{
		NSLog(@"Match: requesting new match");
		[self sendNetMessage:[STKOutgoingMessage withOp:REQUEST_MATCH]];
	}
}

- (void)enteredQueue:(STKIncomingMessage *)message
{
	if(!self.match)
	{
		// Determine queue
		NSString *queueName = [message readStr];
		NSLog(@"Match: entered '%@' queue", queueName);
		
		// Show VS scene
		STKDirector *director = self.core[@"director"];
		
		CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.25];
		[director presentScene:(STKSceneController *)[STKAnnounceMatchController new] withTransition:transition];
	}
}

- (void)exitedQueue:(STKIncomingMessage *)message
{
	if(!self.match)
	{
		// This doesn't do anything atm (the queue has been removed and combined with the VS scene)
	}
}

- (void)announcedMatch:(STKIncomingMessage *)message
{
	if(!self.match)
	{
		// Construct match object
		STKMatch* match = [[STKMatch alloc] init];
		match.matchId = [message readLong];
		match.language = [message readStr];
		match.gameTime = [message readInt];
		NSLog(@"Match: new match announced -> #%ld", match.matchId);
		
		// Build local player
		STKSessionController *session = self.core[@"session"];
		match.player = [[STKMatchPlayer alloc] initWithID:[message readByte] andPlayer:session.player];
		
		// Build opponent
		match.opponent = [[STKMatchPlayer alloc] initWithID:[message readByte] andPlayer:[STKPlayer playerFromMessage:message]];
		
		// Create board
		match.countdownTime = [message readByte];
		
		// Keep in session
		self.match = match;
		
		// There are two possibilities here, or we are somewhere else and someone invites us (go to VS Scene) or we are allready @ VS scene
		STKDirector *director = self.core[@"director"];
		
		// Set match on VS controller
		STKAnnounceMatchController *anounceMatchController;
		
		// We are allready on the VS scene
		if([director.sceneController isKindOfClass:[STKAnnounceMatchController class]])
		{
			anounceMatchController = (STKAnnounceMatchController *)director.sceneController;
		}
		// Go to the VS scene now
		else
		{
			anounceMatchController = [STKAnnounceMatchController new];
			CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:0.25];
			[director presentScene:(STKSceneController *)anounceMatchController withTransition:transition];
		}
		
		// And set match
		anounceMatchController.match = match;
	}
}

- (void)playerIsReady
{
	if(self.match)
	{
		// Transition to the actual game scene
		STKDirector *director = self.core[@"director"];
		[director presentScene:[STKGameController new] withTransition:[CCTransition transitionCrossFadeWithDuration:0.25]];
		
		// Say we're good to go!
		[self sendNetMessage:[STKOutgoingMessage withOp:PLAYER_READY]];
	}
}

- (void)handleChallenge:(STKIncomingMessage*)message
{
	// Is player Facebook linked?
	STKFacebookController* facebook = self.core[@"facebook"];
	if(facebook.isServerLinked)
	{
		// Known friend?
		STKFriend* friend = [facebook friendByPlayerId:[message readInt]];
		if(friend)
		{
			// Cool, we're popular!
			NSLog(@"Challenge: received a new match challenge from #%d '%@' (%@)", friend.playerId, friend.name, friend.fullName);
			
			// Format text
			NSString* title = [NSString stringWithFormat:NSLocalizedString(@"Challenged by %@", nil), friend.name];
			NSString* message = [NSString stringWithFormat:NSLocalizedString(@"%@ has challenged you to a match!", nil), friend.fullName];
			
			// Create and identify alert view
			UIAlertView* view = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Decline", nil) otherButtonTitles:NSLocalizedString(@"Accept", nil), nil];
			view.delegate = self;
			view.tag = friend.playerId;
			
			// Pop the big question!
			[view show];
		}
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// Collect details
	int playerId = alertView.tag;
	BOOL acceptChallenge = (buttonIndex == 1);
	NSLog(@"Challenge: %@ challenge from player #%d", (acceptChallenge ? @"accepting" : @"declining"), playerId);
	
	// Relay decision to server
	STKOutgoingMessage* msg = [STKOutgoingMessage withOp:(acceptChallenge ? ACCEPT_CHALLENGE : DECLINE_CHALLENGE)];
	[msg appendInt:playerId];
	[self sendNetMessage:msg];
}

- (void)handleChallengeDeclined:(STKIncomingMessage*)msg
{
	// Is player Facebook linked?
	STKFacebookController* facebook = self.core[@"facebook"];
	if(facebook.isServerLinked)
	{
		// Known friend?
		STKFriend* friend = [facebook friendByPlayerId:[msg readInt]];
		if(friend)
		{
			// Such a sad notification
			[[STKAlertView alertWithTitle:NSLocalizedString(@"Challenge Declined", nil) andMessage:[NSString stringWithFormat:NSLocalizedString(@"%@ declined your challenge. Oh well!", nil), friend.fullName]] show];
		}
	}
}

@end
