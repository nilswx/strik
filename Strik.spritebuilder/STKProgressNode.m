//
//  STKProgressNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKProgressNode.h"

#include <easing.h>

#define VERTICAL_BORDER_MARGIN 5
#define HORIZONTAL_BORDER_MARGIN 6
#define RELATIVE_FONT_SIZE 0.75

#define ANIMATION_TIME 1.5f

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_BORDER,
	Z_BACKGROUND_SHADE,
	Z_FILL_SHADE,
	Z_LABEL
};

@interface STKProgressNode()

// The nodes which make up the progress bar
@property CCSprite9Slice *borderNode;
@property CCSprite9Slice *backgroundShadeNode;
@property CCSprite9Slice *fillShadeNode;

// The label
@property (nonatomic) CCLabelTTF *valueLabel;

// Current values of the progress bar
@property int value;
@property int totalValue;

// The passed time
@property double passedTime;

// And the completion block
@property (copy) AnimationCompletion completionBlock;

@end

@implementation STKProgressNode

- (void)setBorderColor:(CCColor *)borderColor
{
	_borderColor = borderColor;
	
	if(!self.borderNode)
	{
		self.borderNode = [self createFillingRoundedRect];
		self.borderNode.zOrder = Z_BORDER;
	}
	
	if(borderColor)
	{
		self.borderNode.color = borderColor;
	}
}

- (void)setBackgroundShade:(CCColor *)backgroundShade
{
	_backgroundShade = backgroundShade;
	
	if(!self.backgroundShadeNode)
	{
		self.backgroundShadeNode = [self createFillingRoundedRect];
		self.backgroundShadeNode.contentSize = CGSizeMake(self.contentSize.width - VERTICAL_BORDER_MARGIN, self.contentSize.height - HORIZONTAL_BORDER_MARGIN);
		self.backgroundShadeNode.zOrder = Z_BACKGROUND_SHADE;
	}
	
	if(backgroundShade)
	{
		self.backgroundShadeNode.color = backgroundShade;
	}
}

- (void)setFillShade:(CCColor *)fillShade
{
	_fillShade = fillShade;
	
	if(!self.fillShadeNode)
	{
		self.fillShadeNode = [self createFillingRoundedRect];
		self.fillShadeNode.contentSize = CGSizeMake(10, self.contentSize.height - HORIZONTAL_BORDER_MARGIN);

		// It is easier with a anchor point on the left, since we "anchor" it to the left of the progress bar
		self.fillShadeNode.anchorPoint = CGPointMake(0, 0);
		self.fillShadeNode.position = CGPointMake(VERTICAL_BORDER_MARGIN / 2, HORIZONTAL_BORDER_MARGIN / 2);
		
		self.fillShadeNode.zOrder = Z_FILL_SHADE;
	}
	
	if(fillShade)
	{
		self.fillShadeNode.color = fillShade;
	}
}

- (CCSprite9Slice *)createFillingRoundedRect
{
	// Using 9 slice sprites works much better, and looks better :)
	CCSprite9Slice *roundedRect = [CCSprite9Slice spriteWithImageNamed:@"Global/Images/rounded-rect.png"];
	
	// Center it
	roundedRect.position = CGPointMake(self.contentSize.width * self.anchorPoint.x,
									   self.contentSize.height * self.anchorPoint.y);
	
	// Fit it in the parent and add
	roundedRect.contentSize = self.contentSize;
	[self addChild:roundedRect];
	
	return roundedRect;
}

- (void)setValue:(int)value ofTotalValue:(int)totalValue animated:(BOOL)animated
{
	[self setValue:value ofTotalValue:totalValue animated:animated withAnimationCompletion:nil];
}

- (void)setValue:(int)value ofTotalValue:(int)totalValue withAnimationCompletion:(AnimationCompletion)completionBlock
{
	[self setValue:value ofTotalValue:totalValue animated:YES withAnimationCompletion:completionBlock];
}

- (void)setValue:(int)value ofTotalValue:(int)totalValue animated:(BOOL)animated withAnimationCompletion:(AnimationCompletion)completionBlock
{
	self.value = value;
	self.totalValue = totalValue;
	
	if(animated)
	{
		self.completionBlock = completionBlock;
		
		// Animate the progress bar there are no "Action blocks" for this, so doing it on the schedule system
		self.passedTime = 0;
		[self schedule:@selector(animationTick:) interval:1.0f/60.0f repeat:-1 delay:0];
	}
	else
	{
		[self animate:1];
	}
}

- (void)animationTick:(CCTime)time
{
	// Increment time within animation time range, make sure it does not exceed max
	self.passedTime += time;
	self.passedTime = MIN(ANIMATION_TIME, self.passedTime);
	
	// Get relative time (eased)
	float relativeTime = QuadraticEaseOut(self.passedTime / ANIMATION_TIME);
	
	[self animate:relativeTime];
	
	// Stop animating when the animation is completed
	if(self.passedTime == ANIMATION_TIME)
	{
		self.passedTime = 0;
		[self unschedule:@selector(animationTick:)];
		
		// Call the completion block if it is there
		if(self.completionBlock)
		{
			self.completionBlock();
			self.completionBlock = nil;
		}
	}
}

- (void)animate:(float)relativeTime
{
	// Set the label
	[self animateLabel:relativeTime];
	
	// Set the progress
	[self animateProgress:relativeTime];
}

- (void)animateProgress:(float)relativeTime
{
	// Get the percentage for the bar
	float percentageForBar = (float)self.value / (float)self.totalValue;
	
	// Change it based on passed time
	float timedPercentage = relativeTime * percentageForBar;
	
	// And resize the bar
	[self resizeFillShade:timedPercentage];
}

- (void)resizeFillShade:(CGFloat)relativeSize
{
	// Resize the bar
	CGFloat barWidth = [self fillWidthForValue:relativeSize];
	self.fillShadeNode.contentSize = CGSizeMake(barWidth, self.fillShadeNode.contentSize.height);
}

- (void)animateLabel:(float)relativeTime
{
	int relativeValue = self.value * relativeTime;
	self.valueLabel.string = [NSString stringWithFormat:@"%d/%d", relativeValue, self.totalValue];
}

// Returns the needed with within min and max based on value (number between 0 and 1)
- (CGFloat)fillWidthForValue:(float)value
{
	float min = 10;
	float max = self.backgroundShadeNode.contentSize.width;
	
	float size = max * value;
	
	return MAX(min, size);
}

- (CCLabelTTF *)valueLabel
{
	if(!_valueLabel)
	{
		_valueLabel = [self createValueLabel];
	}
	
	return _valueLabel;
}

- (CCLabelTTF *)createValueLabel
{
	// Create the label with the correct size, font and color
	CCLabelTTF *valueLabel = [CCLabelTTF labelWithString:@"" fontName:@"Global/Fonts/UbuntuTitling-Bold.ttf" fontSize:self.contentSize.height * RELATIVE_FONT_SIZE];
	valueLabel.fontColor = [CCColor whiteColor];
	
	// Center it
	valueLabel.position = CGPointMake(self.contentSize.width * self.anchorPoint.x,
									   self.contentSize.height * self.anchorPoint.y - 1);

	valueLabel.zOrder = Z_LABEL;
	valueLabel.verticalAlignment = CCVerticalTextAlignmentCenter;
	valueLabel.horizontalAlignment = CCTextAlignmentCenter;
	
	valueLabel.string = [NSString stringWithFormat:@"0"];
	
	// Add it as child
	[self addChild:valueLabel];
	
	return valueLabel;
}

// When called while animating the animation wil stop
- (void)stopAnimation
{
	// Unschedule animation
	[self unschedule:@selector(animationTick:)];
}

@end

