//
//  STKSplittedProgressNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 19/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKProgressNode.h"

@interface STKSplittedProgressNode : STKProgressNode

// Give it a left value, and a right value, it will take care of the rest animation is optional
- (void)setLeftValue:(int)leftValue andRightValue:(int)rightValue animated:(BOOL)animated;

// Same, but will call the block once the animation is completed
- (void)setLeftValue:(int)leftValue andRightValue:(int)rightValue withAnimationCompletion:(AnimationCompletion)completionBlock;

- (void)setLeftValue:(int)leftValue andRightValue:(int)rightValue animated:(BOOL) animated withAnimationCompletion:(AnimationCompletion)completionBlock;

@end
