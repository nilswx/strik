//
//  STKAvatarPickerController.h
//  Strik
//
//  Created by Matthijn Dijkstra on 02/03/14.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKSceneController.h"
#import "PagedScrollNodeDataSource.h"

@class STKAvatar;

@interface STKAvatarPickerController : STKSceneController <PagedScrollNodeDataSource>

// Returns the current user avatar
@property (readonly) STKAvatar *currentAvatar;

// Returns the page an avatar can be found
- (int)pageForAvatar:(STKAvatar *)avatar;

@end
