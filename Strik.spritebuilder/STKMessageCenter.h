//
//  STKMessageCenter.h
//  Strik
//
//  Created by Nils on Sep 29, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKIncomingOpcode.h"

@class STKMessageHandler;
@class STKIncomingMessage;

@interface STKMessageCenter : NSObject

- (void)handleMessagesOf:(STKIncomingOpcode)op withHandler:(STKMessageHandler*)handler;

- (void)handleMessage:(STKIncomingMessage*)message;

+ (STKMessageCenter*)sharedCenter;

@end
