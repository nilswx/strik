//
//  STKAdvertismentScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 27/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKAdController.h"

#import "STKAdvertisementNode.h"

// Importing every subclass here, so you won't have to import them everywhere
#import "STKAdvertisementBottomBar.h"

@protocol STKAdvertisementDisplayProtocol <NSObject>

@required

// Return yes if we can display the advertisement of this type (pass the advertisment subclass class) on this scene
- (BOOL)canDisplayAdvertismentOfType:(Class)advertismentType;

// This event will be called when the advertisements needs to be added to the scene
- (void)displayAdvertisment:(STKAdvertisementNode *)advertisement;

// This event will be called when the advertisement needs to be removed from the scene
- (void)removeAdvertisement:(STKAdvertisementNode *)advertisement;

@end
