//
//  STKScene.h
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Observer.h"

@interface STKScene : CCNode

@property(weak) id controller;

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
