//
//  STKController.m
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKController.h"

#import "STKMessageHandler.h"
#import "STKMessageCenter.h"
#import "STKNetConnection.h"

@implementation STKController

- (void)routeNetMessagesOf:(STKIncomingOpcode)op to:(SEL)selector
{
	STKMessageHandler* handler = [STKMessageHandler handlerForSelector:selector onTarget:self];
	[[STKMessageCenter sharedCenter] handleMessagesOf:op withHandler:handler];
}

- (void)sendNetMessage:(STKOutgoingMessage*)message
{
	[self.core[@"connection"] sendMessage:message];
}

@end
