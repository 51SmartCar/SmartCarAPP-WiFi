//
//  AddDeviceFailed.m
//  AoSmart
//
//  Created by rakwireless on 16/1/23.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceFailed.h"
#import "CommanParameter.h"
#import "AddDeviceStep3.h"
#import "AddDeviceStep0.h"
#import "AddDeviceStep01.h"
#import "AddDeviceStep1AP.h"

@interface AddDeviceFailed ()

@end

@implementation AddDeviceFailed

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceFailedBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceFailedBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceFailedBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceFailedBack addTarget:nil action:@selector(_AddDeviceFailedBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceFailedBack];
    
    _AddDeviceFailedImage = [[UIImageView alloc]init];
    _AddDeviceFailedImage.frame=CGRectMake(0, 0, viewW*0.5, viewW*0.5*750/552);
    _AddDeviceFailedImage.image = [UIImage imageNamed:@"add_failed.png"];
    _AddDeviceFailedImage.center=CGPointMake(self.view.center.x,self.view.center.y*0.8);
    [self.view  addSubview:_AddDeviceFailedImage];
    
    _AddDeviceFailedText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceFailedImage.frame.size.height+_AddDeviceFailedImage.frame.origin.y+diff_top, viewW-diff_x*2, title_size*2)];
    _AddDeviceFailedText.text = NSLocalizedString(@"add_device_failed", nil);
    _AddDeviceFailedText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceFailedText.backgroundColor = [UIColor clearColor];
    _AddDeviceFailedText.textColor = [UIColor grayColor];
    _AddDeviceFailedText.textAlignment = UITextAlignmentCenter;
    _AddDeviceFailedText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceFailedText.numberOfLines = 0;
    [self.view addSubview:_AddDeviceFailedText];
    
    _AddDeviceFailedAP=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceFailedAP.frame=CGRectMake(0,0, viewW*0.6, viewW*0.6*110/484);
    _AddDeviceFailedAP.center=CGPointMake(viewW/2, viewH-diff_bottom*2-viewW*0.6*110/484/2);
    [_AddDeviceFailedAP setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceFailedAP setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceFailedAP.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceFailedAP setTitle:NSLocalizedString(@"add_device_failed_ap", nil) forState: UIControlStateNormal];
    _AddDeviceFailedAP.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceFailedAP addTarget:nil action:@selector(_AddDeviceFailedAPClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceFailedAP];
    
    if ([[self Get_Parameter:@"condifure_way"] compare:@"easy"] == NSOrderedSame) {
        _AddDeviceFailedText.text = NSLocalizedString(@"add_device_failed", nil);
    }
    else{
        _AddDeviceFailedAP.hidden=YES;
        _AddDeviceFailedText.text = NSLocalizedString(@"add_device_failed_ap_note", nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Get Parameter
- (NSString *)Get_Parameter:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    return value;
}

//Back
- (void)_AddDeviceFailedBackClick{
    if ([[self Get_Parameter:@"condifure_way"] compare:@"easy"] == NSOrderedSame) {
        [AddDeviceStep3 back];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        AddDeviceStep1AP *v2 = [[AddDeviceStep1AP alloc] init];
        [self.navigationController pushViewController: v2 animated:true];
    }
}

//Goto AP
- (void)_AddDeviceFailedAPClick{
    
//    AddDeviceStep0 *v = [[AddDeviceStep0 alloc] init];
//    [self.navigationController pushViewController: v animated:true];
//    AddDeviceStep01 *v1 = [[AddDeviceStep01 alloc] init];
//    [self.navigationController pushViewController: v1 animated:true];
    AddDeviceStep1AP *v2 = [[AddDeviceStep1AP alloc] init];
    [self.navigationController pushViewController: v2 animated:true];
    //[self.navigationController popToRootViewControllerAnimated:YES];
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
