//
//  DevicePlay.h
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTRocker.h"
#import "GTSlider.h"
#import "GTPathPlanning.h"

@interface DevicePlayViewController : UIViewController
{
    
    UIView *_DeviceConnectingView;
    UIButton *_DeviceConnectingBack;
    UIImageView *_DeviceConnectingImage;
    UILabel *_DeviceConnectingText;
    
    UILabel *l_recodevideo; //视频以保存到相册
    
}

@property (weak, nonatomic) IBOutlet GTRocker *rocker;
@property (weak, nonatomic) IBOutlet UILabel *rockerLabel;

@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet GTSlider *slider;
//@property (weak, nonatomic) IBOutlet UITextField *serverIP;

//@property (weak, nonatomic) IBOutlet UITextField *serverPort;
//@property (weak, nonatomic) IBOutlet UITextField *bluetoothName;

@property (weak, nonatomic) IBOutlet UIButton *connectStatusBtn;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *buzzerBtton;
@property (weak, nonatomic) IBOutlet UIButton *lightButton;
@property (weak, nonatomic) IBOutlet UIButton *findCarBtn;
@property (weak, nonatomic) IBOutlet UIButton *engineBtn;
@property (weak, nonatomic) IBOutlet UIButton *gravityBtn;

@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UIView *pathPlanningView;

@property (weak, nonatomic) IBOutlet UIView *toucheView;
@property (weak, nonatomic) IBOutlet GTPathPlanning *pathRouteView;

@property (weak, nonatomic) IBOutlet UISwitch *routeSwitchBtn;

typedef NS_ENUM(NSInteger,GTVehicleStatus)
{
    GTVehicleStatus_Buzzer = 0,    /*蜂鸣器 */
    GTSliderStyle_Light = 0,        /*车灯 */
    GTSliderStyle_Engine = 0        /*引擎 */
    
};

+(void)back;
@end
