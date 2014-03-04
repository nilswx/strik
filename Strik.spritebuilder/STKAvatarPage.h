//
//  STKAvatarPage.h
//  Strik
//
//  Created by Matthijn Dijkstra on 04/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@interface STKAvatarPage : CCNode

@property (weak) id controller;

@property (readonly) NSArray *avatars;

- (id)initWithAvatars:(NSArray *)avatars;
+ (id)avatarPageWithAvatars:(NSArray *)avatars;

// Returns the number of avatars which could fit on one page
+ (int)avatarsPerPage;

@end
