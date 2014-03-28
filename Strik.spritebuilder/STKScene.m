//
//  STKScene.m
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKScene.h"
#import "STKAdController.h"

typedef NS_ENUM(NSInteger, NodeOrder)
{
	NodeOrderGameRoot,
	NodeOrderAdvertisement
};

@interface STKScene()

// The root node, a scene needs a root node and it must be set in the builder
@property (nonatomic) CCNode *rootGameNode;

@end

@implementation STKScene

- (NSString*)description
{
	return NSStringFromClass([self class]);
}

+ (Class)controllerClass
{
	NSString* className = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Scene" withString:@"Controller"];
	return NSClassFromString(className);
}

+ (NSString *)ccbFileName
{
	return [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"STK" withString:@""];
}

- (void)dealloc
{
	NSLog(@"Scene: deallocating %@", self);
	
    [self removeAsObserverForAllModels];
	
	NSLog(@"Dealloced scene: %@", self);
}

#pragma mark Overrides for Cocos events
- (void)onEnter
{
	[self enter];
	[self.controller enter];
	[super onEnter];
}

- (void)onEnterTransitionDidFinish
{
	[self enterTransitionDidFinish];
	[self.controller enterTransitionDidFinish];
	[super onEnterTransitionDidFinish];
}

- (void)onExit
{
	[self exit];
	[self.controller exit];
	[super onExit];
}

- (void)onExitTransitionDidStart
{
	[self exitTransitionDidStart];
	[self.controller exitTransitionDidStart];
	[super onExitTransitionDidStart];
}

#pragma mark events
- (void)sceneWillBegin
{
	// Override me
}

- (void)sceneWillEnd
{
	// Override me
}

- (void)enter
{
	// Override me
}

- (void)enterTransitionDidFinish
{
	// Override me
}

- (void)exit
{
	// Override me
}

- (void)exitTransitionDidStart
{
	// Override me
}

- (void)sceneLoaded
{
	// Override me
}

#pragma mark advertisment display protocol
- (BOOL)canDisplayAdvertismentOfType:(Class)advertismentType
{
	// Defaulting to no here
	return NO;
}

// This event will be called when the advertisements needs to be added to the scene
- (void)displayAdvertisment:(STKAdvertisementNode *)advertisement
{
	if([advertisement isKindOfClass:[STKAdvertisementBottomBar class]])
	{
		[self resizeForBottomBarAdvertisement:(STKAdvertisementBottomBar *)advertisement];
	}
	
	// Zet correct zOrder
	advertisement.zOrder = NodeOrderAdvertisement;
	
	// And ad ad
	[self addChild:advertisement];
}

// This event will be called when the advertisement needs to be removed from the scene
- (void)removeAdvertisement:(STKAdvertisementNode *)advertisement updateLayout:(BOOL)updateLayout
{
	if([advertisement isKindOfClass:[STKAdvertisementBottomBar class]])
	{
		[self removeAdvertismentBottomBar:advertisement updateLayout:updateLayout];
	}
}

- (void)resizeForBottomBarAdvertisement:(STKAdvertisementBottomBar *)advertisement
{
	// Since the advertisement is a bottom bar, it will be placed at the bottom. Shrinking the room for the game
	CGSize advertisementSize = advertisement.contentSizeInPoints;
	
	self.rootGameNode.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitPoints);
	self.rootGameNode.positionType = CCPositionTypePoints;
	
	self.rootGameNode.position = CGPointMake(0, advertisementSize.height);
	self.rootGameNode.contentSize = CGSizeMake(1, self.contentSizeInPoints.height - advertisementSize.height);
}

- (void)removeAdvertismentBottomBar:(STKAdvertisementNode *)advertisement updateLayout:(BOOL)updateLayout
{
	// Remove the ad
	[advertisement removeFromParent];
	
	// We don't want this always, e.g when showing an overlay or transitioning, this looks jumpy then
	if(updateLayout)
	{
		// And resize the root game node
		self.rootGameNode.contentSizeType = CCSizeTypeNormalized;
		self.rootGameNode.contentSize = CGSizeMake(1, 1);
		self.rootGameNode.position = CGPointMake(0, 0);
	}
}

- (CCNode *)rootGameNode
{
	if(!_rootGameNode)
	{
		NSAssert(NO, @"The scene %@ does not have a game root node set in the builder which is mandatory.", NSStringFromClass([self class]));
	}
		
	_rootGameNode.zOrder = NodeOrderGameRoot;
	
	return _rootGameNode;
}

@end
