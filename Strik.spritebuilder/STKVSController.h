//
//  STKVSSceneController.h
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSceneController.h"

@class STKMatch;

@interface STKVSController : STKSceneController

// Setup the match for this VS Scene
- (void)setupMatch:(STKMatch *)match;

@end
