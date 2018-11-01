//
//  DeviceSettings.h
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceSettings : UIViewController
{
    UILabel *_DeviceSettingsVersionTitle;
    UILabel *_DeviceSettingsAppVersionText;
    UILabel *_DeviceSettingsFwVersionText;
    UILabel *_DeviceSettingsPskTitle;
    UIButton *_DeviceSettingsBack;
    UIImageView *_DeviceSettingsImage;
    UITextField *_DeviceSettingsPskField;
    UIButton *_DeviceSettingsShowPsk;
    UITextField *_DeviceSettingsNewPskField;
    UIButton *_DeviceSettingsShowNewPsk;
    UIButton *_DeviceSettingsBtn;
    
    UILabel *_DeviceSettingsParametersTitle;
    UILabel *_DeviceSettingsFPSText;
    UITextField *_DeviceSettingsFPSField;
    UILabel *_DeviceSettingsQualityText;
    UITextField *_DeviceSettingsQualityField;
    UILabel *_DeviceSettingsGOPText;
    UITextField *_DeviceSettingsGOPField;
    UIButton *_DeviceSettingsParameterBtn;
}
@end
