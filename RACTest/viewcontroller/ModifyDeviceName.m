//
//  ModifyDeviceName.m
//  AoSmart
//
//  Created by rakwireless on 16/1/23.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "ModifyDeviceName.h"
#import "CommanParameter.h"
#import "MBProgressHUD.h"
#import "DeviceData.h"

bool IsDeleteSuccess=NO;

@interface ModifyDeviceName ()

@end

@implementation ModifyDeviceName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _modifyDeviceNameBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _modifyDeviceNameBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_modifyDeviceNameBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_modifyDeviceNameBack addTarget:nil action:@selector(_modifyDeviceNameBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_modifyDeviceNameBack];
    
    _modifyDeviceNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_modifyDeviceNameBack.frame.size.width-diff_x, title_size)];
    _modifyDeviceNameTitle.center=CGPointMake(self.view.frame.size.width/2,_modifyDeviceNameBack.center.y);
    _modifyDeviceNameTitle.text = NSLocalizedString(@"device_modify_title", nil);;
    _modifyDeviceNameTitle.font = [UIFont systemFontOfSize: main_help_size];
    _modifyDeviceNameTitle.backgroundColor = [UIColor clearColor];
    _modifyDeviceNameTitle.textColor = [UIColor grayColor];
    _modifyDeviceNameTitle.textAlignment = UITextAlignmentCenter;
    _modifyDeviceNameTitle.lineBreakMode = UILineBreakModeWordWrap;
    _modifyDeviceNameTitle.numberOfLines = 0;
    [self.view addSubview:_modifyDeviceNameTitle];
    
    _modifyDeviceNameImage = [[UIImageView alloc]init];
    _modifyDeviceNameImage.frame=CGRectMake(0, 0, viewW*0.35, viewW*0.35);
    _modifyDeviceNameImage.center=CGPointMake(viewW/2, _modifyDeviceNameBack.frame.origin.y+diff_top*2+viewW*0.35/2);
    _modifyDeviceNameImage.image = [UIImage imageNamed:@"config_device.png"];
    [self.view  addSubview:_modifyDeviceNameImage];
    
    _modifyDeviceNameField =[[UITextField alloc] initWithFrame:CGRectMake(diff_x,_modifyDeviceNameImage.frame.origin.y+_modifyDeviceNameImage.frame.size.height+diff_top, (viewW-diff_x*2), title_size)];
    _modifyDeviceNameField.placeholder = NSLocalizedString(@"device_modify_name_hint", nil);
    _modifyDeviceNameField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _modifyDeviceNameField.textColor = [UIColor grayColor];
    _modifyDeviceNameField.backgroundColor = [UIColor clearColor];
    _modifyDeviceNameField.borderStyle = UITextBorderStyleNone;
    _modifyDeviceNameField.secureTextEntry = NO;
    _modifyDeviceNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_modifyDeviceNameField];
    
    UILabel *line=[[UILabel alloc]init];
    line.frame=CGRectMake(diff_x, _modifyDeviceNameField.frame.origin.y+_modifyDeviceNameField.frame.size.height+10, viewW-2*diff_x, 1);
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    _deleteDeviceNameBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _deleteDeviceNameBtn.frame=CGRectMake(viewW*0.1,line.frame.origin.y+line.frame.size.height+diff_top, viewW*0.3, viewW*0.6*110/484);
    [_deleteDeviceNameBtn setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_deleteDeviceNameBtn setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _deleteDeviceNameBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_deleteDeviceNameBtn setTitle:NSLocalizedString(@"device_delete_btn", nil) forState: UIControlStateNormal];
    _deleteDeviceNameBtn.titleLabel.textColor=[UIColor redColor];
    [_deleteDeviceNameBtn addTarget:nil action:@selector(_deleteDeviceNameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_deleteDeviceNameBtn];
    
    _modifyDeviceNameBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _modifyDeviceNameBtn.frame=CGRectMake(viewW*0.6,line.frame.origin.y+line.frame.size.height+diff_top, viewW*0.3, viewW*0.6*110/484);
    [_modifyDeviceNameBtn setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_modifyDeviceNameBtn setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _modifyDeviceNameBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_modifyDeviceNameBtn setTitle:NSLocalizedString(@"device_modify_btn", nil) forState: UIControlStateNormal];
    _modifyDeviceNameBtn.titleLabel.textColor=[UIColor redColor];
    [_modifyDeviceNameBtn addTarget:nil action:@selector(_modifyDeviceNameBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_modifyDeviceNameBtn];
    
    _modifyDeviceIDField =[[UITextField alloc] initWithFrame:CGRectMake(diff_x,_modifyDeviceNameBtn.frame.origin.y+_modifyDeviceNameBtn.frame.size.height+diff_top, (viewW-diff_x*2), title_size)];
    _modifyDeviceIDField.placeholder = NSLocalizedString(@"device_modify_id_text", nil);
    _modifyDeviceIDField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _modifyDeviceIDField.textColor = [UIColor grayColor];
    _modifyDeviceIDField.backgroundColor = [UIColor clearColor];
    _modifyDeviceIDField.borderStyle = UITextBorderStyleNone;
    _modifyDeviceIDField.secureTextEntry = NO;
    _modifyDeviceIDField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_modifyDeviceIDField];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.frame=CGRectMake(diff_x, _modifyDeviceIDField.frame.origin.y+_modifyDeviceIDField.frame.size.height+10, viewW-2*diff_x, 1);
    line1.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line1];
    
    _copyDeviceIDBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _copyDeviceIDBtn.frame=CGRectMake(0,0, viewW*0.6, viewW*0.6*110/484);
    _copyDeviceIDBtn.center=CGPointMake(viewW/2, line1.frame.origin.y+line.frame.size.height+diff_top+viewW*0.6*110/484/2);
    [_copyDeviceIDBtn setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_copyDeviceIDBtn setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _copyDeviceIDBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_copyDeviceIDBtn setTitle:NSLocalizedString(@"device_modify_copy_text", nil) forState: UIControlStateNormal];
    _copyDeviceIDBtn.titleLabel.textColor=[UIColor redColor];
    [_copyDeviceIDBtn addTarget:nil action:@selector(_copyDeviceIDBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_copyDeviceIDBtn];
    _modifyDeviceIDField.text=self.deviceId;
    IsDeleteSuccess=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//DeleteDevice
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSLog(@"Cancel");
    }
    else if(buttonIndex==1){
        NSLog(@"OK");
        DeviceData *data=[[DeviceData alloc]init];
        [data deleteDeviceId:self.deviceId];
        IsDeleteSuccess=YES;
        [self showAllTextDialog:NSLocalizedString(@"modify_device_success_delete", nil)];
    }
}

- (void)_deleteDeviceNameBtnClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"modify_device_delete_title", nil)
        message:NSLocalizedString(@"modify_device_delete_text", nil)
        delegate:self cancelButtonTitle:NSLocalizedString(@"modify_device_delete_cancel", nil) otherButtonTitles:NSLocalizedString(@"modify_device_delete_ok", nil), nil, nil];
    [alert show];
}


//ModifyDeviceName
- (void)_modifyDeviceNameBtnClick{
    if (_modifyDeviceNameField.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"add_device_success_name_error", nil)];
        return;
    }
    DeviceData *data=[[DeviceData alloc]init];
    [data updateDeviceNameById:self.deviceId :_modifyDeviceNameField.text];
    NSString *note=[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"modify_device_success_name", nil),_modifyDeviceNameField.text];
    [self showAllTextDialog:note];
}

//CopyDeviceID
- (void)_copyDeviceIDBtnClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _modifyDeviceIDField.text;
    [self showAllTextDialog:NSLocalizedString(@"device_modify_copy_text_success", nil)];
}

//Back
- (void)_modifyDeviceNameBackClick{
    [self.navigationController popViewControllerAnimated:YES];
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
        if (IsDeleteSuccess) {
            IsDeleteSuccess=NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _modifyDeviceNameField) {
        [_modifyDeviceIDField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [_modifyDeviceNameField resignFirstResponder];
    [_modifyDeviceIDField resignFirstResponder];
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
