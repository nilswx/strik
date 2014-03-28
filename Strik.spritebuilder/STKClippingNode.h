//
//  STKClippingNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 28/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@interface STKClippingNode : CCSprite

// The mask image must be grayscale and what is filled in in the mask is not shown in the image and visa versa
- (id)initWithMask:(UIImage *)mask andNode:(CCNode *)node;

+ (id)clippingNodeWithMask:(UIImage *)mask andNode:(CCNode *)node;

@end
