//
//  STKClientController.h
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKController.h"

@interface STKClientController : STKController

- (void)registerOrLogin;

- (void)clearCredentials;

- (BOOL)storePlayerID:(int)playerId andToken:(NSString*)token;

- (void)connectToServer;

- (void)didDisconnectFromServer;

- (void)changeLocale:(NSString*)locale;

@end
