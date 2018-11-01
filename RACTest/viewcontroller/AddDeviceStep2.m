//
//  AddDeviceStep2.m
//  AoSmart
//
//  Created by rakwireless on 16/1/23.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep2.h"
#import "AddDeviceStep1.h"
#import "CommanParameter.h"
#import "AddDeviceStep3.h"

@interface AddDeviceStep2 ()

@end

@implementation AddDeviceStep2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceStep2Back=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep2Back.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep2Back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep2Back addTarget:nil action:@selector(_AddDeviceStep2BackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep2Back];
    
    _AddDeviceStep2Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_AddDeviceStep2Back.frame.size.width-diff_x, title_size)];
    _AddDeviceStep2Title.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceStep2Back.center.y);
    _AddDeviceStep2Title.text = NSLocalizedString(@"add_device_step1_title", nil);;
    _AddDeviceStep2Title.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep2Title.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2Title.textColor = [UIColor grayColor];
    _AddDeviceStep2Title.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep2Title.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2Title.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep2Title];
    
    _AddDeviceStep2Text = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep2Back.frame.size.height+_AddDeviceStep2Back.frame.origin.y+diff_top, viewW, title_size)];
    _AddDeviceStep2Text.text = NSLocalizedString(@"add_device_step1_text", nil);;
    _AddDeviceStep2Text.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep2Text.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2Text.textColor = [UIColor grayColor];
    _AddDeviceStep2Text.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep2Text.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2Text.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep2Text];
    
    _AddDeviceStep2Note = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep2Text.frame.size.height+_AddDeviceStep2Text.frame.origin.y, viewW-diff_x, add_text_size*5)];
    _AddDeviceStep2Note.text = NSLocalizedString(@"add_device_step2_note", nil);;
    _AddDeviceStep2Note.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep2Note.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2Note.textColor = [UIColor grayColor];
    _AddDeviceStep2Note.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep2Note.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2Note.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep2Note];
    
    UIView *viewAdd=[[UIView alloc]init];
    viewAdd.frame=CGRectMake(0, _AddDeviceStep2Note.frame.size.height+_AddDeviceStep2Note.frame.origin.y+10, viewW, viewH-(_AddDeviceStep2Note.frame.size.height+_AddDeviceStep2Note.frame.origin.y+10));
    viewAdd.backgroundColor=[UIColor colorWithRed:add_bg/255.0 green:add_bg/255.0 blue:add_bg/255.0 alpha:1.0];
    [self.view addSubview:viewAdd];
    
    _AddDeviceStep2Next=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep2Next.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.6, viewAdd.frame.size.width*0.6*110/484);
    _AddDeviceStep2Next.center=CGPointMake(viewAdd.frame.size.width/2, viewAdd.frame.size.height-diff_bottom*2-viewAdd.frame.size.width*0.6*110/484/2);
    [_AddDeviceStep2Next setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceStep2Next setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceStep2Next.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceStep2Next setTitle:NSLocalizedString(@"add_device_next", nil) forState: UIControlStateNormal];
    _AddDeviceStep2Next.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceStep2Next addTarget:nil action:@selector(_AddDeviceStep2NextClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep2Next];
    
    _AddDeviceStep2Device = [[UIImageView alloc]init];
    if (self.deviceFlag==1) {
        _AddDeviceStep2Device.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.75, viewAdd.frame.size.width*0.75*360/630);
        _AddDeviceStep2Device.image = [UIImage imageNamed:@"add_image1.png"];
    }
    else{
        _AddDeviceStep2Device.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.75, viewAdd.frame.size.width*0.75*360/690);
        _AddDeviceStep2Device.image = [UIImage imageNamed:@"add_image.png"];
    }
    _AddDeviceStep2Device.center=CGPointMake(viewAdd.frame.size.width/2, _AddDeviceStep2Next.frame.origin.y/2);
    [viewAdd  addSubview:_AddDeviceStep2Device];
    
    _AddDeviceStep2Device.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Back
- (void)_AddDeviceStep2BackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//Next
- (void)_AddDeviceStep2NextClick{
    [self Save_Parameter:@"easy" :@"condifure_way"];
    AddDeviceStep3 *v = [[AddDeviceStep3 alloc] init];
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
