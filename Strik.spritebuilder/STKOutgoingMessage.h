//
//  STKOutgoingMessage.h
//  NetTest
//
//  Created by Nils on Jul 30, 2013.
//  Copyright (c) 2013 Nils. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKOutgoingOpcode.h"

@interface STKOutgoingMessage : NSObject

@property(nonatomic) STKOutgoingOpcode op;

- (id)initWithOp:(STKOutgoingOpcode)op;

- (void)appendBool:(BOOL)b;
- (void)appendByte:(int8_t)i;
- (void)appendShort:(int16_t)i;
- (void)appendInt:(int32_t)i;
- (void)appendLong:(int64_t)i;
- (void)appendStr:(NSString*)str;
- (NSMutableData*)finalizeBuffer;

+ (STKOutgoingMessage*)withOp:(STKOutgoingOpcode)op;

@end

#define PACK(a,b) (a << 4 | b)