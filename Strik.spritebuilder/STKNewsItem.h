//
//  STKNewsItem.h
//  Strik
//
//  Created by Nils Wiersema on Mar 27, 2014.
//  Copyright (c) 2014 Strik. All rights reserved.
//

#import "STKModel.h"

@interface STKNewsItem : STKModel

@property int id;
@property NSString* headline;
@property NSString* body;
@property NSString* imageUrl;
@property NSDate* timestamp;

@end
