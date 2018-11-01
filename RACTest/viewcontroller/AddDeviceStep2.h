//
//  AddDeviceStep2.h
//  AoSmart
//
//  Created by rakwireless on 16/1/23.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceStep2 : UIViewController
{
    UIButton *_AddDeviceStep2Back;
    UILabel  *_AddDeviceStep2Title;
    UILabel  *_AddDeviceStep2Note;
    UILabel  *_AddDeviceStep2Text;
    UIButton *_AddDeviceStep2Next;
    UIImageView *_AddDeviceStep2Device;
}
@property (nonatomic) int deviceFlag;
@end
