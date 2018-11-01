//
//  Rak_Lx52x_Device_Control.h
//  
//
//  Created by 韦伟 on 15/5/20.
//  Copyright (c) 2015年 william.wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lx52x_Device_Info.h"
@interface Rak_Lx52x_Device_Control : NSObject
/**
 * Scan the local device information,Note that this method will block the thread.
 *
 * @param time   Scan times.
 * @return  Lx52x_Device_Info.Device_Number  scan out number,
            Lx52x_Device_Info.Device_ID_Arr  Device id Array,
 *          Lx52x_Device_Info.Device_IP_Arr  Device ip Array.
 */
-(Lx52x_Device_Info*)ScanDeviceWithTime:(NSTimeInterval)time;
@end
