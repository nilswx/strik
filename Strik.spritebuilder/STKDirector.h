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

- (void)pushScene:(STKSceneController *)sceneController;
- (void)pushScene:(STKSceneController *)sceneController withTransition:(CCTransition *)transition;

- (void)replaceScene:(STKSceneController *)sceneController;
- (void)replaceScene:(STKSceneController *)sceneController withTransition:(CCTransition *)transition;

- (void)popScene;
- (void)popSceneWithTransition:(CCTransition *)transition;

- (void)popToRootScene;

- (id)isCurrentScene:(Class)sceneClass;

- (STKScene *)bootstrapScene;

@end
