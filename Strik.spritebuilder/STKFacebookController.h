//
//  STKFacebook.h
//  Strik
//
//  Created by Nils on Aug 17, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKController.h"



@class STKFriend;

@interface STKFacebookController : STKController

- (void)openSessionWithCallback:(void(^)(void))callback;

- (STKFriend*)friendByUserId:(int64_t)userId;

- (STKFriend*)friendByPlayerId:(int)playerId;

@property(readonly) int64_t userId;
@property(readonly) BOOL isServerLinked;

@property BOOL allowPublishing;
@property BOOL hasClaimedLike;

@property (nonatomic, readonly) NSMutableDictionary *allFriends;
@property (nonatomic, readonly) NSMutableDictionary *playerFriends;
@property (nonatomic, readonly) NSMutableDictionary *facebookOnlyFriends;

@end
