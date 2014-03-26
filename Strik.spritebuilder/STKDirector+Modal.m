//
//  STKDirector+Modal.m
//  Strik
//
//  Created by Matthijn Dijkstra on 27/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKDirector+Modal.h"
#import <objc/runtime.h>

#import "STKScene.h"
#import "STKSceneController.h"

#import "ScrollNode.h"
#import "STKHolePunchedButton.h"

#import <UIImage+BlurredFrame/UIImage+BlurredFrame.h>

#define BLUR_TINT_COLOR [UIColor colorWithWhite:0.1 alpha:0.1]
#define BLUR_RADIUS 15
#define BLUR_SATURATION 1.8f

@implementation STKDirector (Modal)

@dynamic overlayScene;
@dynamic overlaySceneController;
@dynamic blurredBackground;

// Displays a scene over the current scene with blurred background
- (void)overlayScene:(STKSceneController *)sceneController
{
	// Keep track of the overlay scene controller and scene
	self.overlaySceneController = sceneController;
	self.overlayScene = sceneController.scene;

	// What is a controller without a core...
	self.overlaySceneController.core = self.core;
	
	// Make sure the events are fired
	[self.overlaySceneController sceneCreated];
	[self.overlaySceneController sceneWillBegin];
	[self.overlayScene sceneWillBegin];
	
	// Disable scrolling in the current scene (else the scroll views overlay the overlay)
	[self enableScrolling:NO forNodesIntree:self.scene];
	
	// Create the blurred background which will capture touch
	// Todo: blur it

	// Create a full screen blurred node
	self.blurredBackground = [self createBlurredBackground];
	
	self.blurredBackground.contentSizeType = CCSizeTypeNormalized;
	self.blurredBackground.contentSize = CGSizeMake(1, 1);
	self.blurredBackground.anchorPoint = CGPointMake(0, 0);
	
	// Add a full screen button to this node, so when it is tapped the window closes
	STKHolePunchedButton *button = [STKHolePunchedButton holePunchedButtonWithCenterNode:self.overlayScene];
	[button setTarget:self selector:@selector(tappedBackground:)];
	[self.blurredBackground addChild:button];
	
	[self.scene addChild:self.blurredBackground];
	
	// Make sure the scene is centered
	self.overlayScene.positionType = CCPositionTypeNormalized;
	self.overlayScene.position = CGPointMake(0.5, 0.5);
	self.overlayScene.anchorPoint = CGPointMake(0.5, 0.5);
		
	// And put it on screen
	[self.scene addChild:self.overlayScene];
	
	// Run an animation for the blurred background
	CCActionFadeIn *opacity = [CCActionFadeIn actionWithDuration:0.1];
	self.blurredBackground.opacity = 0;
	[self.blurredBackground runAction:opacity];
	
	// And an animation for the overlay scene
	self.overlayScene.scale = 0;
	CCActionScaleTo *scale = [CCActionScaleTo actionWithDuration:0.5 scale:1];
	CCActionEaseElasticOut *eased = [CCActionEaseElasticOut actionWithAction:scale period:1];
	
	[self.overlayScene runAction:eased];
}

- (void)hideOverlay
{
	if(self.overlaySceneController)
	{
		[self tappedBackground:nil];
	}
}

#pragma mark buttons
- (void)tappedBackground:(CCButton *)button
{
	// Make sure the events are fired
	[self.overlaySceneController sceneWillEnd];
	[self.overlayScene sceneWillEnd];
	
	// Animate it
	CCActionFadeOut *opacity = [CCActionFadeOut actionWithDuration:0.4];
	CCActionSequence *sequence = [CCActionSequence actionWithArray:@[opacity, [CCActionCallBlock actionWithBlock:^{
		[self.blurredBackground removeFromParent];
		self.blurredBackground = nil;
	}]]];
	
	[self.blurredBackground runAction:sequence];

	CCActionScaleTo *scaleDown = [CCActionScaleTo actionWithDuration:0.4 scale:0];
	CCActionEaseElasticIn *eased = [CCActionEaseElasticIn actionWithAction:scaleDown period:1];
	[self.overlayScene runAction:[CCActionSequence actionWithArray:@[eased, [CCActionCallBlock actionWithBlock:^{

		[self.overlayScene removeFromParent];
		
		self.overlayScene = nil;
		self.overlaySceneController = nil;

		// Re-enable scrolling and touches
		[self enableScrolling:YES forNodesIntree:self.scene];

	}]]]];
}

// Disable or enable scrolling for any node if it supports it in the tree
- (void)enableScrolling:(BOOL)enableScrolling forNodesIntree:(CCNode *)nodeTree
{
	// If it is a scroll node, disable scrolling
	if([nodeTree isKindOfClass:[ScrollNode class]])
	{
		[(ScrollNode *)nodeTree enableScrolling:enableScrolling];
	}
	
	// And look for children
	for(CCNode *child in nodeTree.children)
	{
		[self enableScrolling:enableScrolling forNodesIntree:child];
	}
}

#pragma mark blurring
- (CCNode *)createBlurredBackground
{
	UIImage *cocosState = [self screenshotWithStartNode:self.scene];
	
	UIImage *currentState = cocosState;
	CGRect fullRect = CGRectMake(0, 0, currentState.size.width, currentState.size.height);
	
	// Apply the iOS 7 blur look
    currentState = [currentState applyBlurWithRadius:BLUR_RADIUS tintColor:BLUR_TINT_COLOR saturationDeltaFactor:BLUR_SATURATION maskImage:nil atFrame:fullRect];
		
	// Create sprite with blurred texture
	CCTexture *stateTexture = [[CCTexture alloc] initWithCGImage:currentState.CGImage contentScale:currentState.scale];
	CCSprite *stateSprite = [CCSprite spriteWithTexture:stateTexture];
	
	return stateSprite;
}

// Returns a cocos only screenshot
- (UIImage *)screenshotWithStartNode:(CCNode*)stNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
	
    CGSize winSize = self.cocosDirector.view.bounds.size;
    CCRenderTexture* renTxture =
    [CCRenderTexture renderTextureWithWidth:winSize.width
									 height:winSize.height];
    [renTxture begin];
    [stNode visit];
    [renTxture end];
	
    return [renTxture getUIImage];
}

#pragma properties for modal director
- (STKScene *)overlayScene
{
	return objc_getAssociatedObject(self, @selector(overlayScene));
}

- (void)setOverlayScene:(STKScene *)overlayScene
{
	objc_setAssociatedObject(self, @selector(overlayScene), overlayScene, OBJC_ASSOCIATION_RETAIN);
}

- (STKSceneController *)overlaySceneController
{
	return objc_getAssociatedObject(self, @selector(overlaySceneController));
}

- (void)setOverlaySceneController:(STKSceneController *)overlaySceneController
{
	objc_setAssociatedObject(self, @selector(overlaySceneController), overlaySceneController, OBJC_ASSOCIATION_RETAIN);
}

- (CCNode *)blurredBackground
{
	return objc_getAssociatedObject(self, @selector(blurredBackground));
}

- (void)setBlurredBackground:(CCNode *)blurredBackground
{
	return objc_setAssociatedObject(self, @selector(blurredBackground), blurredBackground, OBJC_ASSOCIATION_RETAIN);
}

@end
