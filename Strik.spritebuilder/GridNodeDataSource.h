//
//  STKTableDataSource.h
//  Strik
//
//  Created by Matthijn Dijkstra on 13/11/13.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKNode;

@protocol GridNodeDataSource <NSObject>

@required

@property (nonatomic, readonly) CGSize cellSize;

@property (nonatomic, readonly) int columnCount;
@property (nonatomic, readonly) int rowCount;

- (CCNode *)nodeForColumn:(int)column andRow:(int)row;

@end
