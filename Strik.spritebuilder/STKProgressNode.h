//
//  STKProgressNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCNode.h"

@class CCtime;

typedef void(^AnimationCompletion)();

@interface STKProgressNode : CCNode

// The color of the border
@property (nonatomic) CCColor *borderColor;

// The darker (fill color)
@property (nonatomic) CCColor *fillShade;

// The lighter (fill color)
@property (nonatomic) CCColor *backgroundShade;

// Give it a value, and a total value, it will take care of the rest animation is optional
- (void)setValue:(int)value ofTotalValue:(int)totalValue animated:(BOOL)animated;

// Same, but will call the block once the animation is completed (animation is mandatory)
- (void)setValue:(int)value ofTotalValue:(int)totalValue withAnimationCompletion:(AnimationCompletion)completionBlock;


#pragma mark PROTECTED! Use at own risk. Kittens might die!

// Resizes the dark shade to a given percentage
- (void)resizeFillShade:(CGFloat)percentage;

// A single animation tick
- (void)animationTick:(CCTime)time;

// Returns and adds a value label to the scene
- (CCLabelTTF *)createValueLabel;

// When called while animating the animation wil stop
- (void)stopAnimation;

@end
