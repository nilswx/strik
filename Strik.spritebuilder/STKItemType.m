//
//  STKItemType.m
//  Strik
//
//  Created by Nils on Dec 3, 2013.
//  Copyright (c) 2013 Indev. All rights reserved.
//

#import "STKItemType.h"

@implementation STKItemType

- (id)initWithID:(int)typeId andCode:(NSString*)code
{
	if(self = [super init])
	{
		self->_typeId = typeId;
		self->_code = code;
		
		// Fetch localization
		self->_name = [NSString stringWithFormat:@"%@_NAME", code];
		self->_description = [NSString stringWithFormat:@"%@_DESC", code];
	}
	
	return self;
}

@end
