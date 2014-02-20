//
//  STKItemType.h
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKModel.h"

@interface STKItemType : STKModel

@property(readonly) int typeId;
@property(readonly) NSString* code;

@property(readonly) NSString* name;
@property(readonly) NSString* description;

- (id)initWithID:(int)typeId andCode:(NSString*)code;

// in item node: iconAtlas = [SKTextureAtlas atlasNamed:@"items"];

@end
