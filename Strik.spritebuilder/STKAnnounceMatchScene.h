//
//  STKAnnounceMatchScene.h
//  Strik
//
//  Created by Matthijn Dijkstra on 05/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKScene.h"

@class STKAnnouncePlayerCard;

@interface STKAnnounceMatchScene : STKScene

// Player one nodes
@property (readonly) STKAnnouncePlayerCard *playerOneCard;
@property (readonly) CCLabelTTF *playerOneCountryLabel;
@property (readonly) CCNode *playerOneFlagContainer;

// Player two nodes
@property (readonly) STKAnnouncePlayerCard *playerTwoCard;
@property (readonly) CCLabelTTF *playerTwoCountryLabel;
@property (readonly) CCNode *playerTwoFlagContainer;

@end
