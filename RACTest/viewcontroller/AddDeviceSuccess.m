//
//  AddDeviceSuccess.m
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceSuccess.h"
#import "CommanParameter.h"
#import "DeviceData.h"
#import "DeviceInfo.h"
#import "MBProgressHUD.h"

bool IsAddSuccess=NO;
@interface AddDeviceSuccess ()

@end

@implementation AddDeviceSuccess

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceSuccessBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceSuccessBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceSuccessBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceSuccessBack addTarget:nil action:@selector(_AddDeviceSuccessBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceSuccessBack];
    
    _AddDeviceSuccessTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_AddDeviceSuccessBack.frame.size.width-diff_x, title_size)];
    _AddDeviceSuccessTitle.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceSuccessBack.center.y);
    _AddDeviceSuccessTitle.text = NSLocalizedString(@"add_device_success_title", nil);;
    _AddDeviceSuccessTitle.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceSuccessTitle.backgroundColor = [UIColor clearColor];
    _AddDeviceSuccessTitle.textColor = [UIColor grayColor];
    _AddDeviceSuccessTitle.textAlignment = UITextAlignmentCenter;
    _AddDeviceSuccessTitle.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceSuccessTitle.numberOfLines = 0;
    [self.view addSubview:_AddDeviceSuccessTitle];
    
    _AddDeviceSuccessImage = [[UIImageView alloc]init];
    _AddDeviceSuccessImage.frame=CGRectMake(0, 0, viewW*0.35, viewW*0.35);
    _AddDeviceSuccessImage.center=CGPointMake(viewW/2, _AddDeviceSuccessBack.frame.origin.y+diff_top*2+viewW*0.35/2);
    _AddDeviceSuccessImage.image = [UIImage imageNamed:@"config_device.png"];
    [self.view  addSubview:_AddDeviceSuccessImage];
    
    _AddDeviceSuccessField =[[UITextField alloc] initWithFrame:CGRectMake(diff_x,_AddDeviceSuccessImage.frame.origin.y+_AddDeviceSuccessImage.frame.size.height+diff_top, (viewW-diff_x*2), title_size)];
    _AddDeviceSuccessField.placeholder = NSLocalizedString(@"add_device_success_name_hint", nil);
    _AddDeviceSuccessField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _AddDeviceSuccessField.textColor = [UIColor grayColor];
    _AddDeviceSuccessField.backgroundColor = [UIColor clearColor];
    _AddDeviceSuccessField.borderStyle = UITextBorderStyleNone;
    _AddDeviceSuccessField.secureTextEntry = NO;
    _AddDeviceSuccessField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_AddDeviceSuccessField];
    
    UILabel *line=[[UILabel alloc]init];
    line.frame=CGRectMake(diff_x, _AddDeviceSuccessField.frame.origin.y+_AddDeviceSuccessField.frame.size.height+10, viewW-2*diff_x, 1);
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    _AddDeviceSuccessBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceSuccessBtn.frame=CGRectMake(0,0, viewW*0.6, viewW*0.6*110/484);
    _AddDeviceSuccessBtn.center=CGPointMake(viewW/2, line.frame.origin.y+line.frame.size.height+diff_top+viewW*0.6*110/484/2);
    [_AddDeviceSuccessBtn setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceSuccessBtn setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceSuccessBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceSuccessBtn setTitle:NSLocalizedString(@"add_device_success", nil) forState: UIControlStateNormal];
    _AddDeviceSuccessBtn.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceSuccessBtn addTarget:nil action:@selector(_AddDeviceSuccessBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceSuccessBtn];
    IsAddSuccess=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//AddDeviceSuccess
- (void)_AddDeviceSuccessBtnClick{
    if (_AddDeviceSuccessField.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"add_device_success_name_error", nil)];
        return;
    }
    DeviceData *_device_Data=[[DeviceData alloc]init];
    DeviceInfo *device=[[DeviceInfo alloc]init];
    device.deviceID=self.deviceID;
    device.deviceIp=self.deviceIP;
    device.deviceName=_AddDeviceSuccessField.text;
    device.deviceStatus=_deviceOffline;
    [_device_Data saveDeviceById:self.deviceID :_AddDeviceSuccessField.text :self.deviceIP :_deviceOffline];
    [self showAllTextDialog:NSLocalizedString(@"add_device_success_show", nil)];
    IsAddSuccess=YES;
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

//Back
- (void)_AddDeviceSuccessBackClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [_AddDeviceSuccessField resignFirstResponder];
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
        if(IsAddSuccess)
        {
          IsAddSuccess=NO;
          [self.navigationController popToRootViewControllerAnimated:YES];
        }
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
