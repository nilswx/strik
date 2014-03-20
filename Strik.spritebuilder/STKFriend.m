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

- (NSString*)description
{
	return [NSString stringWithFormat:@"#%lld (%@)", self.userId, self.fullName];
}

- (NSString *)fullName
{
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
