//
//  STKController.h
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKCore.h"
#import "STKIncomingOpcode.h"

@class STKIncomingMessage;
@class STKOutgoingMessage;

@interface STKController : STKCoreComponent

- (void)routeNetMessagesOf:(STKIncomingOpcode)op to:(SEL)handler;

- (void)sendNetMessage:(STKOutgoingMessage*)message;

@end
