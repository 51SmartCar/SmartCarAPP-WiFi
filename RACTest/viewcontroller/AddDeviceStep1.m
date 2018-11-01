//
//  AddDeviceStep1.m
//  AoSmart
//
//  Created by rakwireless on 16/1/22.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep1.h"
#import "CommanParameter.h"
#import "AddDeviceStep2.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface AddDeviceStep1 ()

@end

@implementation AddDeviceStep1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceStep1Back=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1Back.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep1Back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1Back addTarget:nil action:@selector(_AddDeviceStep1BackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep1Back];
    
    _AddDeviceStep1Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_AddDeviceStep1Back.frame.size.width-diff_x, title_size)];
    _AddDeviceStep1Title.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceStep1Back.center.y);
    _AddDeviceStep1Title.text = NSLocalizedString(@"add_device_step1_title", nil);;
    _AddDeviceStep1Title.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep1Title.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1Title.textColor = [UIColor grayColor];
    _AddDeviceStep1Title.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep1Title.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1Title.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep1Title];
    
    _AddDeviceStep1Text = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep1Back.frame.size.height+_AddDeviceStep1Back.frame.origin.y+diff_top, viewW, title_size)];
    _AddDeviceStep1Text.text = NSLocalizedString(@"add_device_step1_text", nil);;
    _AddDeviceStep1Text.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep1Text.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1Text.textColor = [UIColor grayColor];
    _AddDeviceStep1Text.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1Text.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1Text.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep1Text];
    
    _AddDeviceStep1Note = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep1Text.frame.size.height+_AddDeviceStep1Text.frame.origin.y, viewW-diff_x, add_text_size*5)];
    _AddDeviceStep1Note.text = NSLocalizedString(@"add_device_step1_note", nil);;
    _AddDeviceStep1Note.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep1Note.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1Note.textColor = [UIColor grayColor];
    _AddDeviceStep1Note.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1Note.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1Note.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep1Note];
    
    UIView *viewAdd=[[UIView alloc]init];
    viewAdd.frame=CGRectMake(0, _AddDeviceStep1Note.frame.size.height+_AddDeviceStep1Note.frame.origin.y+10, viewW, viewH-(_AddDeviceStep1Note.frame.size.height+_AddDeviceStep1Note.frame.origin.y+10));
    viewAdd.backgroundColor=[UIColor colorWithRed:add_bg/255.0 green:add_bg/255.0 blue:add_bg/255.0 alpha:1.0];
    [self.view addSubview:viewAdd];
    
    _AddDeviceStep1NetText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, diff_top, (viewW-diff_x*2)/3, title_size)];
    _AddDeviceStep1NetText.text = NSLocalizedString(@"add_device_step1_wifi", nil);;
    _AddDeviceStep1NetText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep1NetText.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1NetText.textColor = [UIColor grayColor];
    _AddDeviceStep1NetText.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1NetText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1NetText.numberOfLines = 0;
    [viewAdd addSubview:_AddDeviceStep1NetText];
    
    _AddDeviceStep1NetField = [[UITextField alloc] initWithFrame:CGRectMake(_AddDeviceStep1NetText.frame.size.width+_AddDeviceStep1NetText.frame.origin.x+10, diff_top, (viewW-diff_x*2)*2/3, title_size)];
    _AddDeviceStep1NetField.placeholder = NSLocalizedString(@"add_device_step1_wifi_hint", nil);
    _AddDeviceStep1NetField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _AddDeviceStep1NetField.textColor = [UIColor grayColor];
    _AddDeviceStep1NetField.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1NetField.borderStyle = UITextBorderStyleNone;
    _AddDeviceStep1NetField.secureTextEntry = NO;
    _AddDeviceStep1NetField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewAdd addSubview:_AddDeviceStep1NetField];
    
    _AddDeviceStep1PskText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep1NetText.frame.size.height+_AddDeviceStep1NetText.frame.origin.y+diff_top, (viewW-diff_x*2)/3, title_size)];
    _AddDeviceStep1PskText.text = NSLocalizedString(@"add_device_step1_psk", nil);
    _AddDeviceStep1PskText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep1PskText.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1PskText.textColor = [UIColor lightGrayColor];
    _AddDeviceStep1PskText.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1PskText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1PskText.numberOfLines = 0;
    [viewAdd addSubview:_AddDeviceStep1PskText];
    
    _AddDeviceStep1ShowPsk=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1ShowPsk.frame=CGRectMake(0, 0, add_text_size*90/56, add_text_size);
    _AddDeviceStep1ShowPsk.center=CGPointMake(viewW- diff_x-add_text_size*90/56/2, _AddDeviceStep1PskText.center.y);
    [_AddDeviceStep1ShowPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1ShowPsk addTarget:nil action:@selector(_AddDeviceStep1ShowPskClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep1ShowPsk];
    
    _AddDeviceStep1PskField = [[UITextField alloc] initWithFrame:CGRectMake(_AddDeviceStep1PskText.frame.size.width+_AddDeviceStep1PskText.frame.origin.x+10, _AddDeviceStep1NetText.frame.size.height+_AddDeviceStep1NetText.frame.origin.y+diff_top, (_AddDeviceStep1ShowPsk.frame.origin.x-diff_x*2)*2/3-5, title_size)];
    _AddDeviceStep1PskField.placeholder = NSLocalizedString(@"add_device_step1_psk_hint", nil);
    _AddDeviceStep1PskField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _AddDeviceStep1PskField.textColor = [UIColor grayColor];
    _AddDeviceStep1PskField.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1PskField.borderStyle = UITextBorderStyleNone;
    _AddDeviceStep1PskField.secureTextEntry = YES;
    _AddDeviceStep1PskField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewAdd addSubview:_AddDeviceStep1PskField];
    
    UILabel *line=[[UILabel alloc]init];
    line.frame=CGRectMake(diff_x, _AddDeviceStep1PskField.frame.origin.y+_AddDeviceStep1PskField.frame.size.height+10, viewW-2*diff_x, 1);
    line.backgroundColor=[UIColor lightGrayColor];
    [viewAdd addSubview:line];
    
    _AddDeviceStep1Next=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1Next.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.6, viewAdd.frame.size.width*0.6*110/484);
    _AddDeviceStep1Next.center=CGPointMake(viewAdd.frame.size.width/2, viewAdd.frame.size.height-diff_bottom*2-viewAdd.frame.size.width*0.6*110/484/2);
    [_AddDeviceStep1Next setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1Next setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceStep1Next.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceStep1Next setTitle:NSLocalizedString(@"add_device_next", nil) forState: UIControlStateNormal];
    _AddDeviceStep1Next.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceStep1Next addTarget:nil action:@selector(_AddDeviceStep1NextClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep1Next];
    
    _AddDeviceStep1Device1 = [[UIImageView alloc]init];
    _AddDeviceStep1Device1.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.54, viewAdd.frame.size.width*0.54*68/492);
    _AddDeviceStep1Device1.center=CGPointMake(viewAdd.frame.size.width/2, _AddDeviceStep1Next.frame.origin.y-diff_bottom-viewAdd.frame.size.width*0.54*68/492/2);
    _AddDeviceStep1Device1.image = [UIImage imageNamed:@"bg1.png"];
    _AddDeviceStep1Device1.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_AddDeviceStep1Device1Click)];
    [_AddDeviceStep1Device1 addGestureRecognizer:singleTap];
    [viewAdd  addSubview:_AddDeviceStep1Device1];
    
    _AddDeviceStep1Device1Text = [[UILabel alloc] initWithFrame:CGRectMake(10, _AddDeviceStep1Device1.frame.size.height/2-title_size/2, _AddDeviceStep1Device1.frame.size.width*0.6, title_size)];
    _AddDeviceStep1Device1Text.text = NSLocalizedString(@"add_device_step1_device2", nil);
    _AddDeviceStep1Device1Text.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep1Device1Text.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1Device1Text.textColor = [UIColor lightGrayColor];
    _AddDeviceStep1Device1Text.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1Device1Text.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1Device1Text.numberOfLines = 0;
    [_AddDeviceStep1Device1 addSubview:_AddDeviceStep1Device1Text];
    
    _AddDeviceStep1Device1Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1Device1Btn.frame=CGRectMake(_AddDeviceStep1Device1.frame.size.width-add_text_size-10, _AddDeviceStep1Device1.frame.size.height/2-add_text_size/2, add_text_size, add_text_size);
    [_AddDeviceStep1Device1Btn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1Device1  addSubview:_AddDeviceStep1Device1Btn];
    
    _AddDeviceStep1Device2 = [[UIImageView alloc]init];
    _AddDeviceStep1Device2.frame=CGRectMake(_AddDeviceStep1Device1.frame.origin.x, _AddDeviceStep1Device1.frame.origin.y-viewAdd.frame.size.width*0.54*66/492, viewAdd.frame.size.width*0.54, viewAdd.frame.size.width*0.54*66/492);
    _AddDeviceStep1Device2.image = [UIImage imageNamed:@"bg2.png"];
    _AddDeviceStep1Device2.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_AddDeviceStep1Device2Click)];
    [_AddDeviceStep1Device2 addGestureRecognizer:singleTap2];
    [viewAdd  addSubview:_AddDeviceStep1Device2];
    
    _AddDeviceStep1Device2Text = [[UILabel alloc] initWithFrame:CGRectMake(10, _AddDeviceStep1Device2.frame.size.height/2-title_size/2, _AddDeviceStep1Device2.frame.size.width*0.6, title_size)];
    _AddDeviceStep1Device2Text.text = NSLocalizedString(@"add_device_step1_device1", nil);
    _AddDeviceStep1Device2Text.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep1Device2Text.backgroundColor = [UIColor clearColor];
    _AddDeviceStep1Device2Text.textColor = [UIColor lightGrayColor];
    _AddDeviceStep1Device2Text.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep1Device2Text.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep1Device2Text.numberOfLines = 0;
    [_AddDeviceStep1Device2 addSubview:_AddDeviceStep1Device2Text];
    
    _AddDeviceStep1Device2Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep1Device2Btn.frame=CGRectMake(_AddDeviceStep1Device2.frame.size.width-add_text_size-10, _AddDeviceStep1Device2.frame.size.height/2-add_text_size/2, add_text_size, add_text_size);
    [_AddDeviceStep1Device2Btn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    [_AddDeviceStep1Device2  addSubview:_AddDeviceStep1Device2Btn];
    
    _AddDeviceStep1Device1.hidden=YES;
    _AddDeviceStep1Device2.hidden=YES;
    _AddDeviceStep1Device1Btn.hidden=YES;
    _AddDeviceStep1Device2Btn.hidden=YES;
    _AddDeviceStep1Device1Text.hidden=YES;
    _AddDeviceStep1Device2Text.hidden=YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _AddDeviceStep1NetField.text=[self getWifiName];
    _AddDeviceStep1PskField.text=[self Get_Parameter:_AddDeviceStep1NetField.text];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Back
- (void)_AddDeviceStep1BackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//Next
- (void)_AddDeviceStep1NextClick{
    AddDeviceStep2 *v = [[AddDeviceStep2 alloc] init];
    if(_AddDeviceStep1Device1Text.text == NSLocalizedString(@"add_device_step1_device2", nil)){
        v.deviceFlag=2;
    }else{
        v.deviceFlag=1;
    }
    [self Save_Parameter:_AddDeviceStep1PskField.text:@"config_psk"];

    //Save psk
    [self Save_Parameter:_AddDeviceStep1PskField.text :_AddDeviceStep1NetField.text];
    [self.navigationController pushViewController: v animated:true];
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
//Show password
- (void)_AddDeviceStep1ShowPskClick{
    if (_AddDeviceStep1PskField.secureTextEntry) {
        _AddDeviceStep1PskField.secureTextEntry = NO;
        [_AddDeviceStep1ShowPsk setImage:[UIImage imageNamed:@"psk_open.png"] forState:UIControlStateNormal];
    }
    else{
        _AddDeviceStep1PskField.secureTextEntry = YES;
        [_AddDeviceStep1ShowPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
    }
}

//Choose Device1 Click
- (void)_AddDeviceStep1Device1Click{
    if (_AddDeviceStep1Device2.hidden) {
        _AddDeviceStep1Device2.hidden=NO;
        [_AddDeviceStep1Device1Btn setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
    }
    else{
        _AddDeviceStep1Device2.hidden=YES;
        [_AddDeviceStep1Device1Btn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
    }
}

//Choose Devic2 Click
- (void)_AddDeviceStep1Device2Click{
    if(_AddDeviceStep1Device1Text.text == NSLocalizedString(@"add_device_step1_device2", nil)){
        _AddDeviceStep1Device1Text.text = NSLocalizedString(@"add_device_step1_device1", nil);
        _AddDeviceStep1Device2Text.text = NSLocalizedString(@"add_device_step1_device2", nil);
    }
    else{
        _AddDeviceStep1Device1Text.text = NSLocalizedString(@"add_device_step1_device2", nil);
        _AddDeviceStep1Device2Text.text = NSLocalizedString(@"add_device_step1_device1", nil);
    }
    _AddDeviceStep1Device2.hidden=YES;
    [_AddDeviceStep1Device1Btn setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
}

//Get Wifi Name
-(NSString *)getWifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _AddDeviceStep1NetField) {
        [_AddDeviceStep1PskField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [_AddDeviceStep1NetField resignFirstResponder];
    [_AddDeviceStep1PskField resignFirstResponder];
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
