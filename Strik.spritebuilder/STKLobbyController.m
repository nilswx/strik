//
//  STKLobbyController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKLobbyController.h"
#import "STKHomeScene.h"

#import "STKFacebookController.h"
#import "STKLobbyPersonNode.h"

@interface STKLobbyController()

// The nodes to display
@property NSMutableArray *friendsNodes;
@property NSMutableArray *facebookNodes;
@property CCNode *inviteInformationNode;

// The facebook users and friends
@property NSArray *facebookUsers;
@property NSArray *friends;

@end

@implementation STKLobbyController

- (void)sceneCreated
{
	// These will be filled when needed
	self.friendsNodes = [NSMutableArray array];
	self.facebookNodes = [NSMutableArray array];
	
	// Get the facebook users and friends
	self.facebookUsers = [self getSortedFacebookUsers];
	self.friends = [self getSortedFriends];
}

# pragma mark Loading friends
- (NSArray *)getSortedFacebookUsers
{
	// Get the facebook users
	STKFacebookController *facebookController = self.core[@"facebook"];
	NSArray *facebookUsers = [facebookController.facebookOnlyFriends allValues];
	
	// Sort the crap out of em (on fullname)
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fullName" ascending:YES];
	return [facebookUsers sortedArrayUsingDescriptors:@[sortDescriptor]];
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
	NSLog(@"Pressed random game button.");
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
	return (int)(self.facebookUsers.count + self.friends.count);
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
		
		// Create the node if it has not been created before
		if(self.facebookNodes.count <= index)
		{
			STKLobbyPersonNode *facebookNode = [STKLobbyPersonNode newLobbyPersonNodeWithFriend:[self.facebookUsers objectAtIndex:index]];
			[self.facebookNodes addObject:facebookNode];
		}
		
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

@end
