//
//  BASE64.h
//  EasyConfig
//
//  Created by weimac on 15/1/13.
//  Copyright (c) 2015年 cz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BASE64 : NSObject
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;
@end
