//
//  STKAvatarNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"
#import "STKAvatar.h"

@interface STKAvatarNode : CCNode

// The border color
@property (nonatomic) CCColor *borderColor;

// The background color
@property (nonatomic) CCColor *backgroundColor;

// The masked image will be masked to a circle the size of the background
@property (readonly, nonatomic) CCSprite *maskedImage;

// This wil be placed in center without mask, and can show background
@property (readonly, nonatomic) CCSprite *imageSprite;

// The avatar type
@property (readonly) AvatarType avatarType;

// Set the avatar texture and the avatar type
- (void)setAvatarTexture:(CCTexture *)avatarTexture ofType:(AvatarType)avatarType;

@end
