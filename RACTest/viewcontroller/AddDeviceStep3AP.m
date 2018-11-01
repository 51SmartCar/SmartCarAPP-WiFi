//
//  AddDeviceStep3AP.m
//  AoSmart
//
//  Created by rakwireless on 16/2/28.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep3AP.h"
#import "AddDeviceStep1AP.h"
#import "AddDeviceStep3.h"
#import "CommanParameter.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface AddDeviceStep3AP ()

@end

@implementation AddDeviceStep3AP

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceStep3APBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep3APBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep3APBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep3APBack addTarget:nil action:@selector(_AddDeviceStep3APBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep3APBack];
    
    _AddDeviceStep3APTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_AddDeviceStep3APBack.frame.size.width-diff_x, title_size)];
    _AddDeviceStep3APTitle.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceStep3APBack.center.y);
    _AddDeviceStep3APTitle.text = NSLocalizedString(@"add_device_step3_ap_title", nil);;
    _AddDeviceStep3APTitle.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep3APTitle.backgroundColor = [UIColor clearColor];
    _AddDeviceStep3APTitle.textColor = [UIColor grayColor];
    _AddDeviceStep3APTitle.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep3APTitle.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep3APTitle.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep3APTitle];
    
    _AddDeviceStep3APText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep3APBack.frame.size.height+_AddDeviceStep3APBack.frame.origin.y+diff_top, viewW, title_size)];
    _AddDeviceStep3APText.text = NSLocalizedString(@"add_device_step3_ap_text", nil);;
    _AddDeviceStep3APText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep3APText.backgroundColor = [UIColor clearColor];
    _AddDeviceStep3APText.textColor = [UIColor grayColor];
    _AddDeviceStep3APText.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep3APText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep3APText.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep3APText];
    
    _AddDeviceStep3APNote = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep3APText.frame.size.height+_AddDeviceStep3APText.frame.origin.y, viewW-diff_x, add_text_size*5)];
    _AddDeviceStep3APNote.text = NSLocalizedString(@"add_device_step3_ap_note", nil);;
    _AddDeviceStep3APNote.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep3APNote.backgroundColor = [UIColor clearColor];
    _AddDeviceStep3APNote.textColor = [UIColor grayColor];
    _AddDeviceStep3APNote.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep3APNote.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep3APNote.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep3APNote];
    
    UIView *viewAdd=[[UIView alloc]init];
    viewAdd.frame=CGRectMake(0, _AddDeviceStep3APNote.frame.size.height+_AddDeviceStep3APNote.frame.origin.y+10, viewW, viewH-(_AddDeviceStep3APNote.frame.size.height+_AddDeviceStep3APNote.frame.origin.y+10));
    viewAdd.backgroundColor=[UIColor colorWithRed:add_bg/255.0 green:add_bg/255.0 blue:add_bg/255.0 alpha:1.0];
    [self.view addSubview:viewAdd];
    
    _AddDeviceStep3APNext=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep3APNext.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.6, viewAdd.frame.size.width*0.6*110/484);
    _AddDeviceStep3APNext.center=CGPointMake(viewAdd.frame.size.width/2, viewAdd.frame.size.height-diff_bottom*2-viewAdd.frame.size.width*0.6*110/484/2);
    [_AddDeviceStep3APNext setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceStep3APNext setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceStep3APNext.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceStep3APNext setTitle:NSLocalizedString(@"add_device_step3_ap_btn", nil) forState: UIControlStateNormal];
    _AddDeviceStep3APNext.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceStep3APNext addTarget:nil action:@selector(_AddDeviceStep3APNextClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep3APNext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
UIAlertView* show_alert_ap;
-(void)show_alert_apinfo:(NSString *)info{
    show_alert_ap = [[UIAlertView alloc] initWithTitle:info
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil, nil];
    show_alert_ap.alertViewStyle = UIAlertViewStyleDefault;
    
    [show_alert_ap show];
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
- (void)_AddDeviceStep3APBackClick{
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    AddDeviceStep1AP *v2 = [[AddDeviceStep1AP alloc] init];
    [self.navigationController pushViewController: v2 animated:true];
}

//Next
- (void)_AddDeviceStep3APNextClick{
    NSString *configured_ssid=[self Get_Parameter:@"configure_ssid_ap"];
    NSDictionary *ifs = [self fetchSSIDInfo];
    if (ifs != nil)
    {
        NSString *ssid = ifs[@"SSID"];
        if([ssid hasPrefix:configured_ssid] ==YES){
            [self Save_Parameter:@"ap" :@"condifure_way"];
            AddDeviceStep3 *v = [[AddDeviceStep3 alloc] init];
            [self.navigationController pushViewController: v animated:true];
        }
        else{
            NSString *note=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"add_device_step3_ap_admin_connect_failed", nil),configured_ssid];
            [self show_alert_apinfo:note];
        }
    }else{
        [self show_alert_apinfo:NSLocalizedString(@"add_device_step1_ap_wifi_failed", nil)];
    }
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
