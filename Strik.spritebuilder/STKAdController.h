//
//  STKAdController.h
//  Strik
//
//  Created by Matthijn Dijkstra on 27/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKController.h"

@class STKScene;
@protocol STKAdvertisementDisplayProtocol;

@interface STKAdController : STKController

// Adds advertisments to scene
- (void)adAdvertismentsToScene:(STKScene<STKAdvertisementDisplayProtocol>*)scene;

// Removes advertisments from scene when updateLayout is yes the layout will be updated to fill the empty space
- (void)removeAdvertismentsFromScene:(STKScene<STKAdvertisementDisplayProtocol>*)scene updateLayout:(BOOL)updateLayout;

@end
