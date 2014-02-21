//
//  STKLevelNode.h
//  Strik
//
//  Created by Matthijn Dijkstra on 21/02/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSceneController.h"

@interface STKLevelNode : CCNode

// The background color of the circle
@property (nonatomic) CCColor *backgroundColor;

// The color of the label
@property (nonatomic) CCColor *fontColor;

// And the contents of the label
@property (nonatomic) NSString *text;

@end
