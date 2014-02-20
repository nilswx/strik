//
//  STKFriend.m
//  Strik
//
//  Created by Nils on Nov 30, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKFriend.h"

@implementation STKFriend

- (BOOL)isPlayer
{
	return (self.playerId > 0);
}

@synthesize profileImageUrl = _profileImageUrl;

- (NSString*)profileImageUrl
{
	if(!self->_profileImageUrl)
	{
		self->_profileImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%lld/picture?width=180&height=180", self.userId];
	}
	
	return self->_profileImageUrl;
}

@end
