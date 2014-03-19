//
//  STKSplittedProgressNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 19/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSplittedProgressNode.h"

// The size (1 is full width 0 nothing) minimal available for a label (else it just looks odd)
#define MINIMAL_LABEL_SPACE 0.2

@interface STKSplittedProgressNode()

// The left and right values
@property int leftValue;
@property int rightValue;

// The left and right labels
@property (nonatomic) CCLabelTTF *leftLabel;
@property (nonatomic) CCLabelTTF *rightLabel;

// The passed time
@property double passedTime;

// And the completion block
@property (copy) AnimationCompletion completionBlock;

@end

@implementation STKSplittedProgressNode

- (void)setValue:(int)value ofTotalValue:(int)totalValue animated:(BOOL)animated withAnimationCompletion:(AnimationCompletion)completionBlock
{
	NSAssert(NO, @"This is a splitted progress node, use setLeftValue: andRightValue instead.");
}

// Give it a left value, and a right value, it will take care of the rest animation is optional
- (void)setLeftValue:(int)leftValue andRightValue:(int)rightValue animated:(BOOL)animated
{
	[self setLeftValue:leftValue andRightValue:rightValue animated:animated withAnimationCompletion:nil];
}

// Same, but will call the block once the animation is completed (animation is mandatory)
- (void)setLeftValue:(int)leftValue andRightValue:(int)rightValue withAnimationCompletion:(AnimationCompletion)completionBlock
{
	[self setLeftValue:leftValue andRightValue:rightValue animated:YES withAnimationCompletion:completionBlock];
}

- (void)setLeftValue:(int)leftValue andRightValue:(int)rightValue animated:(BOOL) animated withAnimationCompletion:(AnimationCompletion)completionBlock
{
	self.leftValue = leftValue;
	self.rightValue = rightValue;
	
	self.completionBlock = completionBlock;
	
	// Only animate if there is a score, else you are waiting for the animation to complete and nothing happens
	if(animated && (self.leftValue != 0 || self.rightValue != 0))
	{
		// Animate the progress bar there are no "Action blocks" for this, so doing it on the schedule system
		self.passedTime = 0;
		[self schedule:@selector(animationTick:) interval:1.0f/60.0f repeat:-1 delay:0];
	}
	else
	{
		[self animate:1];
		
		if(completionBlock)
		{
			completionBlock();
		}
	}
}

- (void)animate:(float)relativeTime
{
	// Set the progress
	[self animateProgress:relativeTime];
	
	// And labels
	[self animateLabels:relativeTime];
}

- (void)animateProgress:(float)relativeTime
{
	[self resizeFillShade:[self leftBarPercentageForTime:relativeTime]];
}

- (float)leftBarPercentageForTime:(float)relativeTime
{
	float percentageForLeftBar = (float)self.leftValue / ((float)self.leftValue + (float)self.rightValue);
	float timedPercentage = percentageForLeftBar * relativeTime;
	
	// There is a limit on how smal and large the dark part can be since it must be able to hold its label
	return MIN(MAX(MINIMAL_LABEL_SPACE, timedPercentage), 1 - MINIMAL_LABEL_SPACE);
}

- (void)animateLabels:(float)relativeTime
{
	// The labels must be centered in their own part of the bars
	
	// The the bar percentages
	float leftBarPercentage = [self leftBarPercentageForTime:relativeTime];
	float rightBarPercentage = 1 - leftBarPercentage;
	
	// Position left label and set value
	self.leftLabel.position = CGPointMake((self.contentSize.width * leftBarPercentage) * self.anchorPoint.x + 1, self.contentSize.height * self.anchorPoint.y - 1);
	self.leftLabel.string = [NSString stringWithFormat:@"%d", (int)ceil(relativeTime * self.leftValue)];
	
	// Position right label and set value
	self.rightLabel.position = CGPointMake(((leftBarPercentage + (rightBarPercentage / 2)) * self.contentSize.width - 1), self.contentSize.height * self.anchorPoint.y - 1);
	self.rightLabel.string = [NSString stringWithFormat:@"%d", (int)ceil(relativeTime * self.rightValue)];
}

- (CCLabelTTF *)leftLabel
{
	if(!_leftLabel)
	{
		// If there was only such a thing as protected
		_leftLabel = [self createValueLabel];
	}
	
	return _leftLabel;
}

- (CCLabelTTF *)rightLabel
{
	if(!_rightLabel)
	{
		// If there was only such a thing as protected
		_rightLabel = [self createValueLabel];
	}
	
	return _rightLabel;
}

@end
