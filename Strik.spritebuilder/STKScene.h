//
//  STKScene.h
//  Strik
//
//  Created by Nils on Oct 5, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+Observer.h"

#import "STKAdvertismentDisplayProtocol.h"
#import "Helpers.h"

@interface STKScene : CCNode <STKAdvertisementDisplayProtocol>

@property(weak) id controller;

// The root node, a scene needs a root node and it must be set in the builder
@property (nonatomic, readonly) CCNode *rootGameNode;

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
