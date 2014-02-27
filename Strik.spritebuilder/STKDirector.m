//
//  STKDirector.m
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKDirector.h"

#import "STKScene.h"
#import "STKSceneController.h"

#import "STKBootstrapController.h"
#import <CCNode_Private.h>
#import "CSEEmboss.h"
#import "ScrollNode.h"

@interface STKDirector()

@property CCDirector* cocosDirector;

@property STKScene* scene;
@property STKSceneController* sceneController;

@end

@implementation STKDirector

- (void)componentDidInstall
{
	self.cocosDirector = [CCDirector sharedDirector];
}

- (void)presentScene:(STKSceneController *)sceneController
{
	[self presentScene:sceneController withTransition:nil];
}

- (void)presentScene:(STKSceneController *)sceneController withTransition:(CCTransition *)transition
{
	// End current scene
	if(self.scene)
	{
		[self.sceneController sceneWillEnd];
		[self.scene sceneWillEnd];
	}
	
	// Set current scene and controller
	self.scene = sceneController.scene;
	self.sceneController = sceneController;
	
	// Heyo what's happenin'
	NSLog(@"Director: will present %@", self.scene);
	
	// Hook core (faux core component that is never installed)
	self.sceneController.core = self.core;
	[self.sceneController sceneCreated]; // TODO: only call when created, not when popping back
	
	// Will begin (again)!
	[self.sceneController sceneWillBegin];
	[self.scene sceneWillBegin];
	
	// Initial scene?
	if(!self.cocosDirector.runningScene)
	{
		[self.cocosDirector runWithScene:self.scene.cocosScene];
	}
	else
	{
		// We need a transition so this is the default
		if(!transition)
		{
			transition = [CCTransition transitionCrossFadeWithDuration:0.4];
		}
		
		// Go!
		[self.cocosDirector replaceScene:self.scene.cocosScene withTransition:transition];
	}
}

- (id)isCurrentScene:(Class)sceneClass
{
	if([self.scene isKindOfClass:sceneClass])
	{
		return self.scene;
	}
	return nil;
}

// Returns the first scene wich will be displayed by cocos after boot
- (STKScene *)bootstrapScene
{
	// First setup the boot scene
	self.sceneController = [STKBootstrapController new];
	self.scene = self.sceneController.scene;
	
	// Set core, don't want one without one
	self.sceneController.core = self.core;
	
	// Fire events
	[self.sceneController sceneWillBegin];
	[self.scene sceneWillBegin];
	
	// Returning the scene, the startScene event @ AppDelegate will put it on screen
	return self.scene;
}



- (UIView*)view
{
	return self.cocosDirector.view;
}

@end
