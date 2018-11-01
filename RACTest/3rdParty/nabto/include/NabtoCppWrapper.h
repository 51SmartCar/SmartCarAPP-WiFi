//
//  NabtoWrapper.h
//  Nabto
//
//  Created by Martin Rodalgaard on 10/22/13.
//  Copyright (c) 2013 Nabto ApS. All rights reserved.
//

#include "nabto_client_api.h"
#import <Foundation/Foundation.h>
@interface NabtoCppWrapper:NSObject {
}

- (id)init;

// NabtoCppWrapper singleton
+ (NabtoCppWrapper *)sharedNabtoCppWrapper;
@end
