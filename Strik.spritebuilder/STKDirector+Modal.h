//
//  STKDirector+Modal.h
//  Strik
//
//  Created by Matthijn Dijkstra on 27/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKDirector.h"

@interface STKDirector (Modal)

@property STKScene *overlayScene;
@property STKSceneController *overlaySceneController;
@property CCNode *blurredBackground;

- (void)overlayScene:(STKSceneController *)sceneController;

@end
