//
//  STKAdController.m
//  Strik
//
//  Created by Matthijn Dijkstra on 27/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKAdController.h"
#import "STKAdvertisementNode.h"

#import "STKAdvertismentDisplayProtocol.h"
#import "STKScene.h"

@implementation STKAdController

- (void)adAdvertismentsToScene:(STKScene<STKAdvertisementDisplayProtocol>*)scene
{
	// Itterarate over each type which can be added to the scene
	for(Class advertismentClass in [STKAdController sceneAdvertismentTypes])
	{
		// Determine if it can be displayed on the current scene
		if([scene canDisplayAdvertismentOfType:advertismentClass])
		{
			// Create it
			STKAdvertisementNode *advertisment = [[advertismentClass alloc] init];
			
			// And let the scene add it
			[scene displayAdvertisment:advertisment];
		}
	}
}

- (void)removeAdvertismentsFromScene:(STKScene<STKAdvertisementDisplayProtocol>*)scene
{
	// Get
	NSArray *children = scene.children;
	
	// Get all root nodes in the scene
	for(CCNode *child in children)
	{
		// If it is an ad
		if([child isKindOfClass:[STKAdvertisementNode class]])
		{
			// Let the scene remove it
			[scene removeAdvertisement:(STKAdvertisementNode *)child];
		}
	}
}

// Add the classes of scene advertisments which could be embedded in a scene (not an overlay) here (e.g the bottom bar advertisment)
+ (NSArray *)sceneAdvertismentTypes
{
	static NSArray *sceneAdvertisments;
	if(!sceneAdvertisments)
	{
		sceneAdvertisments = @[[STKAdvertisementBottomBar class]];
	}
	
	return sceneAdvertisments;
}

@end
