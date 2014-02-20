//
//  STKScene.h
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Observer.h"

@class STKSceneController;
@class SKTextureAtlas;

@interface STKScene : CCNode // It's the root node

@property (nonatomic, weak) id controller;
@property (nonatomic, readonly) CCScene *cocosScene;

- (void)sceneWillBegin;
- (void)sceneWillEnd;
- (void)sceneLoaded;

- (void)enter;
- (void)enterTransitionDidFinish;
- (void)exit;
- (void)exitTransitionDidStart;

+ (Class)controllerClass;

+ (NSString *)ccbFileName;

@end
