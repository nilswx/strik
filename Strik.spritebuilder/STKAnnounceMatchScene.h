//
//  STKAnnounceMatchScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class STKVSCard;

@interface STKAnnounceMatchScene : STKScene

// Player one nodes
@property (readonly) STKVSCard *playerOneCard;
@property (readonly) CCLabelTTF *playerOneCountryLabel;
@property (readonly) CCNode *playerOneFlagContainer;

// Player two nodes
@property (readonly) STKVSCard *playerTwoCard;
@property (readonly) CCLabelTTF *playerTwoCountryLabel;
@property (readonly) CCNode *playerTwoFlagContainer;

@end
