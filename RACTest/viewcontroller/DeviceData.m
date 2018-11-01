//
//  MediaData.m
//  Feishen
//
//  Created by rakwireless on 15/12/21.
//  Copyright © 2015年 rak. All rights reserved.
//

#import "DeviceData.h"
#import "DeviceInfo.h"

@implementation DeviceData

//Save Device Information
- (void)saveDeviceById:(NSString *)_deviceId :(NSString *)_deviceName :(NSString *)_deviceIp :(NSString *) _status{
    DeviceInfo *_deviceInfo=[[DeviceInfo alloc]init];
    _deviceInfo.deviceID=_deviceId;
    _deviceInfo.deviceName=_deviceName;
    _deviceInfo.deviceIp=@"127.0.0.1";
    _deviceInfo.deviceStatus=_status;
    
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index==-1) {
        NSMutableArray *InfoArray = [[NSMutableArray alloc] init];
        [InfoArray addObjectsFromArray:_oldDeviceInfo];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_deviceInfo];
        [InfoArray addObject:data];
        [self Save_Paths:InfoArray :_deviceIdKey];
    }
    else{
        NSMutableArray *InfoArray = [[NSMutableArray alloc] init];
        [InfoArray addObjectsFromArray:_oldDeviceInfo];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_deviceInfo];
        [InfoArray replaceObjectAtIndex:index withObject:data];
        [self Save_Paths:InfoArray :_deviceIdKey];
    }
    _deviceInfo=nil;
}

//Get Device IDs
- (NSMutableArray *)getDeviceIds{
    NSMutableArray *DeviceInfoArray = [[NSMutableArray alloc] init];
    NSMutableArray *_oldDeviceData=[self Get_Paths:_deviceIdKey];
    [_oldDeviceData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        DeviceInfo *device = [NSKeyedUnarchiver unarchiveObjectWithData:_oldDeviceData[idx]];
        [DeviceInfoArray addObject:device];
    }];
    return DeviceInfoArray;
}

//Delete Device ID
- (void)deleteDeviceId :(NSString*)_deviceId{
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index!=-1) {
        NSMutableArray *InfoArray = [[NSMutableArray alloc] init];
        [InfoArray addObjectsFromArray:_oldDeviceInfo];
        [InfoArray removeObjectAtIndex:index];
        [self Save_Paths:InfoArray :_deviceIdKey];
    }
}

//Get Device Name
- (NSString *)getDeviceNameById:(NSString *)_deviceId{
    NSString *name=nil;
    NSRange range=[_deviceId rangeOfString:@"."];
    if (range.location != NSNotFound) {
        int i=(int)range.location;
        NSString *name1=[_deviceId substringFromIndex:i+1];
        NSRange range1=[name1 rangeOfString:@"."];
        if (range1.location != NSNotFound){
            int j=(int)range1.location;
            name=[name1 substringToIndex:j];
        }
        else{
            name=_deviceId;
        }
    }else{
        name=_deviceId;
    }
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index!=-1) {
        DeviceInfo *_deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:_oldDeviceInfo[index]];
        name=_deviceInfo.deviceName;
    }
    return name;
}

//Get Device Ip
- (NSString *)getDeviceIpById:(NSString *)_deviceId{
    NSString *ip=@"127.0.0.1";
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index!=-1) {
        DeviceInfo *_deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:_oldDeviceInfo[index]];
        ip=_deviceInfo.deviceIp;
    }
    return ip;
}

//Get Device Status
- (NSString *)getDeviceStatusById:(NSString *)_deviceId{
    NSString *status=_deviceOffline;
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index!=-1) {
        DeviceInfo *_deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:_oldDeviceInfo[index]];
        status=_deviceInfo.deviceStatus;
    }
    return status;
}

//Update Device Name
- (void)updateDeviceNameById:(NSString *)_deviceId :(NSString *)_deviceName{
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index!=-1) {
        DeviceInfo *_deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:_oldDeviceInfo[index]];
        _deviceInfo.deviceName=_deviceName;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_deviceInfo];
        NSMutableArray *InfoArray = [[NSMutableArray alloc] init];
        [InfoArray addObjectsFromArray:_oldDeviceInfo];
        [InfoArray replaceObjectAtIndex:index withObject:data];
        [self Save_Paths:InfoArray :_deviceIdKey];
    }
}

//Update Device IP
- (void)updateDeviceIpById:(NSString *)_deviceId :(NSString *)_deviceIp{
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index!=-1) {
        DeviceInfo *_deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:_oldDeviceInfo[index]];
        _deviceInfo.deviceIp=_deviceIp;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_deviceInfo];
        NSMutableArray *InfoArray = [[NSMutableArray alloc] init];
        [InfoArray addObjectsFromArray:_oldDeviceInfo];
        [InfoArray replaceObjectAtIndex:index withObject:data];
        [self Save_Paths:InfoArray :_deviceIdKey];
    }
}

//Update Device Status
- (void)updateDeviceStatusById:(NSString *)_deviceId :(NSString *)_deviceStatus{
    NSMutableArray *_oldDeviceInfo=[self Get_Paths:_deviceIdKey];
    int index=[self FindId:_oldDeviceInfo :_deviceId];
    if (index!=-1) {
        DeviceInfo *_deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:_oldDeviceInfo[index]];
        _deviceInfo.deviceStatus=_deviceStatus;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_deviceInfo];
        NSMutableArray *InfoArray = [[NSMutableArray alloc] init];
        [InfoArray addObjectsFromArray:_oldDeviceInfo];
        [InfoArray replaceObjectAtIndex:index withObject:data];
        [self Save_Paths:InfoArray :_deviceIdKey];
    }
}

//Find Device Id
- (int)FindId:(NSMutableArray *)DeviceInfos :(NSString *)_deviceId{
    int index=-1;
    if (DeviceInfos!=nil) {
        for (int i=0; i<[DeviceInfos count]; i++) {
            DeviceInfo *_deviceInfo = [NSKeyedUnarchiver unarchiveObjectWithData:DeviceInfos[i]];
            NSString *Id=_deviceInfo.deviceID;
            if([Id compare:_deviceId]==NSOrderedSame ){
                index=i;
                break;
            }
        }
    }
    return index;
}

//Save Parameter
- (void)Save_Paths:(NSMutableArray *)devices :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:devices forKey:key];
    [defaults synchronize];
}
//Get Parameter
- (NSMutableArray *)Get_Paths:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *value=[defaults objectForKey:key];
    return value;
}

@end
