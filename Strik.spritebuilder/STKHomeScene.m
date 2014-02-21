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

- (void)player:(STKPlayer *)player valueChangedForName:(NSString *)name
{
	self.username.title = name;
}

@end
