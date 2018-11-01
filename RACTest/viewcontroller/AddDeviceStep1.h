//
//  AddDeviceStep1.h
//  AoSmart
//
//  Created by rakwireless on 16/1/22.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceStep1 : UIViewController
{
    UIButton *_AddDeviceStep1Back;
    UILabel  *_AddDeviceStep1Title;
    UILabel  *_AddDeviceStep1Text;
    UILabel  *_AddDeviceStep1Note;
    UILabel  *_AddDeviceStep1NetText;
    UILabel  *_AddDeviceStep1PskText;
    UITextField *_AddDeviceStep1NetField;
    UITextField *_AddDeviceStep1PskField;
    UIButton *_AddDeviceStep1ShowPsk;
    UIButton *_AddDeviceStep1Next;
    UIImageView *_AddDeviceStep1Device1;
    UIImageView *_AddDeviceStep1Device2;
    UIButton *_AddDeviceStep1Device1Btn;
    UIButton *_AddDeviceStep1Device2Btn;
    UILabel *_AddDeviceStep1Device1Text;
    UILabel *_AddDeviceStep1Device2Text;
}

@end
