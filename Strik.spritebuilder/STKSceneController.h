//
//  STKSceneController.h
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKController.h"

@interface STKSceneController : STKController

@property (nonatomic, readonly) id scene;

- (id)initWithCore:(STKCore *)core;

- (void)sceneCreated;
- (void)sceneWillBegin;
- (void)sceneWillEnd;

- (void)enter;
- (void)enterTransitionDidFinish;
- (void)exit;
- (void)exitTransitionDidStart;

- (void)transitionTo:(Class)sceneClass direction:(CCTransitionDirection)direction;

+ (Class)sceneClass;

@end
