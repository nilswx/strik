//
//  STKAvatarPage.h
//  Strik
//
//  Created by Matthijn Dijkstra on 04/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

#define AVATAR_BORDER_COLOR [CCColor colorWithRed:61.0f/255.0f green:60.0f/255.0f blue:62.0f/255.0f]
#define AVATAR_ACTIVE_BORDER_COLOR PLAYER_TWO_COLOR

@class STKAvatar;

@interface STKAvatarPage : CCNode

@property (weak) id controller;

@property (readonly) NSArray *avatars;

- (id)initWithAvatars:(NSArray *)avatars;
+ (id)avatarPageWithAvatars:(NSArray *)avatars;

// Returns the number of avatars which could fit on one page
+ (int)avatarsPerPage;

@end
