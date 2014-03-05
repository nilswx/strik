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
#import "STKBoard.h"
#import "STKTileSelectionBuffer.h"
#import "STKAlertView.h"

#import "STKVSController.h"

@interface STKMatchController()

// The MatchSceneController needs to be created before the countdown starts, so it can start to receive network events
//@property (nonatomic, strong) STKMatchGameController *gameSceneController;

@end

@implementation STKMatchController

- (void)componentDidInstall
{
    [self routeNetMessagesOf:ANNOUNCE_MATCH to:@selector(announcedMatch:)];
	[self routeNetMessagesOf:QUEUE_ENTERED to:@selector(enteredQueue:)];
	[self routeNetMessagesOf:QUEUE_EXITED to:@selector(exitedQueue:)];
    [self routeNetMessagesOf:MATCH_STARTED to:@selector(matchDidStart:)];
    [self routeNetMessagesOf:MATCH_ENDED to:@selector(matchDidEnd:)];
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
		[director presentScene:(STKSceneController *)[STKVSController new] withTransition:transition];
	}
}

- (void)exitedQueue:(STKIncomingMessage *)message
{
	if(!self.match)
	{
		STKDirector *director = self.core[@"director"];
		// Todo: Present home scene
//		[director presentScene:[STKHomeScene class]];
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
		match.player = [STKMatchPlayer player:[message readByte] withUser:session.user];
		
		// Build opponent
		match.opponent = [STKMatchPlayer player:[message readByte] withUser:[STKPlayer playerFromMessage:message]];
		
		// Create board
		match.countdownTime = [message readByte];
		
		// Keep in session
		self.match = match;
		
		// And display the loading screen
		STKDirector *director = self.core[@"director"];
		// Todo: Present match loading scene
//		[director presentScene:[STKMatchLoadingScene class]];
	}
}

- (void)playerIsReady
{
	if(self.match)
	{
		// First create the new match scene controller, it must be there to handle some network events
//		self.gameSceneController = [[STKMatchGameController alloc] initWithCore:self.core];
		NSLog(@"Match: loading done, local player READY!");
		
		// Say we're good to go!
		[self sendNetMessage:[STKOutgoingMessage withOp:PLAYER_READY]];
	}
}

- (void)matchDidStart:(STKIncomingMessage *)message
{
	if(self.match)
	{
		NSLog(@"Match: started!");
		
		// Transfer to the actual match
		STKDirector *director = self.core[@"director"];
		// Todo: present match game scene
//		[director presentScene:self.gameSceneController];
	}
}

- (void)matchDidEnd:(STKIncomingMessage *)message
{
	if(self.match)
	{
		// Determine winner
		STKMatchPlayer* winner = [self.match playerByID:[message readByte]];
		
		// Aaaand it's gone
		self.match = nil;
		NSLog(@"Match: ended!");
		
		// Show statistics from the match
		STKDirector *director = self.core[@"director"];
		// Todo: present match ended scene
//		[director presentScene:[STKMatchEndedScene class]];
		
		// Show result alert
		NSString* resultMessage;
		if(winner)
		{
			resultMessage = [NSString stringWithFormat:@"%@ won!", winner.user.name];
		}
		else
		{
			resultMessage = @"Draw!";
		}[[STKAlertView alertWithTitle:@"Match Ended" andMessage:resultMessage] show];
	}
}

@end
