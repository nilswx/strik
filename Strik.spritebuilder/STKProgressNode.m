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
	Z_LIGHT_SHADE,
	Z_DARK_SHADE
};

@interface STKProgressNode()

// The nodes which make up the progress bar
@property CCSprite9Slice *borderNode;
@property CCSprite9Slice *lightShadeNode;
@property CCSprite9Slice *darkShadeNode;

// The label
@property CCLabelTTF *valueLabel;

// Current values of the progress bar
@property int value;
@property int totalValue;

// The passed time for the animation
@property double passedTime;

// The completionblock which will get called when set
@property (strong) AnimationCompletion completionBlock;

@end

@implementation STKProgressNode

- (void)setBorderColor:(CCColor *)borderColor
{
	_borderColor = borderColor;
	
	if(!self.borderNode)
	{
		self.borderNode = [self createFillingRoundedRect];
	}
	
	if(borderColor)
	{
		self.borderNode.color = borderColor;
	}
}

- (void)setLightShade:(CCColor *)lightShade
{
	_lightShade = lightShade;
	
	if(!self.lightShadeNode)
	{
		self.lightShadeNode = [self createFillingRoundedRect];
		self.lightShadeNode.contentSize = CGSizeMake(self.contentSize.width - VERTICAL_BORDER_MARGIN, self.contentSize.height - HORIZONTAL_BORDER_MARGIN);
	}
	
	if(lightShade)
	{
		self.lightShadeNode.color = lightShade;
	}
}

- (void)setDarkShade:(CCColor *)darkShade
{
	_darkShade = darkShade;
	
	if(!self.darkShadeNode)
	{
		self.darkShadeNode = [self createFillingRoundedRect];
		self.darkShadeNode.contentSize = CGSizeMake(10, self.contentSize.height - HORIZONTAL_BORDER_MARGIN);

		// It is easier with a anchor point on the left, since we "anchor" it to the left of the progress bar
		self.darkShadeNode.anchorPoint = CGPointMake(0, 0);
		self.darkShadeNode.position = CGPointMake(VERTICAL_BORDER_MARGIN / 2, HORIZONTAL_BORDER_MARGIN / 2);
	}
	
	if(darkShade)
	{
		self.darkShadeNode.color = darkShade;
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

- (void)setValue:(int)value ofTotalValue:(int)totalValue
{
	[self setValue:value ofTotalValue:totalValue withAnimationCompletion:nil];
}

- (void)setValue:(int)value ofTotalValue:(int)totalValue withAnimationCompletion:(AnimationCompletion)completionBlock
{
	self.value = value;
	self.totalValue = totalValue;
	self.completionBlock = completionBlock;
	
	if(!self.valueLabel)
	{
		self.valueLabel = [CCLabelTTF labelWithString:@"" fontName:@"Global/Fonts/UbuntuTitling-Bold.ttf" fontSize:self.contentSize.height * RELATIVE_FONT_SIZE];
		self.valueLabel.fontColor = [CCColor whiteColor];
		
		// Center it
		self.valueLabel.position = CGPointMake(self.contentSize.width * self.anchorPoint.x,
											   self.contentSize.height * self.anchorPoint.y - 1);
		
		[self addChild:self.valueLabel];
	}
	
	// Animate the progress bar there are no "Action blocks" for this, so doing it on the schedule system
	self.passedTime = 0;
	[self unschedule:@selector(animate:)];
	[self schedule:@selector(animate:) interval:1.0f/60.0f repeat:-1 delay:0];
}

- (void)animate:(CCTime)time
{
	// Increment time within animation time range, make sure it does not exceed max
	self.passedTime += time;
	self.passedTime = MIN(ANIMATION_TIME, self.passedTime);
	
	// Get relative time (eased)
	float relativeTime = QuadraticEaseOut(self.passedTime / ANIMATION_TIME);
	
	// Animate the progress bar
	[self animateProgress:relativeTime];
	
	// Animate the label
	[self animateLabel:relativeTime];
	
	// Stop animating when the animation is completed
	if(self.passedTime == ANIMATION_TIME)
	{
		self.passedTime = 0;
		[self unschedule:@selector(animate:)];
		
		// Call the completion block if it is there
		if(self.completionBlock)
		{
			self.completionBlock();
			self.completionBlock = nil;
		}
	}
}

- (void)animateProgress:(float)relativeTime
{
	// Get the percentage for the bar
	float percentageForBar = (float)self.value / (float)self.totalValue;
	
	// Apply a little easing
	float easedPercentage = relativeTime * percentageForBar;
	
	// Resize the bar
	CGFloat barWidth = [self fillWidthForValue:easedPercentage];
	self.darkShadeNode.contentSize = CGSizeMake(barWidth, self.darkShadeNode.contentSize.height);

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
	float max = self.lightShadeNode.contentSize.width;
	
	float size = max * value;
	
	return MAX(min, size);
}

@end
