//
//  NabtoWrapper.mm
//  Nabto
//
//  Created by Martin Rodalgaard on 10/22/13.
//  Copyright (c) 2013 Nabto ApS. All rights reserved.
//

#import "NabtoCppWrapper.h"
@implementation NabtoCppWrapper

#pragma mark -
#pragma mark Singleton code
static NabtoCppWrapper *sharedNabtoCppWrapper;

// Initialize the singleton instance if needed and return
+ (NabtoCppWrapper *)sharedNabtoCppWrapper {
	@synchronized(self)	{
		if (!sharedNabtoCppWrapper) {
			sharedNabtoCppWrapper = [[NabtoCppWrapper alloc] init];
		}
		return sharedNabtoCppWrapper;
	}
	return nil;
}

+ (id)alloc {
    return [super alloc];
}

+ (id)copy {
	@synchronized(self)	{
		NSAssert(sharedNabtoCppWrapper == nil, @"Attempted to copy the singleton.");
		return sharedNabtoCppWrapper;
	}
	return nil;
}

- (id)init {
    self = [super init];
    return self;
}

@end
