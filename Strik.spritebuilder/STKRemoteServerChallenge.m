//
//  STKRemoteServerChallenge.m
//  Strik
//
//  Created by Nils on Oct 11, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKRemoteServerChallenge.h"

@implementation STKRemoteServerChallenge

- (id)initWithUserId:(NSString*)userId andServer:(NSString*)server andPort:(short)port
{
	if(self = [super init])
	{
		_userId = userId;
		_server = server;
		_port = port;
	}
	
	return self;
}

+ (STKRemoteServerChallenge*)challengeToUser:(NSString*)userId onServer:(NSString*)server port:(short)port
{
	return [[STKRemoteServerChallenge alloc] initWithUserId:userId andServer:server andPort:port];
}

@end
