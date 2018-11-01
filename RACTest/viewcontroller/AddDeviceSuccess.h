//
//  AddDeviceSuccess.h
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceSuccess : UIViewController
{
    UIButton *_AddDeviceSuccessBack;
    UILabel  *_AddDeviceSuccessTitle;
    UIImageView *_AddDeviceSuccessImage;
    UITextField *_AddDeviceSuccessField;
    UIButton *_AddDeviceSuccessBtn;
}
@property (nonatomic) NSString *deviceIP;
@property (nonatomic) NSString *deviceID;
@end
