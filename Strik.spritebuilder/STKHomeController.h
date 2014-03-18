//
//  STKHomeController.h
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSceneController.h"
#import "GridNodeDataSource.h"

@interface STKHomeController : STKSceneController <GridNodeDataSource>

// Needed for showing settings when going back to this scene from the new game scene via the no friends button
@property BOOL shouldDisplaySettingsAfterEnterTransition;

@end
