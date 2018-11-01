//
//  DeviceConnect.m
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "DeviceConnect.h"
#import "DevicePlay.h"
#import "MBProgressHUD.h"
#import "remote.h"
#import "HttpRequest.h"


NSString *deviceConnectId;
NSString *deviceConnectIp;
NSString *deviceConnectName;
int deviceConnectPort=80;

@interface DeviceConnect ()
{
    nabto_tunnel_state_t nabtoConnectStatus;
    nabto_tunnel_t tunnel_80;
    int nabto_remote_count;
    NSString *pwdstrs;
}
@end

@implementation DeviceConnect

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self Save_Parameter:@"1" :@"screen"];
    [self Save_Parameter:@"h264" :@"videotype"];

    pwdstrs = @"admin";//密码写死
    
 
    deviceConnectId=[self Get_Parameter:@"play_device_id"];
    deviceConnectIp=[self Get_Parameter:@"play_device_ip"];
    deviceConnectName=[self Get_Parameter:@"play_device_name"];
    
  //  [self _DeviceConnectBtnClick];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//Back 关闭
- (void)_DeviceConnectBackClick{
    if ([deviceConnectIp compare:@"127.0.0.1"]==NSOrderedSame){
        CloseTunnel(&tunnel_80);
        nabtoConnectStatus = NTCS_CLOSED;
    }
}


//Connect
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

- (void)_DeviceConnectBtnClick{
    NSString *key=[NSString stringWithFormat:@"Password=%@",deviceConnectId];
    [self Save_Parameter:pwdstrs :key];
    //get version
    NSString *URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=get_version",deviceConnectIp,deviceConnectPort];
    HttpRequest* http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"GET" andUserName:@"admin" andPassword:pwdstrs];
    if(http_request.StatusCode==200)
    {
        http_request.ResponseString=[http_request.ResponseString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *version=[self parseJsonString:http_request.ResponseString];
        if ([version compare:@""]==NSOrderedSame) {
            version=http_request.ResponseString;
        }
        NSLog(@"version=%@",version);
        [self Save_Parameter:version :@"version"];
    }
    
    
    //get fps
    URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=get_max_fps&type=h264&pipe=0",deviceConnectIp,deviceConnectPort];
    http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"GET" andUserName:@"admin" andPassword:pwdstrs];
    
    NSLog(@"====>%d",http_request.StatusCode);
    if(http_request.StatusCode==200)
    {
        http_request.ResponseString=[http_request.ResponseString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"====>%@",http_request.ResponseString);
        NSString *value=@"\"value\":\"";
        NSRange range=[http_request.ResponseString rangeOfString:value];
        if (range.location != NSNotFound) {
            NSString *fps=[http_request.ResponseString substringFromIndex:(range.location+value.length)];
            NSRange range1=[http_request.ResponseString rangeOfString:@"\""];
            if (range1.location != NSNotFound){
                [self Save_Parameter:[fps substringToIndex:(range1.location+1)] :@"fps"];
                NSLog(@"fps=%@",[fps substringToIndex:(range1.location+1)]);
            }
            else{
                [self Save_Parameter:@"20" :@"fps"];
            }
        }
        else{
            [self Save_Parameter:@"20" :@"fps"];
        }
    }
    else{
        [self Save_Parameter:@"20" :@"fps"];
    }
    DevicePlay *v = [[DevicePlay alloc] init];
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


@end
