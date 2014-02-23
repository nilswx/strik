//
//  STKTableNodeDelegate.h
//  Strik
//
//  Created by Matthijn Dijkstra on 13/11/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GridNodeDelegate <NSObject>

@optional

- (void)tappedNodeAtColumn:(int)column andRow:(int)row;

@end
