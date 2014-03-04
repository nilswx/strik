//
//  STKAvatar.m
//  Strik
//
//  Created by Matthijn on Feb 23, 2014.
//  Copyright (c) 2014 Indev. All rights reserved.
//

#import "STKModel.h"

#define CLIENT_AVATAR_COUNT 15

typedef NS_ENUM(NSInteger, AvatarType)
{
	AvatarTypeProfile,
	AvatarTypeClient,
	AvatarTypeNoFacebook
};

#define AVATAR_TYPE_NO_FACEBOOK_ID @"facebook-default"

typedef void(^AvatarFetchResultBlock)(CCTexture *avatarTexture, AvatarType avatarType);

@interface STKAvatar : STKModel

// The avatar identifier
@property NSString *identifier;

// The avatar type (e.g profile picture, or chosen from the client avatar collection)
@property (readonly) AvatarType avatarType;

- (id)initWithAvatarIdentifier:(NSString *)identifier;
+ (STKAvatar*)avatarWithIdentifier:(NSString*)identifier;

- (void)fetchAvatarWithCallback:(AvatarFetchResultBlock)callback;

@end
