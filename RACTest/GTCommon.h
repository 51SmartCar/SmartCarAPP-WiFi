//
//  GTCommon.h
//  RACTest
//
//  Created by TianYuan on 2018/10/30.
//  Copyright © 2018年 SmartCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTCommon : NSObject

- (NSString *)hexStringFromData:(NSData *)data;
- (NSNumber *)numberHexString:(NSString *)aHexString;
- (NSData *)dataFromHexString:(NSString *)hexString;
- (NSData *)dataWithReverse:(NSData *)srcData;
- (NSData *)byteFromUInt8:(uint8_t)val;
- (NSMutableData *)stringToHex:(NSString*)string;
- (NSString *)getParameter:(NSString *)key;
- (void)saveParameter:(NSString *)devices :(NSString *)key;
- (void)playSound:(NSString *)sourcePath;
- (BOOL)openVoiceIndicator;
-(NSString*)parseJsonString:(NSString *)srcStr;
@end
