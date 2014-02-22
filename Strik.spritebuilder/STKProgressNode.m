//
//  STKProgressNode.m
//  Strik
//
//  Created by Matthijn Dijkstra on 22/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKProgressNode.h"

#define VERTICAL_BORDER_MARGIN 5
#define HORIZONTAL_BORDER_MARGIN 6
#define RELATIVE_FONT_SIZE 0.75

typedef NS_ENUM(NSInteger, zIndex)
{
	Z_BORDER,
	Z_LIGHT_SHADE,
	Z_DARK_SHADE
};

@interface STKProgressNode()

@property CCSprite9Slice *borderNode;

@property CCSprite9Slice *lightShadeNode;

@property CCSprite9Slice *darkShadeNode;

@property CCLabelTTF *valueLabel;

@property int value;
@property int totalValue;

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
	self.value = value;
	self.totalValue = totalValue;
	
	if(!self.valueLabel)
	{
		self.valueLabel = [CCLabelTTF labelWithString:@"" fontName:@"Global/Fonts/UbuntuTitling-Bold.ttf" fontSize:self.contentSize.height * RELATIVE_FONT_SIZE];
		self.valueLabel.fontColor = [CCColor whiteColor];
		
		// Center it
		self.valueLabel.position = CGPointMake(self.contentSize.width * self.anchorPoint.x,
										   self.contentSize.height * self.anchorPoint.y - 1);
		
		[self addChild:self.valueLabel];
	}
	
	self.valueLabel.string = [NSString stringWithFormat:@"%d/%d", value, totalValue];
	
	// Calculate the bar width
	CGFloat barWidth = [self fillWidthForValue:(float)value / (float)totalValue];
	
	// And set it to correct size
	self.darkShadeNode.contentSize = CGSizeMake(barWidth, self.darkShadeNode.contentSize.height);
}


// Returns the needed with within min and max based on value (number between 0 and 1)
- (CGFloat)fillWidthForValue:(float)value
{
	float min = 30;
	float max = self.lightShadeNode.contentSize.width;
	
	float size = max * value;
	
	return MAX(min, size);
}

@end
