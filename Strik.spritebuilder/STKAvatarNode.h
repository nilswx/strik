//
//  STKAvatarNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@interface STKAvatarNode : CCNode

// The border color
@property (nonatomic) CCColor *borderColor;

// The background color
@property (nonatomic) CCColor *backgroundColor;

// The masked image will be masked to a circle the size of the background
@property (nonatomic) CCSprite *maskedImage;

// This wil be placed in center without mask, and can show background
@property (nonatomic) CCSprite *imageSprite;

@end
