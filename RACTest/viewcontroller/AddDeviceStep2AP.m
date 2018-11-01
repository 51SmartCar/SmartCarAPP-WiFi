//
//  AddDeviceStep2AP.m
//  AoSmart
//
//  Created by rakwireless on 16/2/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep2AP.h"
#import "AddDeviceStep3AP.h"
#import "CommanParameter.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "HttpRequest.h"
#import "MBProgressHUD.h"

UIAlertView *waitGetAlertView;
@interface AddDeviceStep2AP ()

@end

@implementation AddDeviceStep2AP
NSMutableArray *_wifiList;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _wifiList=[[NSMutableArray alloc]init];
    _AddDeviceStep2APBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep2APBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep2APBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep2APBack addTarget:nil action:@selector(_AddDeviceStep2APBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep2APBack];
    
    _AddDeviceStep2APTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW-_AddDeviceStep2APBack.frame.size.width-diff_x, title_size)];
    _AddDeviceStep2APTitle.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceStep2APBack.center.y);
    _AddDeviceStep2APTitle.text = NSLocalizedString(@"add_device_step1_ap_title", nil);;
    _AddDeviceStep2APTitle.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep2APTitle.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2APTitle.textColor = [UIColor grayColor];
    _AddDeviceStep2APTitle.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep2APTitle.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2APTitle.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep2APTitle];
    
    _AddDeviceStep2APText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep2APBack.frame.size.height+_AddDeviceStep2APBack.frame.origin.y+diff_top, viewW, title_size)];
    _AddDeviceStep2APText.text = NSLocalizedString(@"add_device_step1_ap_text", nil);;
    _AddDeviceStep2APText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep2APText.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2APText.textColor = [UIColor grayColor];
    _AddDeviceStep2APText.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep2APText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2APText.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep2APText];
    
    _AddDeviceStep2APNote = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep2APText.frame.size.height+_AddDeviceStep2APText.frame.origin.y, viewW-diff_x, add_text_size*5)];
    _AddDeviceStep2APNote.text = NSLocalizedString(@"add_device_step2_ap_note", nil);;
    _AddDeviceStep2APNote.font = [UIFont systemFontOfSize: add_text_size];
    _AddDeviceStep2APNote.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2APNote.textColor = [UIColor grayColor];
    _AddDeviceStep2APNote.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep2APNote.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2APNote.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep2APNote];
    
    UIView *viewAdd=[[UIView alloc]init];
    viewAdd.frame=CGRectMake(0, _AddDeviceStep2APNote.frame.size.height+_AddDeviceStep2APNote.frame.origin.y+10, viewW, viewH-(_AddDeviceStep2APNote.frame.size.height+_AddDeviceStep2APNote.frame.origin.y+10));
    viewAdd.backgroundColor=[UIColor colorWithRed:add_bg/255.0 green:add_bg/255.0 blue:add_bg/255.0 alpha:1.0];
    [self.view addSubview:viewAdd];
    
    _AddDeviceStep2APNetText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, diff_top, (viewW-diff_x*2)/3, title_size)];
    _AddDeviceStep2APNetText.text = NSLocalizedString(@"add_device_step1_wifi", nil);;
    _AddDeviceStep2APNetText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep2APNetText.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2APNetText.textColor = [UIColor grayColor];
    _AddDeviceStep2APNetText.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep2APNetText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2APNetText.numberOfLines = 0;
    [viewAdd addSubview:_AddDeviceStep2APNetText];
    
    _AddDeviceStep2APGetWifi=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep2APGetWifi.frame=CGRectMake(0, 0, add_title_size*90/56, add_title_size);
    _AddDeviceStep2APGetWifi.center=CGPointMake(viewW- diff_x-add_title_size*90/56/2, _AddDeviceStep2APNetText.center.y);
    [_AddDeviceStep2APGetWifi setImage:[UIImage imageNamed:@"apscan.png"] forState:UIControlStateNormal];
    [_AddDeviceStep2APGetWifi addTarget:nil action:@selector(_AddDeviceStep2APGetWifiClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep2APGetWifi];
    
    _AddDeviceStep2APNetField = [[UITextField alloc] initWithFrame:CGRectMake(_AddDeviceStep2APNetText.frame.size.width+_AddDeviceStep2APNetText.frame.origin.x+10, diff_top, (_AddDeviceStep2APGetWifi.frame.origin.x-diff_x*2)*2/3-5, title_size)];
    _AddDeviceStep2APNetField.placeholder = NSLocalizedString(@"add_device_step1_wifi_hint", nil);
    _AddDeviceStep2APNetField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _AddDeviceStep2APNetField.textColor = [UIColor grayColor];
    _AddDeviceStep2APNetField.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2APNetField.borderStyle = UITextBorderStyleNone;
    _AddDeviceStep2APNetField.secureTextEntry = NO;
    _AddDeviceStep2APNetField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewAdd addSubview:_AddDeviceStep2APNetField];
    
    _AddDeviceStep2APPskText = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _AddDeviceStep2APNetText.frame.size.height+_AddDeviceStep2APNetText.frame.origin.y+diff_top, (viewW-diff_x*2)/3, title_size)];
    _AddDeviceStep2APPskText.text = NSLocalizedString(@"add_device_step1_psk", nil);
    _AddDeviceStep2APPskText.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep2APPskText.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2APPskText.textColor = [UIColor lightGrayColor];
    _AddDeviceStep2APPskText.textAlignment = UITextAlignmentLeft;
    _AddDeviceStep2APPskText.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep2APPskText.numberOfLines = 0;
    [viewAdd addSubview:_AddDeviceStep2APPskText];
    
    _AddDeviceStep2APShowPsk=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep2APShowPsk.frame=CGRectMake(0, 0, add_title_size*90/56, add_title_size);
    _AddDeviceStep2APShowPsk.center=CGPointMake(viewW- diff_x-add_title_size*90/56/2, _AddDeviceStep2APPskText.center.y);
    [_AddDeviceStep2APShowPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
    [_AddDeviceStep2APShowPsk addTarget:nil action:@selector(_AddDeviceStep2APShowPskClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep2APShowPsk];
    
    _AddDeviceStep2APPskField = [[UITextField alloc] initWithFrame:CGRectMake(_AddDeviceStep2APPskText.frame.size.width+_AddDeviceStep2APPskText.frame.origin.x+10, _AddDeviceStep2APNetText.frame.size.height+_AddDeviceStep2APNetText.frame.origin.y+diff_top, (_AddDeviceStep2APShowPsk.frame.origin.x-diff_x*2)*2/3-5, title_size)];
    _AddDeviceStep2APPskField.placeholder = NSLocalizedString(@"add_device_step1_psk_hint", nil);
    _AddDeviceStep2APPskField.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    _AddDeviceStep2APPskField.textColor = [UIColor grayColor];
    _AddDeviceStep2APPskField.backgroundColor = [UIColor clearColor];
    _AddDeviceStep2APPskField.borderStyle = UITextBorderStyleNone;
    _AddDeviceStep2APPskField.secureTextEntry = YES;
    _AddDeviceStep2APPskField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewAdd addSubview:_AddDeviceStep2APPskField];
    
    UILabel *line=[[UILabel alloc]init];
    line.frame=CGRectMake(diff_x, _AddDeviceStep2APPskField.frame.origin.y+_AddDeviceStep2APPskField.frame.size.height+10, viewW-2*diff_x, 1);
    line.backgroundColor=[UIColor lightGrayColor];
    [viewAdd addSubview:line];
    
    _AddDeviceStep2APNext=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep2APNext.frame=CGRectMake(0, 0, viewAdd.frame.size.width*0.6, viewAdd.frame.size.width*0.6*110/484);
    _AddDeviceStep2APNext.center=CGPointMake(viewAdd.frame.size.width/2, viewAdd.frame.size.height-diff_bottom*2-viewAdd.frame.size.width*0.6*110/484/2);
    [_AddDeviceStep2APNext setBackgroundImage:[UIImage imageNamed:@"add_next_normal.png"] forState:UIControlStateNormal];
    [_AddDeviceStep2APNext setBackgroundImage:[UIImage imageNamed:@"add_next_pressed.png"] forState:UIControlStateHighlighted];
    _AddDeviceStep2APNext.titleLabel.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    [_AddDeviceStep2APNext setTitle:NSLocalizedString(@"add_device_next", nil) forState: UIControlStateNormal];
    _AddDeviceStep2APNext.titleLabel.textColor=[UIColor redColor];
    [_AddDeviceStep2APNext addTarget:nil action:@selector(_AddDeviceStep2APNextClick) forControlEvents:UIControlEventTouchUpInside];
    [viewAdd  addSubview:_AddDeviceStep2APNext];
    
    _wifiListBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, viewW, viewH)];
    _wifiListBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    _wifiListView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, viewW*0.6, viewH*0.6)];
    _wifiListView.backgroundColor=[UIColor whiteColor];
    _wifiListView.center=self.view.center;
    
    
    _wifiListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewW*0.6,viewH*0.6) style:UITableViewStylePlain];
    _wifiListTable.center=self.view.center;
    _wifiListTable.dataSource = self;
    _wifiListTable.delegate = self;
    _wifiListTable.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    
}

-(void)ShowWifiList{
    [self.view addSubview:_wifiListBgView];
    [_wifiListBgView addSubview:_wifiListView];
    [_wifiListBgView  addSubview:_wifiListTable];
}

-(void)HideWifiList{
    [_wifiListBgView removeFromSuperview];
    [_wifiListBgView  removeFromSuperview];
    [_wifiListBgView removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_wifiList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(0, 0, self.view.frame.size.width*0.6, title_size);
    cell.textLabel.text=_wifiList[indexPath.row];
    cell.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _AddDeviceStep2APNetField.text=_wifiList[indexPath.row];
    _AddDeviceStep2APPskField.text=[self Get_Parameter:_AddDeviceStep2APNetField.text];
    [self HideWifiList];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Back
- (void)_AddDeviceStep2APBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//Next
- (void)_AddDeviceStep2APNextClick{
    waitGetAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"add_device_step2_ap_config_title", nil)
                                                  message:NSLocalizedString(@"add_device_step2_ap_config_text", nil)
                                                 delegate:nil
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil, nil];
    [waitGetAlertView show];
    
    //Save psk
    [self Save_Parameter:_AddDeviceStep2APPskField.text :_AddDeviceStep2APNetField.text];
    [self Save_Parameter:_AddDeviceStep2APNetField.text :@"configure_ssid_ap"];
    
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(ConfigureDevice)
                                                     object:nil];
    [httpThread start];
}

-(void)ConfigureDevice{
    NSString *URL=[[NSString alloc]initWithFormat:@"http://192.168.100.1:80/param.cgi?action=update&group=wifi&sta_ssid=%@&sta_auth_key=%@",_AddDeviceStep2APNetField.text,_AddDeviceStep2APPskField.text];
    HttpRequest* _HttpRequest = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"POST" andUserName:@"admin" andPassword:@"admin"];
    if (_HttpRequest.StatusCode!=200) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitGetAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [self showAllTextDialog:NSLocalizedString(@"add_device_step2_ap_config_failed", nil)];
        });
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitGetAlertView dismissWithClickedButtonIndex:0 animated:YES];
            AddDeviceStep3AP *v = [[AddDeviceStep3AP alloc] init];
            [self.navigationController pushViewController: v animated:true];
            
        });
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

//Connect
- (void)_AddDeviceStep2APGetWifiClick{
    waitGetAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"add_device_step2_ap_scan_title", nil)
                                                    message:NSLocalizedString(@"add_device_step2_ap_scan_text", nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [waitGetAlertView show];
    
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(GetWifiList)
                                                     object:nil];
    [httpThread start];
}

//-(void)getWifiList{
//    NSString *URL=[[NSString alloc]initWithFormat:@"/server.command?command=get_wifilist"];
//    RKRequest *http_request=[[RKRequest alloc]init];
//    http_request=[RKRequest TCPRequstWithIP:@"192.168.100.1" Port:80 Path:URL Name:@"admin" Password:@"admin" andBody:nil andMethod:@"GET"];
//    NSLog(@"====>%@",http_request.Message);
//    if(http_request.StatusCode==200)
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [waitGetAlertView dismissWithClickedButtonIndex:0 animated:YES];
//        });
//    }
//    else
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [waitGetAlertView dismissWithClickedButtonIndex:0 animated:YES];
//            [self showAllTextDialog:NSLocalizedString(@"add_device_step2_ap_scan_failed", nil)];
//        });
//    }
//}

int getTime;
-(void)GetWifiList{
    getTime=3;
    while (getTime>0) {
        HttpRequest* _HttpRequest = [HttpRequest HTTPRequestWithUrl:@"http://192.168.100.1:80/server.command?command=get_wifilist" andData:nil andMethod:@"GET" andUserName:@"admin" andPassword:@"admin"];
        if (_HttpRequest.StatusCode!=200) {
            if (getTime==1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [waitGetAlertView dismissWithClickedButtonIndex:0 animated:YES];
                    [self showAllTextDialog:NSLocalizedString(@"add_device_step2_ap_scan_failed", nil)];
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *key=@"\"wifimessage\":";
                NSRange range=[_HttpRequest.ResponseString rangeOfString:key];
                if (range.location != NSNotFound) {
                    int i=(int)range.location;
                    NSString *jsonString=[_HttpRequest.ResponseString substringFromIndex:i+key.length];
                    NSLog(@"%@",jsonString);
                    [self parseJsonString:jsonString];
                    if ([_wifiList count]>0) {
                        [self ShowWifiList];
                    }
                }else{
                    return;
                }

                [waitGetAlertView dismissWithClickedButtonIndex:0 animated:YES];
            });
            getTime=0;
            break;
        }
        NSLog(@"_HttpRequest:StatusCode=%d",_HttpRequest.StatusCode);
        NSLog(@"_HttpRequest:length=%d",_HttpRequest.ContentLength);
        NSLog(@"_HttpRequest:Connection=%@",_HttpRequest.Connection);
        NSLog(@"_HttpRequest:ContentType=%@",_HttpRequest.ContentType);
        NSLog(@"_HttpRequest:Server=%@",_HttpRequest.Server);
        getTime--;
    }
}

-(void)parseJsonString:(NSString *)str{
    [_wifiList removeAllObjects];
    NSString *srcStr=str;
    NSString *keyStr=@"\"ssid\":\"";
    NSString *endStr=@"\"";
    while(true){
    NSRange range=[srcStr rangeOfString:keyStr];
    if (range.location != NSNotFound) {
        int i=(int)range.location;
        srcStr=[srcStr substringFromIndex:i+keyStr.length];
        NSRange range1=[srcStr rangeOfString:endStr];
        if (range1.location != NSNotFound) {
            int j=(int)range1.location;
            NSRange diffRange=NSMakeRange(0, j);
            NSString *_ssid=[srcStr substringWithRange:diffRange];
            [_wifiList addObject:_ssid];
        }
        else{
            break;
        }
    }else{
        break;
    }
    }
}

-(void) parseJsonData:(NSData *)data
{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"json parse failed \r\n");
        return;
    }
    NSArray *songArray = [json objectForKey:@"ssid"];
    NSLog(@"song collection: %@\r\n",songArray);

    NSDictionary *song = [songArray objectAtIndex:0];
    NSLog(@"song info: %@\t\n",song);
}

//Show password
- (void)_AddDeviceStep2APShowPskClick{
    if (_AddDeviceStep2APPskField.secureTextEntry) {
        _AddDeviceStep2APPskField.secureTextEntry = NO;
        [_AddDeviceStep2APShowPsk setImage:[UIImage imageNamed:@"psk_open.png"] forState:UIControlStateNormal];
    }
    else{
        _AddDeviceStep2APPskField.secureTextEntry = YES;
        [_AddDeviceStep2APShowPsk setImage:[UIImage imageNamed:@"psk_close.png"] forState:UIControlStateNormal];
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
    if (textField == _AddDeviceStep2APNetField) {
        [_AddDeviceStep2APPskField becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //隐藏键盘
    [_AddDeviceStep2APNetField resignFirstResponder];
    [_AddDeviceStep2APPskField resignFirstResponder];
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
