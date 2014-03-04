//
//  STKButtonWithData.h
//  Strik
//
//  Created by Matthijn Dijkstra on 04/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "CCButton.h"

@interface STKButton : CCButton

// This button has a data property so when the button event is fired the data can be read from it
@property id data;

@end
