//
//  PagedScrollNodeDatasource.h
//  Strik
//
//  Created by Matthijn Dijkstra on 02/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PagedScrollNodeDataSource <NSObject>

@required

// Return the number of pages
@property (readonly) int numberOfPages;

// The size of a single page
@property (readonly) CGSize pageSize;

// And the node for that page
- (CCNode *)nodeForPage:(int)page;

@end
