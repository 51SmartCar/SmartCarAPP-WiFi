//
//  DeviceInfo.m
//  AoSmart
//
//  Created by rakwireless on 16/1/27.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
    [aCoder encodeObject:self.deviceName      forKey:@"name"];
    [aCoder encodeObject:self.deviceID  forKey:@"id"];
    [aCoder encodeObject:self.deviceIp      forKey:@"ip"];
    [aCoder encodeObject:self.deviceStatus     forKey:@"status"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        //decode properties/values
        self.deviceName       = [aDecoder decodeObjectForKey:@"name"];
        self.deviceID   = [aDecoder decodeObjectForKey:@"id"];
        self.deviceIp       = [aDecoder decodeObjectForKey:@"ip"];
        self.deviceStatus      = [aDecoder decodeObjectForKey:@"status"];
    }
    
    return self;
}

@end
