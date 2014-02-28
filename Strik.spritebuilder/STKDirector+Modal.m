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
	
	
	// Make sure the events are fired
	[self.overlaySceneController sceneWillBegin];
	[self.overlayScene sceneWillBegin];
	
	// Disable scrolling in the current scene (else the scroll views overlay the overlay)
	[self enableScrolling:NO forNodesIntree:self.scene];
	
	// Create the blurred background which will capture touch
	// Todo: blur it

	// Create a full screen blurred node
	self.blurredBackground = [CCNode node];
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
	[self.blurredBackground addChild:self.overlayScene];
}

#pragma mark buttons
- (void)tappedBackground:(CCButton *)button
{
	// Make sure the events are fired
	[self.overlaySceneController sceneWillEnd];
	[self.overlayScene sceneWillEnd];
	
	// Remove the blurred background and overlay
	[self.blurredBackground removeFromParent];
	[self.overlayScene removeFromParent];
	
	self.overlayScene = nil;
	self.overlaySceneController = nil;
	self.blurredBackground = nil;
	
	// Re-enable scrolling and touches
	[self enableScrolling:YES forNodesIntree:self.scene];
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
