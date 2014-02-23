//
//  CCNode+ClipVisit.m
//  Strik
//
//  Created by Matthijn Dijkstra on 25/12/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//  Mostly based on: http://www.cocos2d-iphone.org/forums/topic/glscissor-coordinates/ (updated for Cocos2D v3)

#import "CCNode+ClipVisit.h"
#import "ccMacros.h"

@implementation CCNode (ClipVisit)

-(void)preVisitWithClippingRect:(CGRect)clipRect {
	if (!self.visible)
		return;
	
	glEnable(GL_SCISSOR_TEST);
	
	CCDirector *director = [CCDirector sharedDirector];
	CGSize size = [director viewSize];
	CGPoint origin = [self convertToWorldSpaceAR:clipRect.origin];
	CGPoint topRight = [self convertToWorldSpaceAR:ccpAdd(clipRect.origin, ccp(clipRect.size.width, clipRect.size.height))];
	CGRect scissorRect = CGRectMake(origin.x, origin.y, topRight.x-origin.x, topRight.y-origin.y);
	
	// transform the clipping rectangle to adjust to the current screen
	// orientation: the rectangle that has to be passed into glScissor is
	// always based on the coordinate system as if the device was held with the
	// home button at the bottom. the transformations account for different
	// device orientations and adjust the clipping rectangle to what the user
	// expects to happen.
	UIInterfaceOrientation orientation = [CCDirector sharedDirector].interfaceOrientation;

	switch (orientation) {
		case UIInterfaceOrientationPortraitUpsideDown:
			scissorRect.origin.x = size.width-scissorRect.size.width-scissorRect.origin.x;
			scissorRect.origin.y = size.height-scissorRect.size.height-scissorRect.origin.y;
			break;
		case UIInterfaceOrientationLandscapeLeft:
		{
			float tmp = scissorRect.origin.x;
			scissorRect.origin.x = scissorRect.origin.y;
			scissorRect.origin.y = size.width-scissorRect.size.width-tmp;
			tmp = scissorRect.size.width;
			scissorRect.size.width = scissorRect.size.height;
			scissorRect.size.height = tmp;
		}
			break;
		case UIInterfaceOrientationLandscapeRight:
		{
			float tmp = scissorRect.origin.y;
			scissorRect.origin.y = scissorRect.origin.x;
			scissorRect.origin.x = size.height-scissorRect.size.height-tmp;
			tmp = scissorRect.size.width;
			scissorRect.size.width = scissorRect.size.height;
			scissorRect.size.height = tmp;
		}
		default:
		{
			break;
		}
	}
	
	// Handle Retina
	scissorRect = CC_RECT_SCALE(scissorRect, [UIScreen mainScreen].scale);
	
	glScissor((GLint) scissorRect.origin.x, (GLint) scissorRect.origin.y,
			  (GLint) scissorRect.size.width, (GLint) scissorRect.size.height);
}

-(void)postVisit {
	glDisable(GL_SCISSOR_TEST);
}

@end
