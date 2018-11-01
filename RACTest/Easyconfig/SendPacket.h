//
//  SendPacket.h
//  EasyConfig
//
//  Created by wei-mac on 14-4-9.
//  Copyright (c) 2014年 cz. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "aes.h"

@interface SendPacket : NSObject
@property (nonatomic)Byte *pskssid;
@property (nonatomic)int pskssid_len;
-(id)initWithPSK:(NSString *)pskStr andssid:(NSString*)ssidStr;

@end
