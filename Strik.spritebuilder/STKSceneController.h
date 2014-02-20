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

- (void)sceneCreated;
- (void)sceneWillBegin;
- (void)sceneWillEnd;

- (void)enter;
- (void)enterTransitionDidFinish;
- (void)exit;
- (void)exitTransitionDidStart;

+ (Class)sceneClass;

@end
