//
//  STKHomeScene.m
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKHomeScene.h"
#import "STKAvatarNode.h"

#import "STKPLayer.h"

@interface STKHomeScene()

@property CCButton *username;
@property STKAvatarNode *avatar;

@end

@implementation STKHomeScene

- (void)sceneWillBegin
{
	self.avatar.borderColor = [CCColor whiteColor];
	self.avatar.backgroundColor = [CCColor redColor];
	self.avatar.maskedImage = [CCSprite spriteWithImageNamed:@"Home Scene/valerie.png"];
}

- (void)player:(STKPlayer *)player valueChangedForName:(NSString *)name
{
	self.username.title = name;
}

@end
