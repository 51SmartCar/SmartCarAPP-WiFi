//
//  DeviceInfo.h
//  AoSmart
//
//  Created by rakwireless on 16/1/27.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject <NSCoding>

@property (nonatomic, retain) NSString *deviceName;
@property (nonatomic, retain) NSString *deviceID;
@property (nonatomic, retain) NSString *deviceIp;
@property (nonatomic, retain) NSString *deviceStatus;

@end