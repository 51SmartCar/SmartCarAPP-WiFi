//
//  AddDeviceStep1AP.m
//  AoSmart
//
//  Created by rakwireless on 16/2/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep1AP.h"
#import "AddDeviceStep2AP.h"
#import "CommanParameter.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "DeviceInfo.h"
#import "Rak_Lx52x_Device_Control.h"
#import "MBProgressHUD.h"

Rak_Lx52x_Device_Control *_device_Scan_AP;
UIAlertView *waitAPScanAlertView;

@interface AddDeviceStep1AP ()
{
    bool _isExit;
}
@end

@implementation AddDeviceStep1AP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isExit=NO;
    _device_Scan_AP = [[Rak_Lx52x_Device_Control alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceStep1APBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1APBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep1APBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1APBack addTarget:nil action:@selector(_AddDeviceStep1APBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep1APBack];
    
    _AddDeviceStep1APTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_AddDeviceStep1APBack.frame.size.width-diff_x, title_size)];
    _AddDeviceStep1APTitle.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceStep1APBack.center.y);
    _AddDeviceStep1APTitle.text = NSLocalizedString(@"add_device_step1_ap_title", nil);;
    _AddDeviceStep1APTitle.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep1APTitle.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1APTitle.textColor = [UIColor grayColor];
    _AddDeviceStep1APTitle.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep1APTitle.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1APTitle.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep1APTitle];
    
    _AddDeviceStep1APText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep1APBack.frame.size.height+_AddDeviceStep1APBack.frame.origin.y+diff_top, viewW, title_size)];
    _AddDeviceStep1APText.text = NSLocalizedString(@"add_device_step1_ap_text", nil);;
    _AddDeviceStep1APText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep1APText.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1APText.textColor = [UIColor grayColor];
    _AddDeviceStep1APText.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1APText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1APText.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep1APText];
    
    _AddDeviceStep1APNote = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep1APText.frame.size.height+_AddDeviceStep1APText.frame.origin.y, viewW-diff_x, add_text_size*5)];
    _AddDeviceStep1APNote.text = NSLocalizedString(@"add_device_step1_ap_note", nil);;
    _AddDeviceStep1APNote.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep1APNote.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1APNote.textColor = [UIColor grayColor];
    _AddDeviceStep1APNote.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1APNote.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1APNote.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep1APNote];
    
    UIView *viewAdd=[[UIView alloc]init];
    viewAdd.frame=CGRectMake(0, _AddDeviceStep1APNote.frame.size.height+_AddDeviceStep1APNote.frame.origin.y+10, viewW, viewH-(_AddDeviceStep1APNote.frame.size.height+_AddDeviceStep1APNote.frame.origin.y+10));
    viewAdd.backgroundColor=[UIColor colorWithRed:add_bg/255.0 green:add_bg/255.0 blue:add_bg/255.0 alpha:1.0];
    [self.view addSubview:viewAdd];
    
    _AddDeviceStep1APNext=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1APNext.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.6, viewAdd.frame.size.width*0.6*110/484);
    _AddDeviceStep1APNext.center=CGPointMake(viewAdd.frame.size.width/2, viewAdd.frame.size.height-diff_bottom*2-viewAdd.frame.size.width*0.6*110/484/2);
    [_AddDeviceStep1APNext setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1APNext setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceStep1APNext.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceStep1APNext setTitle:NSLocalizedString(@"add_device_step1_ap_btn", nil) forState: UIControlStateNormal];
    _AddDeviceStep1APNext.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceStep1APNext addTarget:nil action:@selector(_AddDeviceStep1APNextClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep1APNext];
    
    _AddDeviceStep1APDevice1 = [[UIImageView alloc]init];
    _AddDeviceStep1APDevice1.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.54, viewAdd.frame.size.width*0.54*68/492);
    _AddDeviceStep1APDevice1.center=CGPointMake(viewAdd.frame.size.width/2, _AddDeviceStep1APNext.frame.origin.y-diff_bottom-viewAdd.frame.size.width*0.54*68/492/2);
    _AddDeviceStep1APDevice1.image = [UIImage imageNamed:@"bg1.png"];
    _AddDeviceStep1APDevice1.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_AddDeviceStep1APDevice1Click)];
    [_AddDeviceStep1APDevice1 addGestureRecognizer:singleTap];
    [viewAdd  addSubview:_AddDeviceStep1APDevice1];
    
    _AddDeviceStep1APDevice1Text = [[UILabel alloc] initWithFrame:CGRectMake(10, _AddDeviceStep1APDevice1.frame.size.height/2-title_size/2, _AddDeviceStep1APDevice1.frame.size.width*0.6, title_size)];
    _AddDeviceStep1APDevice1Text.text = NSLocalizedString(@"add_device_step1_device2", nil);
    _AddDeviceStep1APDevice1Text.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep1APDevice1Text.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1APDevice1Text.textColor = [UIColor lightGrayColor];
    _AddDeviceStep1APDevice1Text.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1APDevice1Text.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1APDevice1Text.numberOfLines = 0;
    [_AddDeviceStep1APDevice1 addSubview:_AddDeviceStep1APDevice1Text];
    
    _AddDeviceStep1APDevice1Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1APDevice1Btn.frame=CGRectMake(_AddDeviceStep1APDevice1.frame.size.width-add_text_size-10, _AddDeviceStep1APDevice1.frame.size.height/2-add_text_size/2, add_text_size, add_text_size);
    [_AddDeviceStep1APDevice1Btn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1APDevice1  addSubview:_AddDeviceStep1APDevice1Btn];
    
    _AddDeviceStep1APDevice2 = [[UIImageView alloc]init];
    _AddDeviceStep1APDevice2.frame=CGRectMake(_AddDeviceStep1APDevice1.frame.origin.x, _AddDeviceStep1APDevice1.frame.origin.y-viewAdd.frame.size.width*0.54*66/492, viewAdd.frame.size.width*0.54, viewAdd.frame.size.width*0.54*66/492);
    _AddDeviceStep1APDevice2.image = [UIImage imageNamed:@"bg2.png"];
    _AddDeviceStep1APDevice2.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_AddDeviceStep1APDevice2Click)];
    [_AddDeviceStep1APDevice2 addGestureRecognizer:singleTap2];
    [viewAdd  addSubview:_AddDeviceStep1APDevice2];
    
    _AddDeviceStep1APDevice2Text = [[UILabel alloc] initWithFrame:CGRectMake(10, _AddDeviceStep1APDevice2.frame.size.height/2-title_size/2, _AddDeviceStep1APDevice2.frame.size.width*0.6, title_size)];
    _AddDeviceStep1APDevice2Text.text = NSLocalizedString(@"add_device_step1_device1", nil);
    _AddDeviceStep1APDevice2Text.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep1APDevice2Text.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1APDevice2Text.textColor = [UIColor lightGrayColor];
    _AddDeviceStep1APDevice2Text.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1APDevice2Text.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1APDevice2Text.numberOfLines = 0;
    [_AddDeviceStep1APDevice2 addSubview:_AddDeviceStep1APDevice2Text];
    
    _AddDeviceStep1APDevice2Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1APDevice2Btn.frame=CGRectMake(_AddDeviceStep1APDevice2.frame.size.width-add_text_size-10, _AddDeviceStep1APDevice2.frame.size.height/2-add_text_size/2, add_text_size, add_text_size);
    [_AddDeviceStep1APDevice2Btn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1APDevice2  addSubview:_AddDeviceStep1APDevice2Btn];
    _AddDeviceStep1APDevice2Btn.hidden=YES;
    _AddDeviceStep1APDevice2.hidden=YES;
    
    _AddDeviceStep1APDevice = [[UIImageView alloc]init];
    _AddDeviceStep1APDevice.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.75, viewAdd.frame.size.width*0.75*360/690);
    _AddDeviceStep1APDevice.image = [UIImage imageNamed:@"add_image.png"];
    _AddDeviceStep1APDevice.center=CGPointMake(viewAdd.frame.size.width/2, _AddDeviceStep1APDevice2.frame.origin.y/2);
    [viewAdd  addSubview:_AddDeviceStep1APDevice];
    
    _AddDeviceStep1APDevice.hidden=YES;
    _AddDeviceStep1APDevice1.hidden=YES;
    _AddDeviceStep1APDevice2.hidden=YES;
    _AddDeviceStep1APDevice1Btn.hidden=YES;
    _AddDeviceStep1APDevice2Btn.hidden=YES;
    _AddDeviceStep1APDevice1Text.hidden=YES;
    _AddDeviceStep1APDevice2Text.hidden=YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
UIAlertView* show_alert;
-(void)show_alertinfo:(NSString *)info{
    show_alert = [[UIAlertView alloc] initWithTitle:info
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil];
    show_alert.alertViewStyle = UIAlertViewStyleDefault;
    
    [show_alert show];
}

-(id)fetchSSIDInfo
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    //NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    return info;
}


//Back
- (void)_AddDeviceStep1APBackClick{
    //[self.navigationController popViewControllerAnimated:YES];
    _isExit=YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Next
- (void)_AddDeviceStep1APNextClick{
    NSDictionary *ifs = [self fetchSSIDInfo];
    if (ifs != nil)
    {
//        NSString *ssid = ifs[@"SSID"];
//        if([ssid hasPrefix:@"LTH_"] ==YES){
//            [self scanDevice];
//        }
//        else{
//            [self show_alertinfo:NSLocalizedString(@"add_device_step1_ap_admin_connect_failed", nil)];
//        }
        [self scanDevice];
    }else{
        [self show_alertinfo:NSLocalizedString(@"add_device_step1_ap_wifi_failed", nil)];
    }
}

//Choose Device1 Click
- (void)_AddDeviceStep1APDevice1Click{
    if (_AddDeviceStep1APDevice2.hidden) {
        _AddDeviceStep1APDevice2.hidden=NO;
        [_AddDeviceStep1APDevice1Btn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }
    else{
        _AddDeviceStep1APDevice2.hidden=YES;
        [_AddDeviceStep1APDevice1Btn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    }
}

//Choose Devic2 Click
- (void)_AddDeviceStep1APDevice2Click{
    if(_AddDeviceStep1APDevice1Text.text == NSLocalizedString(@"add_device_step1_device2", nil)){
        _AddDeviceStep1APDevice1Text.text = NSLocalizedString(@"add_device_step1_device1", nil);
        _AddDeviceStep1APDevice2Text.text = NSLocalizedString(@"add_device_step1_device2", nil);
        _AddDeviceStep1APDevice.image = [UIImage imageNamed:@"add_image1.png"];
    }
    else{
        _AddDeviceStep1APDevice1Text.text = NSLocalizedString(@"add_device_step1_device2", nil);
        _AddDeviceStep1APDevice2Text.text = NSLocalizedString(@"add_device_step1_device1", nil);
        _AddDeviceStep1APDevice.image = [UIImage imageNamed:@"add_image.png"];
    }
    _AddDeviceStep1APDevice2.hidden=YES;
    [_AddDeviceStep1APDevice1Btn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
}

//Save Parameter
- (void)Save_Parameter:(NSString *)devices :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:devices forKey:key];
    [defaults synchronize];
}

//Get Parameter
- (NSString *)Get_Parameter:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    return value;
}

#pragma mark -- scanDevice
- (void)scanDevice
{
    if (_isExit) {
        return;
    }
    waitAPScanAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"add_device_step1_ap_connect_title", nil)
                                               message:NSLocalizedString(@"add_device_step1_ap_connect_text", nil)
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil, nil];
    [waitAPScanAlertView show];
    [NSThread detachNewThreadSelector:@selector(scanDeviceTask) toTarget:self withObject:nil];
}

- (void)scanDeviceTask
{
    Lx52x_Device_Info *result = [_device_Scan_AP ScanDeviceWithTime:1.5f];
    [self performSelectorOnMainThread:@selector(scanDeviceOver:) withObject:result waitUntilDone:NO];
}

- (void)scanDeviceOver:(Lx52x_Device_Info *)result;
{
    [waitAPScanAlertView dismissWithClickedButtonIndex:0 animated:YES];
    if (result.Device_ID_Arr.count > 0) {
        NSLog(@"Scan Over...");
        [result.Device_ID_Arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *deviceId = [result.Device_ID_Arr objectAtIndex:idx];
            [self Save_Parameter:deviceId :@"config_device_id"];
            AddDeviceStep2AP *v = [[AddDeviceStep2AP alloc] init];
            [self.navigationController pushViewController: v animated:true];
        }];
    }
    else
    {
        [self showAllTextDialog:NSLocalizedString(@"add_device_step1_ap_connect_failed", nil)];
    }
}

#pragma mark-- Toast显示示例
-(void)showAllTextDialog:(NSString *)str{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = str;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        //[HUD release];
        //HUD = nil;
    }];
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
