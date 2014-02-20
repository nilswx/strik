//
//  STKRemoteServerChallenge.h
//  Strik
//
//  Created by Nils on Oct 11, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STKRemoteServerChallenge : NSObject

@property(nonatomic,readonly) NSString* userId;
@property(nonatomic,readonly) NSString* server;
@property(nonatomic,readonly) short port;

+ (STKRemoteServerChallenge*)challengeToUser:(NSString*)userId onServer:(NSString*)server port:(short)port;

@end
