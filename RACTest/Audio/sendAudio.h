//
//  sendAudio.h
//  audiotest
//
//  Created by 韦伟 on 15/7/31.
//  Copyright (c) 2015年 william.wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sendAudio : NSObject
+(void)sendWithIp:(NSString*)IP port:(int)PORT data:(NSData*)PCMUDATA;
@end
