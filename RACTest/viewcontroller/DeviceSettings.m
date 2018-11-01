//
//  DeviceSettings.m
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "DeviceSettings.h"
#import "CommanParameter.h"
#import "DeviceData.h"
#import "DeviceInfo.h"
#import "MBProgressHUD.h"
#import "CommonFunc.h"
#import "DevicePlayViewController.h"
#import "HttpRequest.h"

UIAlertView *waitSettingsAlertView;
@interface DeviceSettings ()
{
    NSString* deviceConnectingId;
    NSString* deviceConnectingIp;
    NSString* deviceConnectingpsk;
    int deviceConnectingPort;
    BOOL _isSettingsOk;
    NSString *version;
    BOOL _isLx520;
}
@end

@implementation DeviceSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
     _isLx520=YES;
    
    version=[self Get_Parameter:@"version"];
    version= [version stringByReplacingOccurrencesOfString:@"\n" withString:@"   "];
    if ([version.lowercaseString containsString:@"wifiv"]) {
        _isLx520=NO;//图传模块
    }
    
    _DeviceSettingsBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _DeviceSettingsBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_DeviceSettingsBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_DeviceSettingsBack addTarget:nil action:@selector(_DeviceSettingsBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_DeviceSettingsBack];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _DeviceSettingsBack.frame.size.height+_DeviceSettingsBack.frame.origin.y+diff_top,viewW, viewH-_DeviceSettingsBack.frame.size.height-_DeviceSettingsBack.frame.origin.y-diff_top)];
    scrollView.contentSize = CGSizeMake(viewW, viewH*1.6);//滚动条视图内容范围的大小
    scrollView.showsHorizontalScrollIndicator = FALSE;//水平滚动条是否显示
    scrollView.showsVerticalScrollIndicator = FALSE;//垂直滚动条是否显示
    [self.view addSubview:scrollView];
    
    _DeviceSettingsImage = [[UIImageView alloc]init];
    _DeviceSettingsImage.frame=CGRectMake(0, 0, viewW*0.35, viewW*0.35);
    _DeviceSettingsImage.center=CGPointMake(viewW/2, _DeviceSettingsBack.frame.origin.y+diff_top*2+viewW*0.35/2);
    _DeviceSettingsImage.image = [UIImage imageNamed:@"config_device.png"];
    [scrollView  addSubview:_DeviceSettingsImage];
    
    
    //版本信息
    _DeviceSettingsVersionTitle=[[UILabel alloc]init];
    _DeviceSettingsVersionTitle.frame=CGRectMake(diff_x, _DeviceSettingsImage.frame.size.height+_DeviceSettingsImage.frame.origin.y+diff_top, viewW-2*diff_x, title_size);
    _DeviceSettingsVersionTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    _DeviceSettingsVersionTitle.text=NSLocalizedString(@"device_settings_version_title", nil);
    [scrollView addSubview:_DeviceSettingsVersionTitle];
    
    UILabel *line0=[[UILabel alloc]init];
    line0.frame=CGRectMake(diff_x, _DeviceSettingsVersionTitle.frame.origin.y+_DeviceSettingsVersionTitle.frame.size.height+10, viewW-2*diff_x, 1);
    line0.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:line0];
    
    _DeviceSettingsAppVersionText=[[UILabel alloc]init];
    _DeviceSettingsAppVersionText.frame=CGRectMake(diff_x, line0.frame.size.height+line0.frame.origin.y+diff_top, viewW-2*diff_x, title_size);
    _DeviceSettingsAppVersionText.text=[NSString stringWithFormat:@"%@  %@",NSLocalizedString(@"device_settings_version_app", nil),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [scrollView addSubview:_DeviceSettingsAppVersionText];
    
    UILabel *lineVer=[[UILabel alloc]init];
    lineVer.frame=CGRectMake(diff_x, _DeviceSettingsAppVersionText.frame.origin.y+_DeviceSettingsAppVersionText.frame.size.height+10, viewW-2*diff_x, 1);
    lineVer.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:lineVer];
    
    _DeviceSettingsFwVersionText=[[UILabel alloc]init];
    _DeviceSettingsFwVersionText.frame=CGRectMake(diff_x, lineVer.frame.size.height+lineVer.frame.origin.y+diff_top, viewW-2*diff_x, title_size);
    _DeviceSettingsFwVersionText.text=[NSString stringWithFormat:@"%@  %@",NSLocalizedString(@"device_settings_version_fw", nil),version];
    [scrollView addSubview:_DeviceSettingsFwVersionText];
    
    UILabel *lineVerText=[[UILabel alloc]init];
    lineVerText.frame=CGRectMake(diff_x, _DeviceSettingsFwVersionText.frame.origin.y+_DeviceSettingsFwVersionText.frame.size.height+10, viewW-2*diff_x, 1);
    lineVerText.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:lineVerText];
    
    
    //密码修改
    _DeviceSettingsPskTitle=[[UILabel alloc]init];
    _DeviceSettingsPskTitle.frame=CGRectMake(diff_x, lineVerText.frame.size.height+lineVerText.frame.origin.y+diff_top*2, viewW-2*diff_x, title_size);
    _DeviceSettingsPskTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    _DeviceSettingsPskTitle.text=NSLocalizedString(@"device_settings_psk_title", nil);
    [scrollView addSubview:_DeviceSettingsPskTitle];
    
    UILabel *linePsk=[[UILabel alloc]init];
    linePsk.frame=CGRectMake(diff_x, _DeviceSettingsPskTitle.frame.origin.y+_DeviceSettingsPskTitle.frame.size.height+10, viewW-2*diff_x, 1);
    linePsk.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:linePsk];
    
    _DeviceSettingsPskField = [[UITextField alloc] initWithFrame:CGRectMake(diff_x, linePsk.frame.size.height+linePsk.frame.origin.y+diff_top, (viewW-add_text_size*90/56-diff_x*2)-5, title_size)];
    _DeviceSettingsPskField.placeholder = NSLocalizedString(@"video_settings_psk_hint", nil);
    _DeviceSettingsPskField.textColor = [UIColor grayColor];
    _DeviceSettingsPskField.backgroundColor = [UIColor clearColor];
    _DeviceSettingsPskField.borderStyle = UITextBorderStyleNone;
    _DeviceSettingsPskField.secureTextEntry = YES;
    _DeviceSettingsPskField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_DeviceSettingsPskField];
    
    _DeviceSettingsShowPsk=[UIButton buttonWithType:UIButtonTypeCustom];
    _DeviceSettingsShowPsk.frame=CGRectMake(0, 0, add_text_size*90/56, add_text_size);
    _DeviceSettingsShowPsk.center=CGPointMake(viewW- diff_x-add_text_size*90/56/2, _DeviceSettingsPskField.center.y);
    [_DeviceSettingsShowPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
    [_DeviceSettingsShowPsk addTarget:nil action:@selector(_DeviceSettingsShowPskClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView  addSubview:_DeviceSettingsShowPsk];
    
    UILabel *line=[[UILabel alloc]init];
    line.frame=CGRectMake(diff_x, _DeviceSettingsPskField.frame.origin.y+_DeviceSettingsPskField.frame.size.height+10, viewW-2*diff_x, 1);
    line.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:line];
    
    _DeviceSettingsNewPskField = [[UITextField alloc] initWithFrame:CGRectMake(diff_x, line.frame.size.height+line.frame.origin.y+diff_top, (viewW-add_text_size*90/56-diff_x*2)-5, title_size)];
    _DeviceSettingsNewPskField.placeholder = NSLocalizedString(@"video_settings_confirm_psk_hint", nil);
    _DeviceSettingsNewPskField.textColor = [UIColor grayColor];
    _DeviceSettingsNewPskField.backgroundColor = [UIColor clearColor];
    _DeviceSettingsNewPskField.borderStyle = UITextBorderStyleNone;
    _DeviceSettingsNewPskField.secureTextEntry = YES;
    _DeviceSettingsNewPskField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_DeviceSettingsNewPskField];
    
    _DeviceSettingsShowNewPsk=[UIButton buttonWithType:UIButtonTypeCustom];
    _DeviceSettingsShowNewPsk.frame=CGRectMake(0, 0, add_text_size*90/56, add_text_size);
    _DeviceSettingsShowNewPsk.center=CGPointMake(viewW- diff_x-add_text_size*90/56/2, _DeviceSettingsNewPskField.center.y);
    [_DeviceSettingsShowNewPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
    [_DeviceSettingsShowNewPsk addTarget:nil action:@selector(_DeviceSettingsShowNewPskClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView  addSubview:_DeviceSettingsShowNewPsk];
    
    UILabel *line1=[[UILabel alloc]init];
    line1.frame=CGRectMake(diff_x, _DeviceSettingsNewPskField.frame.origin.y+_DeviceSettingsNewPskField.frame.size.height+10, viewW-2*diff_x, 1);
    line1.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:line1];
    
    _DeviceSettingsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _DeviceSettingsBtn.frame=CGRectMake(0,0, viewW*0.6, viewW*0.6*110/484);
    _DeviceSettingsBtn.center=CGPointMake(viewW/2, line1.frame.origin.y+line.frame.size.height+diff_top+_DeviceSettingsBtn.frame.size.height*0.5+viewW*0.6*110/484/2);
    [_DeviceSettingsBtn setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_DeviceSettingsBtn setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _DeviceSettingsBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_DeviceSettingsBtn setTitle:NSLocalizedString(@"video_settings_btn", nil) forState: UIControlStateNormal];
    _DeviceSettingsBtn.titleLabel.textColor=[UIColor redColor];
    [_DeviceSettingsBtn addTarget:nil action:@selector(_DeviceSettingsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView  addSubview:_DeviceSettingsBtn];
    
    //参数设置    
    _DeviceSettingsParametersTitle=[[UILabel alloc]init];
    _DeviceSettingsParametersTitle.frame=CGRectMake(diff_x, _DeviceSettingsBtn.frame.origin.y+_DeviceSettingsBtn.frame.size.height+diff_top*2, viewW-2*diff_x, title_size);
    _DeviceSettingsParametersTitle.text=NSLocalizedString(@"device_settings_parameter_title", nil);
    _DeviceSettingsParametersTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [scrollView addSubview:_DeviceSettingsParametersTitle];
    
    UILabel *lineParameter=[[UILabel alloc]init];
    lineParameter.frame=CGRectMake(diff_x, _DeviceSettingsParametersTitle.frame.origin.y+_DeviceSettingsParametersTitle.frame.size.height+10, viewW-2*diff_x, 1);
    lineParameter.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:lineParameter];
    
    //FPS
    int FieldWidth=100;
    _DeviceSettingsFPSText=[[UILabel alloc]init];
    _DeviceSettingsFPSText.frame=CGRectMake(diff_x, lineParameter.frame.origin.y+lineParameter.frame.size.height+diff_top, FieldWidth, title_size);
    _DeviceSettingsFPSText.text=NSLocalizedString(@"device_settings_parameter_fps", nil);
    [scrollView addSubview:_DeviceSettingsFPSText];
    
    _DeviceSettingsFPSField = [[UITextField alloc] initWithFrame:CGRectMake(diff_x+FieldWidth, lineParameter.frame.size.height+lineParameter.frame.origin.y+diff_top, viewW-2*diff_x-FieldWidth, title_size)];
    _DeviceSettingsFPSField.textColor = [UIColor blackColor];
    _DeviceSettingsFPSField.placeholder = @"0~30";
    _DeviceSettingsFPSField.backgroundColor = [UIColor clearColor];
    _DeviceSettingsFPSField.borderStyle = UITextBorderStyleNone;
    _DeviceSettingsFPSField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_DeviceSettingsFPSField];
    
    UILabel *lineFPS=[[UILabel alloc]init];
    lineFPS.frame=CGRectMake(diff_x, _DeviceSettingsFPSText.frame.origin.y+_DeviceSettingsFPSText.frame.size.height+10, viewW-2*diff_x, 1);
    lineFPS.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:lineFPS];
    
    //Quality
    _DeviceSettingsQualityText=[[UILabel alloc]init];
    _DeviceSettingsQualityText.frame=CGRectMake(diff_x, lineFPS.frame.origin.y+lineFPS.frame.size.height+diff_top, FieldWidth, title_size);
    _DeviceSettingsQualityText.text=NSLocalizedString(@"device_settings_parameter_quality", nil);
    [scrollView addSubview:_DeviceSettingsQualityText];
    
    _DeviceSettingsQualityField = [[UITextField alloc] initWithFrame:CGRectMake(diff_x+FieldWidth, lineFPS.frame.size.height+lineFPS.frame.origin.y+diff_top, viewW-2*diff_x-FieldWidth, title_size)];
    _DeviceSettingsQualityField.textColor = [UIColor blackColor];
    _DeviceSettingsQualityField.placeholder = @"0~52";
    _DeviceSettingsQualityField.backgroundColor = [UIColor clearColor];
    _DeviceSettingsQualityField.borderStyle = UITextBorderStyleNone;
    _DeviceSettingsQualityField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_DeviceSettingsQualityField];
    
    UILabel *lineQuality=[[UILabel alloc]init];
    lineQuality.frame=CGRectMake(diff_x, _DeviceSettingsQualityText.frame.origin.y+_DeviceSettingsQualityText.frame.size.height+10, viewW-2*diff_x, 1);
    lineQuality.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:lineQuality];
    
    //GOP
    _DeviceSettingsGOPText=[[UILabel alloc]init];
    _DeviceSettingsGOPText.frame=CGRectMake(diff_x, lineQuality.frame.origin.y+lineQuality.frame.size.height+diff_top, FieldWidth, title_size);
    _DeviceSettingsGOPText.text=NSLocalizedString(@"device_settings_parameter_gop", nil);
    [scrollView addSubview:_DeviceSettingsGOPText];
    
    _DeviceSettingsGOPField = [[UITextField alloc] initWithFrame:CGRectMake(diff_x+FieldWidth, lineQuality.frame.size.height+lineQuality.frame.origin.y+diff_top, viewW-2*diff_x-FieldWidth, title_size)];
    _DeviceSettingsGOPField.textColor = [UIColor blackColor];
    _DeviceSettingsGOPField.placeholder = @"0~300";
    _DeviceSettingsGOPField.backgroundColor = [UIColor clearColor];
    _DeviceSettingsGOPField.borderStyle = UITextBorderStyleNone;
    _DeviceSettingsGOPField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [scrollView addSubview:_DeviceSettingsGOPField];
    
    UILabel *lineGOP=[[UILabel alloc]init];
    lineGOP.frame=CGRectMake(diff_x, _DeviceSettingsGOPText.frame.origin.y+_DeviceSettingsGOPText.frame.size.height+10, viewW-2*diff_x, 1);
    lineGOP.backgroundColor=[UIColor lightGrayColor];
    [scrollView addSubview:lineGOP];
    
    _DeviceSettingsParameterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _DeviceSettingsParameterBtn.frame=CGRectMake(0,0, viewW*0.6, viewW*0.6*110/484);
    _DeviceSettingsParameterBtn.center=CGPointMake(viewW/2, lineGOP.frame.origin.y+lineGOP.frame.size.height+diff_top+_DeviceSettingsParameterBtn.frame.size.height*0.5+viewW*0.6*110/484/2);
    [_DeviceSettingsParameterBtn setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_DeviceSettingsParameterBtn setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _DeviceSettingsParameterBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_DeviceSettingsParameterBtn setTitle:NSLocalizedString(@"video_settings_btn", nil) forState: UIControlStateNormal];
    _DeviceSettingsParameterBtn.titleLabel.textColor=[UIColor redColor];
    [_DeviceSettingsParameterBtn addTarget:nil action:@selector(_DeviceSettingsParameterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView  addSubview:_DeviceSettingsParameterBtn];

    if (_isLx520) {
        _DeviceSettingsParametersTitle.hidden=YES;
        _DeviceSettingsFPSText.hidden=YES;
        _DeviceSettingsFPSField.hidden=YES;
        _DeviceSettingsQualityText.hidden=YES;
        _DeviceSettingsQualityField.hidden=YES;
        _DeviceSettingsGOPText.hidden=YES;
        _DeviceSettingsGOPField.hidden=YES;
        _DeviceSettingsParameterBtn.hidden=YES;
        lineParameter.hidden=YES;
        lineFPS.hidden=YES;
        lineQuality.hidden=YES;
        lineGOP.hidden=YES;
    }
    
    deviceConnectingId=[self Get_Parameter:@"play_device_id"];
    deviceConnectingIp=[self Get_Parameter:@"play_device_ip"];
    NSString *key=[NSString stringWithFormat:@"Password=%@",deviceConnectingId];
    deviceConnectingpsk=[self Get_Parameter:key];
    if ([deviceConnectingIp compare:@"127.0.0.1"]==NSOrderedSame) {
        deviceConnectingPort=REMOTEPORTMAPPING;
    }
    else{
        deviceConnectingPort=80;
    }
    
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(getDeviceParameters)
                                                     object:nil];
    [httpThread start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//Device Settings
- (void)_DeviceSettingsBtnClick{
    _isSettingsOk=NO;
    if (_DeviceSettingsPskField.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"video_settings_psk_text", nil)];
        return;
    }
    if (_DeviceSettingsNewPskField.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"video_settings_new_psk_text", nil)];
        return;
    }
    waitSettingsAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"device_modify_indicator_title", nil)
                                                                         message:NSLocalizedString(@"device_modify_indicator_text", nil)
                                                                        delegate:nil
                                                               cancelButtonTitle:nil
                                                               otherButtonTitles:nil, nil];
    [waitSettingsAlertView show];
    
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(modifyDevicePassword)
                                                     object:nil];
    [httpThread start];
    
}

- (void)_DeviceSettingsParameterBtnClick{
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(modifyDeviceParameters)
                                                     object:nil];
    [httpThread start];
    
}


-(void)modifyDevicePassword{
    NSString *URL=[[NSString alloc]initWithFormat:@"http://%@:%d/param.cgi?action=update&group=login&username=admin&password=%@",deviceConnectingIp,deviceConnectingPort,_DeviceSettingsNewPskField.text];
    HttpRequest *http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:_DeviceSettingsPskField.text];
    NSLog(@"====>%d",http_request.StatusCode);
    if(http_request.StatusCode==200)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitSettingsAlertView dismissWithClickedButtonIndex:0 animated:YES];
            NSString *key=[NSString stringWithFormat:@"Password=%@",deviceConnectingId];
            [self Save_Parameter:_DeviceSettingsNewPskField.text :key];
            _isSettingsOk=YES;
            [self showAllTextDialog:NSLocalizedString(@"video_settings_new_psk_success", nil)];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitSettingsAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [self showAllTextDialog:NSLocalizedString(@"video_settings_new_psk_error", nil)];
        });
    }
}

-(void)modifyDeviceParameters{
    if (_DeviceSettingsFPSText.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"device_settings_parameter_fps_empty", nil)];
        return;
    }
    if (_DeviceSettingsQualityText.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"device_settings_parameter_quality_empty", nil)];
        return;
    }
    if (_DeviceSettingsGOPText.text.length==0) {
        [self showAllTextDialog:NSLocalizedString(@"device_settings_parameter_gop_empty", nil)];
        return;
    }
    
    NSString *URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=set_max_fps&type=h264&pipe=0&value=%@",deviceConnectingIp,deviceConnectingPort,_DeviceSettingsFPSField.text];
    HttpRequest *http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:deviceConnectingpsk];
    if(http_request.StatusCode==200)
    {
        URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=set_enc_quality&type=h264&pipe=0&value=%@",deviceConnectingIp,deviceConnectingPort,_DeviceSettingsQualityField.text];
        http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:deviceConnectingpsk];
        if(http_request.StatusCode==200){
            URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=set_enc_gop&type=h264&pipe=0&value=%@",deviceConnectingIp,deviceConnectingPort,_DeviceSettingsGOPField.text];
            http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:deviceConnectingpsk];
            if(http_request.StatusCode==200){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAllTextDialog:NSLocalizedString(@"device_settings_parameter_success", nil)];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showAllTextDialog:NSLocalizedString(@"device_settings_parameter_gop_failed", nil)];
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAllTextDialog:NSLocalizedString(@"device_settings_parameter_quality_failed", nil)];
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAllTextDialog:NSLocalizedString(@"device_settings_parameter_fps_failed", nil)];
        });
    }
}


-(void)getDeviceParameters{
    NSString *URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=get_max_fps&type=h264&pipe=0",deviceConnectingIp,deviceConnectingPort];
    HttpRequest *http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:deviceConnectingpsk];
    if(http_request.StatusCode==200){
        _DeviceSettingsFPSField.text=[self parseJsonString:[http_request.ResponseString stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    
    URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=get_enc_quality&type=h264&pipe=0",deviceConnectingIp,deviceConnectingPort];
    http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:deviceConnectingpsk];
    if(http_request.StatusCode==200){
        _DeviceSettingsQualityField.text=[self parseJsonString:[http_request.ResponseString stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    
    URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=get_enc_gop&type=h264&pipe=0",deviceConnectingIp,deviceConnectingPort];
    http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:deviceConnectingpsk];
    if(http_request.StatusCode==200){
        _DeviceSettingsGOPField.text=[self parseJsonString:[http_request.ResponseString stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
}

-(NSString*)parseJsonString:(NSString *)srcStr{
    NSString *Str=@"";
    NSString *keyStr=@"\"value\":\"";
    NSString *endStr=@"\"";
    NSRange range=[srcStr rangeOfString:keyStr];
    if (range.location != NSNotFound) {
        int i=(int)range.location;
        srcStr=[srcStr substringFromIndex:i+keyStr.length];
        NSRange range1=[srcStr rangeOfString:endStr];
        if (range1.location != NSNotFound) {
            int j=(int)range1.location;
            NSRange diffRange=NSMakeRange(0, j);
            Str=[srcStr substringWithRange:diffRange];
        }
    }
    return Str;
}

//Back
- (void)_DeviceSettingsBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//Show Psk
- (void)_DeviceSettingsShowPskClick{
    if (_DeviceSettingsPskField.secureTextEntry) {
        _DeviceSettingsPskField.secureTextEntry = NO;
        [_DeviceSettingsShowPsk setImage:[UIImage imageNamed:@"psk_open.png"] forState:UIControlStateNormal];
    }
    else{
        _DeviceSettingsPskField.secureTextEntry = YES;
        [_DeviceSettingsShowPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
    }
}

//Show New Psk
- (void)_DeviceSettingsShowNewPskClick{
    if (_DeviceSettingsNewPskField.secureTextEntry) {
        _DeviceSettingsNewPskField.secureTextEntry = NO;
        [_DeviceSettingsShowNewPsk setImage:[UIImage imageNamed:@"psk_open.png"] forState:UIControlStateNormal];
    }
    else{
        _DeviceSettingsNewPskField.secureTextEntry = YES;
        [_DeviceSettingsShowNewPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
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
        if (_isSettingsOk) {
            _isSettingsOk=NO;
            [DevicePlayViewController back];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _DeviceSettingsPskField) {
        [_DeviceSettingsNewPskField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [_DeviceSettingsPskField resignFirstResponder];
    [_DeviceSettingsNewPskField resignFirstResponder];
    [_DeviceSettingsFPSField resignFirstResponder];
    [_DeviceSettingsQualityField resignFirstResponder];
    [_DeviceSettingsGOPField resignFirstResponder];
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
