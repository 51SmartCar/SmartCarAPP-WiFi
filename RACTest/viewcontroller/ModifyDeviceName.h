//
//  ModifyDeviceName.h
//  AoSmart
//
//  Created by rakwireless on 16/1/23.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyDeviceName : UIViewController
{
    UIButton *_modifyDeviceNameBack;
    UILabel  *_modifyDeviceNameTitle;
    UIImageView *_modifyDeviceNameImage;
    UITextField *_modifyDeviceNameField;
    UITextField *_modifyDeviceIDField;
    UIButton *_modifyDeviceNameBtn;
    UIButton *_deleteDeviceNameBtn;
    UIButton *_copyDeviceIDBtn;
}
@property (nonatomic) NSString* deviceId;

@end
