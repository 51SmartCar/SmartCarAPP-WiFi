//
//  AddDeviceStep3.m
//  AoSmart
//
//  Created by rakwireless on 16/1/23.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep3.h"
#import "CommanParameter.h"
#import "ProgressView.h"
#import "AddDeviceFailed.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "AddDeviceSuccess.h"
#import "DeviceInfo.h"
#import "Rak_Lx52x_Device_Control.h"
int amount_flg = 0;
#define over_time 60 //超时时间
BOOL start_flg = NO;

NSTimer* RunProgress = nil;
ProgressView *progress = nil;
CGFloat progressTime=600.0;//60s
UINavigationController *_selfAddDeviceStep3;
Rak_Lx52x_Device_Control *_device_Scan_Find;
@interface AddDeviceStep3 ()
{
    int config_way;//0:easy  1:ap
    bool _isExit;
}
@end

@implementation AddDeviceStep3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selfAddDeviceStep3=self.navigationController;
    
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceStep3Back=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep3Back.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep3Back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep3Back addTarget:nil action:@selector(_AddDeviceStep3BackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep3Back];
    
    progress = [[ProgressView alloc]initWithFrame:CGRectMake(0, 0, viewW*0.8, viewW*0.8)];
    progress.center=self.view.center;
    progress.arcFinishColor = [UIColor  colorWithRed:30/255.0 green:144/255.0 blue:1.0 alpha:1.0];
    progress.arcUnfinishColor = [UIColor  colorWithRed:30/255.0 green:144/255.0 blue:1.0 alpha:1.0];
    progress.arcBackColor = [UIColor grayColor];
    progress.percent = 0;
    [self.view addSubview:progress];
    RunProgress = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(RunProgressTimer) userInfo:nil repeats:YES];
    
    _AddDeviceStep3Text = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, progress.frame.origin.y-diff_top-title_size, viewW-diff_x*2, title_size)];
    _AddDeviceStep3Text.text = NSLocalizedString(@"add_device_step3_text", nil);
    _AddDeviceStep3Text.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep3Text.backgroundColor = [UIColor clearColor];
    _AddDeviceStep3Text.textColor = [UIColor grayColor];
    _AddDeviceStep3Text.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep3Text.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep3Text.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep3Text];
    _isExit=NO;
    start_flg = NO;
    __EasyConfig = nil;
    if ([[self Get_Parameter:@"condifure_way"] compare:@"easy"] == NSOrderedSame) {
        //    [mac removeAllObjects];
        //    [ip removeAllObjects];
        config_way=0;
        NSString *pskStr=[self Get_Parameter:@"config_psk"];
        __EasyConfig = [[EasyConfig alloc] init:self];
        [__EasyConfig SendDataWithPsk:pskStr andSSID:nil];//IF WIFI SSID NO HIDE
        start_flg = YES;
        _AddDeviceStep3Text.text = NSLocalizedString(@"add_device_step3_text", nil);
    }
    else{
        _AddDeviceStep3Text.text = NSLocalizedString(@"add_device_step3_title_ap", nil);
        config_way=1;
        _device_Scan_Find = [[Rak_Lx52x_Device_Control alloc] init];
        [self scanDevice];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

//Get Parameter
- (NSString *)Get_Parameter:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    return value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)RunProgressTimer{
    if (progress.percent>=1) {
        if (RunProgress != nil) {
            [RunProgress invalidate];
            RunProgress = nil;
        }
        [self SendStop];
        _isExit=YES;
        AddDeviceFailed *v = [[AddDeviceFailed alloc] init];
        [self.navigationController pushViewController: v animated:true];
    }
    else{
        progress.percent += 1/progressTime;
    }
}

//RecvWithPacket
-(void)RecvWithPacket:(RecvPacket *)recvPacket{
    NSString *_ip=recvPacket.module_ip;
    NSString *_id=recvPacket.module_id;
    NSLog(@"ip=%@,id=%@",_ip,_id);
    [self SendStop];
    AddDeviceSuccess *v = [[AddDeviceSuccess alloc] init];
    v.deviceIP=_ip;
    v.deviceID=_id;
    [self.navigationController pushViewController: v animated:true];
}

//Back
- (void)_AddDeviceStep3BackClick{
    if (RunProgress != nil) {
        [RunProgress invalidate];
        RunProgress = nil;
    }
    [self SendStop];
    _isExit=YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- scanDevice
- (void)scanDevice
{
    if (_isExit) {
        return;
    }
    [NSThread detachNewThreadSelector:@selector(scanDeviceTask) toTarget:self withObject:nil];
}

- (void)scanDeviceTask
{
    Lx52x_Device_Info *result = [_device_Scan_Find ScanDeviceWithTime:1.5f];
    [self performSelectorOnMainThread:@selector(scanDeviceOver:) withObject:result waitUntilDone:NO];
}

- (void)scanDeviceOver:(Lx52x_Device_Info *)result;
{
    if (result.Device_ID_Arr.count > 0) {
        NSLog(@"Scan Over...");
        [result.Device_ID_Arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *deviceIp = [result.Device_IP_Arr objectAtIndex:idx];
            NSString *deviceId = [result.Device_ID_Arr objectAtIndex:idx];
            NSString *configured_deviceId = [self Get_Parameter: @"config_device_id"];
            if ([deviceId compare:configured_deviceId]==NSOrderedSame) {
                if (_isExit==NO) {
                    _isExit=YES;
                    AddDeviceSuccess *v = [[AddDeviceSuccess alloc] init];
                    v.deviceIP=deviceIp;
                    v.deviceID=deviceId;
                    [self.navigationController pushViewController: v animated:true];
                }
            }
            else
            {
                [self scanDevice];
            }
        }];
    }
    else{
        [self scanDevice];
    }
}


+(void)back{
    [_selfAddDeviceStep3 popViewControllerAnimated:YES];
}

//Stop
-(void)SendStop{
    if (start_flg == YES) {
        start_flg = NO;
        NSLog(@"stop");
        [__EasyConfig stop_send];//停止配置
        progress.percent=0;
    }
}


//Set StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
