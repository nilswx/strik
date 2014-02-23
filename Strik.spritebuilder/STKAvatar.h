//
//  STKAvatar.m
//  Strik
//
//  Created by Matthijn on Feb 23, 2014.
//  Copyright (c) 2014 Indev. All rights reserved.
//

#import "STKModel.h"

typedef void(^AvatarFetchResultBlock)(CCTexture *avatarTexture);

@interface STKAvatar : STKModel

@property (readonly) NSString *identifier;

- (id)initWithAvatarIdentifier:(NSString *)identifier;
+ (STKAvatar*)avatarWithIdentifier:(NSString*)identifier;

- (void)fetchAvatarWithCallback:(AvatarFetchResultBlock)callback;

@end
