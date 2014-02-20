//
//  STKOutgoingMessage.m
//  NetTest
//
//  Created by Nils on Jul 30, 2013.
//  Copyright (c) 2013 Nils. All rights reserved.
//

#include <stdlib.h>

#import "STKOutgoingMessage.h"

@interface STKOutgoingMessage()

@property (nonatomic,strong) NSMutableData* buf;

@end

@implementation STKOutgoingMessage

- (id)initWithOp:(STKOutgoingOpcode)op
{
    if(self = [super init])
    {
        self.op = op;
        self.buf = [NSMutableData data];
		[self appendShort:0]; // placeholder
        [self appendByte:op];
    }
    
    return self;
}

- (void)appendBool:(BOOL)b
{
    [self appendByte:(b ? 1 : 0)];
}

- (void)appendByte:(int8_t)i
{
    [self.buf appendBytes:&i length:sizeof(i)];
}

- (void)appendShort:(int16_t)i
{
    int16_t si = CFSwapInt16HostToBig(i);
    [self.buf appendBytes:&si length:sizeof(i)];
}

- (void)appendInt:(int32_t)i
{
    int32_t si = CFSwapInt32HostToBig(i);
    [self.buf appendBytes:&si length:sizeof(i)];
}

- (void)appendLong:(int64_t)i
{
    int64_t si = CFSwapInt64HostToBig(i);
    [self.buf appendBytes:&si length:sizeof(i)];
}

- (void)appendStr:(NSString*)str
{
    NSData* bytes = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self appendShort:bytes.length];
    [self.buf appendData:bytes];
}

- (NSMutableData*)finalizeBuffer
{
	// Update length header
	int16_t lens = CFSwapInt16HostToBig(self.buf.length - sizeof(int16_t));
	[self.buf replaceBytesInRange:NSMakeRange(0, 2) withBytes:&lens];
	
    return self.buf;
}

+ (STKOutgoingMessage*)withOp:(STKOutgoingOpcode)op
{
    return [[STKOutgoingMessage alloc] initWithOp:op];
}
@end
