//
//  STKDirector.h
//  Strik
//
//  Created by Nils on Oct 6, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKCore.h"

@class STKScene, STKSceneController;

@interface STKDirector : STKCoreComponent

- (void)presentScene:(STKSceneController *)sceneController;
- (void)presentScene:(STKSceneController *)sceneController withTransition:(CCTransition *)transition;

- (id)isCurrentScene:(Class)sceneClass;

- (STKScene *)bootstrapScene;

@end
