//
//  STKNetConnection.h
//  NetTest
//
//  Created by Nils on Jul 30, 2013.
//  Copyright (c) 2013 Nils. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKCore.h"
#import "STKIncomingOpcode.h"

@class STKOutgoingMessage;
@class STKMessageHandler;

@interface STKNetConnection : STKCoreComponent

- (void)beginConnectToHost:(NSString*)host onPort:(uint16_t)port onConnect:(void(^)(void))connectCallback onDisconnect:(void(^)(void))disconnectCallback;
- (void)disconnect:(NSString*)reason;

- (void)sendMessage:(STKOutgoingMessage*)msg;

- (void)enableEncryptionWithKey:(NSData*)key;
- (void)enableDecryptionWithKey:(NSData*)key;

@end
