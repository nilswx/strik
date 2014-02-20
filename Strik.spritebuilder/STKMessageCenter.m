//
//  STKMessageCenter.m
//  Strik
//
//  Created by Nils on Sep 29, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKMessageCenter.h"

#import "STKIncomingMessage.h"
#import "STKMessageHandler.h"

@interface STKMessageCenter()

@property(nonatomic) NSMutableDictionary* handlers;

@end

@implementation STKMessageCenter

- (id)init
{
	if(self = [super init])
	{
		self.handlers = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (void)handleMessagesOf:(STKIncomingOpcode)op withHandler:(STKMessageHandler*)handler
{
	self.handlers[@(op)] = handler;
	//NSLog(@"MessageCenter: registered handler for #%d (%@)", op, handler);
}

- (void)handleMessage:(STKIncomingMessage*)message
{
	STKMessageHandler* handler = self.handlers[@(message.op)];
	if(handler)
	{
		NSLog(@"%@ (#%d, %d bytes)", handler, message.op, message.size);
		[handler handleMessage:message];
	}
	else
	{
		NSLog(@"MessageCenter: received unknown message #%d", message.op);
	}
}

STKMessageCenter* instance;

+ (STKMessageCenter*)sharedCenter
{
	if(!instance)
	{
		instance = [[STKMessageCenter alloc] init];
	}
	return instance;
}

@end
