//
//  STKSceneController.m
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKSceneController.h"

#import "STKScene.h"
#import "STKDirector.h"

@interface STKSceneController()

@property (nonatomic, strong) id scene;

@end

@implementation STKSceneController

- (id)init
{
	if(self = [super init])
	{
		// Create scene and run post-creation logic
		Class sceneClass = [[self class] sceneClass];
		
		// Read the nodegraph from a file, (STKScene extends CCNode, the director will wrap it in a CCScene when it needs to be displayed)		
		STKScene *scene = (STKScene *)[CCBReader load:[sceneClass ccbFileName] owner:self];

		// Tell the scene it is loaded (so we can do some extra things when needed)
		[scene sceneLoaded];
		
		// Set the controller and scene on each other
		scene.controller = self;
		self.scene = scene;
	}
	
	return self;
}

- (void)sceneCreated
{
	// Override me
}

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

- (void)transitionTo:(Class)sceneClass direction:(CCTransitionDirection)direction
{
	// Create instance of controller
	STKSceneController* controller = [[sceneClass controllerClass] new];
	
	// Transition in the given direction
	STKDirector* director = self.core[@"director"];
	[director pushScene:controller withTransition:[CCTransition transitionPushWithDirection:direction duration:0.25]];
}

+ (Class)sceneClass
{
	NSString* className = [NSStringFromClass(self) stringByReplacingOccurrencesOfString:@"Controller" withString:@"Scene"];
	return NSClassFromString(className);
}

@end
