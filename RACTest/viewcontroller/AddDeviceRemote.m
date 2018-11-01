//
//  AddDeviceRemote.m
//  AoSmart
//
//  Created by rakwireless on 16/1/22.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceRemote.h"
#import "CommanParameter.h"
#import "MBProgressHUD.h"
#import "DeviceData.h"

bool IsAddRemoteSuccess=NO;

@interface AddDeviceRemote ()

@end

@implementation AddDeviceRemote

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceRemoteBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceRemoteBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceRemoteBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceRemoteBack addTarget:nil action:@selector(_AddDeviceRemoteBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceRemoteBack];
    
    _AddDeviceRemoteTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_AddDeviceRemoteBack.frame.size.width-diff_x, title_size)];
    _AddDeviceRemoteTitle.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceRemoteBack.center.y);
    _AddDeviceRemoteTitle.text = NSLocalizedString(@"add_device_remote_title", nil);;
    _AddDeviceRemoteTitle.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceRemoteTitle.backgroundColor = [UIColor clearColor];
    _AddDeviceRemoteTitle.textColor = [UIColor grayColor];
    _AddDeviceRemoteTitle.textAlignment = UITextAlignmentCenter;
    _AddDeviceRemoteTitle.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceRemoteTitle.numberOfLines = 0;
    [self.view addSubview:_AddDeviceRemoteTitle];
    
    _AddDeviceRemoteText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceRemoteBack.frame.size.height+_AddDeviceRemoteBack.frame.origin.y+diff_top, viewW, title_size)];
    _AddDeviceRemoteText.text = NSLocalizedString(@"add_device_remote_text", nil);;
    _AddDeviceRemoteText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceRemoteText.backgroundColor = [UIColor clearColor];
    _AddDeviceRemoteText.textColor = [UIColor grayColor];
    _AddDeviceRemoteText.textAlignment = UITextAlignmentLeft;
    _AddDeviceRemoteText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceRemoteText.numberOfLines = 0;
    [self.view addSubview:_AddDeviceRemoteText];
    
    _AddDeviceRemoteNote = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceRemoteText.frame.size.height+_AddDeviceRemoteText.frame.origin.y, viewW-diff_x, add_text_size*5)];
    _AddDeviceRemoteNote.text = NSLocalizedString(@"add_device_remote_note", nil);;
    _AddDeviceRemoteNote.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceRemoteNote.backgroundColor = [UIColor clearColor];
    _AddDeviceRemoteNote.textColor = [UIColor grayColor];
    _AddDeviceRemoteNote.textAlignment = UITextAlignmentLeft;
    _AddDeviceRemoteNote.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceRemoteNote.numberOfLines = 0;
    [self.view addSubview:_AddDeviceRemoteNote];
    
    UIView *viewAdd=[[UIView alloc]init];
    viewAdd.frame=CGRectMake(0, _AddDeviceRemoteNote.frame.size.height+_AddDeviceRemoteNote.frame.origin.y+10, viewW, viewH-(_AddDeviceRemoteNote.frame.size.height+_AddDeviceRemoteNote.frame.origin.y+10));
    viewAdd.backgroundColor=[UIColor colorWithRed:add_bg/255.0 green:add_bg/255.0 blue:add_bg/255.0 alpha:1.0];
    [self.view addSubview:viewAdd];
    
    _AddDeviceRemoteIDField =[[UITextField alloc] initWithFrame:CGRectMake(diff_x, diff_top, (viewW-diff_x*2), title_size)];
    _AddDeviceRemoteIDField.placeholder = NSLocalizedString(@"add_device_remote_id_hint", nil);
    _AddDeviceRemoteIDField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _AddDeviceRemoteIDField.textColor = [UIColor grayColor];
    _AddDeviceRemoteIDField.backgroundColor = [UIColor clearColor];
    _AddDeviceRemoteIDField.borderStyle = UITextBorderStyleNone;
    _AddDeviceRemoteIDField.secureTextEntry = NO;
    _AddDeviceRemoteIDField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewAdd addSubview:_AddDeviceRemoteIDField];
    
    UILabel *line=[[UILabel alloc]init];
    line.frame=CGRectMake(diff_x, _AddDeviceRemoteIDField.frame.origin.y+_AddDeviceRemoteIDField.frame.size.height+10, viewW-2*diff_x, 1);
    line.backgroundColor=[UIColor lightGrayColor];
    [viewAdd addSubview:line];
    
    _AddDeviceRemoteNameField =[[UITextField alloc] initWithFrame:CGRectMake(diff_x, line.frame.size.height+line.frame.origin.y+ diff_top, (viewW-diff_x*2), title_size)];
    _AddDeviceRemoteNameField.placeholder = NSLocalizedString(@"add_device_remote_name_hint", nil);
    _AddDeviceRemoteNameField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _AddDeviceRemoteNameField.textColor = [UIColor grayColor];
    _AddDeviceRemoteNameField.backgroundColor = [UIColor clearColor];
    _AddDeviceRemoteNameField.borderStyle = UITextBorderStyleNone;
    _AddDeviceRemoteNameField.secureTextEntry = NO;
    _AddDeviceRemoteNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewAdd addSubview:_AddDeviceRemoteNameField];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.frame=CGRectMake(diff_x, _AddDeviceRemoteNameField.frame.origin.y+_AddDeviceRemoteNameField.frame.size.height+10, viewW-2*diff_x, 1);
    line1.backgroundColor=[UIColor lightGrayColor];
    [viewAdd addSubview:line1];
    
    _AddDeviceRemoteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceRemoteBtn.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.6, viewAdd.frame.size.width*0.6*110/484);
    _AddDeviceRemoteBtn.center=CGPointMake(viewAdd.frame.size.width/2, viewAdd.frame.size.height-diff_bottom*2-viewAdd.frame.size.width*0.6*110/484/2);
    [_AddDeviceRemoteBtn setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceRemoteBtn setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceRemoteBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceRemoteBtn setTitle:NSLocalizedString(@"add_device_remote", nil) forState: UIControlStateNormal];
    _AddDeviceRemoteBtn.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceRemoteBtn addTarget:nil action:@selector(_AddDeviceRemoteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceRemoteBtn];
    IsAddRemoteSuccess=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//AddDeviceRemote
- (void)_AddDeviceRemoteBtnClick{
    if (_AddDeviceRemoteIDField.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"add_device_remote_id_error", nil)];
        return;
    }
    else if (_AddDeviceRemoteNameField.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"add_device_remote_name_error", nil)];
        return;
    }
    IsAddRemoteSuccess=YES;
    DeviceData *data=[[DeviceData alloc]init];
    [data saveDeviceById:_AddDeviceRemoteIDField.text :_AddDeviceRemoteNameField.text :@"127.0.0.1" :_deviceOffline];
    [self showAllTextDialog:NSLocalizedString(@"add_device_remote_success", nil)];
}


//Back
- (void)_AddDeviceRemoteBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

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
        if (IsAddRemoteSuccess) {
            IsAddRemoteSuccess=NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _AddDeviceRemoteIDField) {
        [_AddDeviceRemoteNameField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [_AddDeviceRemoteIDField resignFirstResponder];
    [_AddDeviceRemoteNameField resignFirstResponder];
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
