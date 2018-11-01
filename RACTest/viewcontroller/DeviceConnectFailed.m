//
//  DeviceConnectFailed.m
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "DeviceConnectFailed.h"
#import "CommanParameter.h"

@interface DeviceConnectFailed ()

@end

@implementation DeviceConnectFailed

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _DeviceConnectFailedBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _DeviceConnectFailedBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_DeviceConnectFailedBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_DeviceConnectFailedBack addTarget:nil action:@selector(_DeviceConnectFailedBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_DeviceConnectFailedBack];
    
    _DeviceConnectFailedImage = [[UIImageView alloc]init];
    _DeviceConnectFailedImage.frame=CGRectMake(0, 0, viewW*0.6, viewW*0.6*750/470);
    _DeviceConnectFailedImage.image = [UIImage imageNamed:@"device_psk_error.png"];
    _DeviceConnectFailedImage.center=self.view.center;
    [self.view  addSubview:_DeviceConnectFailedImage];
    
    _DeviceConnectFailedText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _DeviceConnectFailedBack.frame.size.height+_DeviceConnectFailedBack.frame.origin.y+diff_top, viewW-diff_x*2, title_size*2)];
    _DeviceConnectFailedText.text = NSLocalizedString(@"device_connect_failed_text", nil);
    _DeviceConnectFailedText.font = [UIFont systemFontOfSize: main_help_size];
    _DeviceConnectFailedText.backgroundColor = [UIColor clearColor];
    _DeviceConnectFailedText.textColor = [UIColor grayColor];
    _DeviceConnectFailedText.textAlignment = UITextAlignmentCenter;
    _DeviceConnectFailedText.lineBreakMode = UILineBreakModeWordWrap;
    _DeviceConnectFailedText.numberOfLines = 0;
    [self.view addSubview:_DeviceConnectFailedText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Back
- (void)_DeviceConnectFailedBackClick{
    [self.navigationController popViewControllerAnimated:YES];
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
