//
//  STKLobbyController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLobbyController.h"

#import "STKHomeScene.h"

#import "STKFriend.h"
#import "STKFacebookController.h"
#import "STKLobbyPersonNode.h"
#import "STKLobbyScene.h"
#import "GridNode.h"

#import "STKMatchController.h"
#import "STKHomeController.h"
#import "STKAudioController.h"

#import "STKDirector.h"

#import "STKIncomingMessage.h"
#import "STKOutgoingMessage.h"

#import <FacebookSDK/FBWebDialogs.h>

@interface STKLobbyController()

// The nodes to display
@property NSMutableArray *friendsNodes;
@property NSMutableArray *facebookNodes;

// The facebook users and friends
@property NSArray *facebookUsers;
@property NSArray *friends;

@end

@implementation STKLobbyController

- (void)sceneCreated
{
	// Start music
	[self.core[@"audio"] playMusicWithName:@"bg-lobby"];
	
	// Determine if we can show friends or not
	STKFacebookController *facebookController = self.core[@"facebook"];

	// We can show friends!
	if(facebookController.isServerLinked)
	{
		// Show the friends on the scene
		[(STKLobbyScene *)(self.scene) showFriends];
		
		// These will be filled when needed with friends
		self.friendsNodes = [NSMutableArray array];
		self.facebookNodes = [NSMutableArray array];
		
		// Get the facebook users and friends
		self.facebookUsers = [self getSortedFacebookUsers];
		self.friends = [self getSortedFriends];
	}
	
	// Handle network messages of the challenge system
	[self routeNetMessagesOf:CHALLENGE_OK to:@selector(handleChallengeOK:)];
	[self routeNetMessagesOf:CHALLENGE_FAILED to:@selector(handleChallengeFailed:)];
	[self routeNetMessagesOf:CHALLENGE_REDIRECT to:@selector(handleChallengeRedirect:)];
	[self routeNetMessagesOf:CHALLENGE_LOCALE_MISMATCH to:@selector(handleChallengeLocaleMismatch:)];
}

# pragma mark Loading friends
- (NSArray *)getSortedFacebookUsers
{
	// Get the facebook users
	STKFacebookController *facebookController = self.core[@"facebook"];
	NSArray *facebookUsers = [facebookController.facebookOnlyFriends allValues];
	
	// Sort the crap out of em (on fullname)
	NSSortDescriptor *lastNameSorter = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
	NSSortDescriptor *firstNameSorter = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
	return [facebookUsers sortedArrayUsingDescriptors:@[lastNameSorter, firstNameSorter]];
}

- (NSArray *)getSortedFriends
{
	// Get the friends
	STKFacebookController *facebookController = self.core[@"facebook"];
	NSArray *friends = [facebookController.playerFriends allValues];
	
	// Sort the crap out of em (on fullname)
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
	return [friends sortedArrayUsingDescriptors:@[sortDescriptor]];
}

#pragma mark buttons
- (void)onBackButton:(CCButton *)button
{
	[self transitionTo:[STKHomeScene class] direction:CCTransitionDirectionRight];
}

- (void)onRandomOpponentButton:(CCButton *)button
{
	// Requesting a random match
    STKMatchController *matchController = self.core[@"match"];
    [matchController requestNewMatch];
}

- (void)onScrollTopButton:(CCButton *)button
{
	[[self scene] scrollUp];
}

#pragma mark User interaction
- (void)onNoFriendsButton:(CCButton *)sender
{
	// Go back to home and show settings
	STKHomeController *homeSceneController = [STKHomeController new];
	
	// Make sure we display the settings after transition
	homeSceneController.shouldDisplaySettingsAfterEnterTransition = YES;
	
	// And start transition
	STKDirector *director = self.core[@"director"];
	[director presentScene:homeSceneController withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionRight duration:0.25f]];
}

#pragma mark Grid datasource
- (CGSize)cellSize
{
	return CGSizeMake(320 , 86);
}

- (int)columnCount
{
	return 1;
}

- (int)rowCount
{
	int rowCount = (int)(self.facebookUsers.count + self.friends.count);
	
	if(rowCount >= 6)
	{
		// This makes sure the background of the bottom of the app matches the node with the last color when needed
		STKLobbyScene *lobbyScene = self.scene;
		if(rowCount % 2 == 0)
		{
			[lobbyScene showBottom];
		}
		else
		{
			[lobbyScene hideBottom];
		}
	}
	return rowCount;
}

- (CCNode *)nodeForColumn:(int)column andRow:(int)row
{
	STKLobbyPersonNode *listNode;
	
	// The first part of the list are the strik friends
	if(row < self.friends.count)
	{
		// Create the friend node if we did not do that yet
		if(self.friendsNodes.count <= row)
		{
			STKLobbyPersonNode *friendNode = [STKLobbyPersonNode newLobbyPersonNodeWithFriend:[self.friends objectAtIndex:row]];
			[self.friendsNodes addObject:friendNode];
		}
		
		listNode = [self.friendsNodes objectAtIndex:row];
	}
	// And below that the facebook friends
    else
    {
		// Calculate the correct index, since we are further in this table allready
		int index = row - ((int)self.friends.count);
		
		// Create and add ALL missing nodes
		for(int x = self.facebookNodes.count; x <= index; x++)
		{
			STKLobbyPersonNode *facebookNode = [STKLobbyPersonNode newLobbyPersonNodeWithFriend:[self.facebookUsers objectAtIndex:x]];
			[self.facebookNodes addObject:facebookNode];
		}
		
		// Get the node we need
		listNode = [self.facebookNodes objectAtIndex:index];
	}
	
	// Alternate colors between odd and even
	if(row % 2 == 0)
	{
		listNode.backgroundNode.color = [CCColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
	}
	else
	{
		listNode.backgroundNode.color = [CCColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1];
	}
	
	//TODO: mark update colors of background grid node so it matches the first and last node for 50%
	// The bottom row should not have a dividing line so hiding that, and making it visible when it should be visible again
	if(row == (self.facebookUsers.count + self.friends.count) - 1)
	{
		listNode.bottomLine.opacity = 0;
	}
	else
	{
		listNode.bottomLine.opacity = 1;
	}
	
	return listNode;
}

- (void)tappedNodeAtColumn:(int)column andRow:(int)row
{
	// Get the node
	STKLobbyPersonNode* node = (STKLobbyPersonNode*)[self nodeForColumn:column andRow:row];
	if(node)
	{
		// Get the friend
		STKFriend* friend = node.friend;
		if(friend.isPlayer)
		{
			// Available?
			if(friend.isOnline && !friend.isInMatch)
			{
				NSLog(@"Lobby: challenging %@", friend);
				
				// Challenge him/her (and animate etc)
				STKOutgoingMessage* msg = [STKOutgoingMessage withOp:CHALLENGE_PLAYER];
				[msg appendInt:friend.playerId];
				[self sendNetMessage:msg];
			}
		}
		else
		{
			NSLog(@"Lobby: invite %@", friend);
			
			// Present invite dialog
			id params = @{@"to": [NSString stringWithFormat:@"%lld", friend.userId]};
			[FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"Welcome to Strik!" title:@"Invite Friends" parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
			{
				if(result == FBWebDialogResultDialogCompleted)
				{
					if(error)
					{
						NSLog(@"Lobby: could not invite %@! (error=%@)", friend, error);
					}
					else
					{
						NSLog(@"Lobby: invited %@ successfully!", friend);
					}
				}
				else
				{
					NSLog(@"Lobby: canceled Facebook invite...");
				}
			}];
		}
	}
}

- (void)handleChallengeOK:(STKIncomingMessage*)msg
{
	STKFriend* friend = [self.core[@"facebook"] friendByPlayerId:[msg readInt]];
	if(friend)
	{
		// Challenge was delivered successfully, waiting now...
	}
}

- (void)handleChallengeFailed:(STKIncomingMessage*)msg
{
	STKFriend* friend = [self.core[@"facebook"] friendByPlayerId:[msg readInt]];
	if(friend)
	{
		// Challenge could not be delivered
	}
}

- (void)handleChallengeRedirect:(STKIncomingMessage*)msg
{
	STKFriend* friend = [self.core[@"facebook"] friendByPlayerId:[msg readInt]];
	if(friend)
	{
		NSString* host = [msg readStr];
		int port = [msg readInt];
		
		// Friend is available, but need to reconnect to specified server and re-challenge him/her
	}
}

- (void)handleChallengeLocaleMismatch:(STKIncomingMessage*)msg
{
	STKFriend* friend = [self.core[@"facebook"] friendByPlayerId:[msg readInt]];
	if(friend)
	{
		NSString* requiredLocale = [msg readStr];
		
		// Friend is available, but is playing in a different locale. Ask user if he wants to change
	}
}

@end
