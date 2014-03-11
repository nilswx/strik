//
//  STKFriend.h
//  Strik
//
//  Created by Nils on Nov 30, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

@class STKAvatar, STKPlayer;

@interface STKFriend : STKModel

// Facebook
@property int64_t userId;
@property NSString *fullName;

// Game
@property int32_t playerId;
@property NSString *name;
@property STKAvatar *avatar;
@property BOOL isOnline;
@property BOOL isInMatch;
@property (readonly) BOOL isPlayer;

@end
