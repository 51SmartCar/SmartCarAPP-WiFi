//
//  MediaData.h
//  Feishen
//
//  Created by rakwireless on 15/12/21.
//  Copyright © 2015年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _deviceIdKey @"DEVICE_ID_KEY"

#define _deviceOnline @"DEVICE_ONLINE"
#define _deviceOffline @"DEVICE_OFFLINE"

@interface DeviceData : NSObject

- (void)saveDeviceById:(NSString *)_deviceId :(NSString *)_deviceName :(NSString *)_deviceIp :(NSString *) _status;
- (NSMutableArray *)getDeviceIds;
- (void)deleteDeviceId :(NSString*)deviceId;
- (NSString *)getDeviceNameById:(NSString *)_deviceId;
- (NSString *)getDeviceIpById:(NSString *)_deviceId;
- (NSString *)getDeviceStatusById:(NSString *)_deviceId;
- (void)updateDeviceNameById:(NSString *)_deviceId :(NSString *)_deviceName;
- (void)updateDeviceIpById:(NSString *)_deviceId :(NSString *)_deviceIp;
- (void)updateDeviceStatusById:(NSString *)_deviceId :(NSString *)_deviceStatus;
- (int)FindId:(NSMutableArray *)DeviceInfos :(NSString *)_deviceId;

@end
