//
//  STKIncomingMessage.h
//  NetTest
//
//  Created by Nils on Jul 30, 2013.
//  Copyright (c) 2013 Nils. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STKIncomingOpcode.h"

@interface STKIncomingMessage : NSObject

@property(nonatomic,readonly) STKIncomingOpcode op;
@property(readonly,getter=size) int size;

- (id)initWithData:(NSData*)data;

- (bool)readBool;
- (int8_t)readByte;
- (int16_t)readShort;
- (int32_t)readInt;
- (int64_t)readLong;
- (NSString*)readStr;

@end

#define HI_NIBBLE(b) (((b) >> 4) & 0x0F)
#define LO_NIBBLE(b) ((b) & 0x0F)