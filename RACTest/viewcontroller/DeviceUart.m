//
//  DeviceUart.m
//  AoSmart
//
//  Created by rakwireless on 16/8/25.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "DeviceUart.h"
#import "CommonFunc.h"
#import "MBProgressHUD.h"
#import "GCDAsyncSocket.h"


Byte keep_alive[] = {0x01,0x55,0x7E,0x00,0x01,0x00,0x00,0x00,0x7E};
Byte start[] = {0x01,0x55};

@interface DeviceUart ()
{
    NSString* deviceConnectingId;
    NSString* deviceConnectingIp;
    NSString* deviceConnectingpsk;
    NSString* deviceVersion;
    int deviceConnectingPort;
    GCDAsyncSocket* GCDUartSocket;//用于建立TCP socket
    bool _UartIsClose;
    bool _isLx520;
}
@end

@implementation DeviceUart

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    _UartIsClose=NO;
    
   
    deviceConnectingId=[self Get_Parameter:@"play_device_id"];
    deviceConnectingIp=[self Get_Parameter:@"play_device_ip"];
    NSString *key=[NSString stringWithFormat:@"Password=%@",deviceConnectingId];
    deviceConnectingpsk=[self Get_Parameter:key];
    deviceVersion=[self Get_Parameter:@"version"];
    deviceVersion=deviceVersion.lowercaseString;
    if ([deviceVersion containsString:@"wifiv"]) {//HDMI模块
        _isLx520=NO;
    }
    else{//LX520模块
        _isLx520=YES;
    }
    
    if ([deviceConnectingIp compare:@"127.0.0.1"]==NSOrderedSame) {
        deviceConnectingPort=REMOTEPORTMAPPING;
    }
    else{
        if (_isLx520) {
            deviceConnectingPort=80;
        }
        else{
            deviceConnectingPort=1008;
        }
    }
    if (_isLx520){
        GCDUartSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];//建立与设备 TCP 80端口连接，用于串口透传数据发送与接收
        NSError *err;
        [GCDUartSocket connectToHost:deviceConnectingIp onPort:deviceConnectingPort error:&err];
        if (err != nil)
        {
            NSLog(@"error = %@",err);
            [self showAllTextDialog:NSLocalizedString(@"uart_connect_failed", nil)];
            return;
        }
        
        [self showAllTextDialog:NSLocalizedString(@"uart_connect_success", nil)];

        [NSThread detachNewThreadSelector:@selector(sendPacket) toTarget:self withObject:nil];//心跳

        [GCDUartSocket readDataWithTimeout:-1 tag:0];

//        [self DeviceUartSendBtnClick];

    }
    
}

//心跳
- (void)sendPacket
{
    while(!_UartIsClose){
        NSData *data = [NSData dataWithBytes:keep_alive length:sizeof(keep_alive)];
        [GCDUartSocket writeData:data withTimeout:1.0 tag:100];
        [NSThread sleepForTimeInterval:10.0f];
    }
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    if([sock isEqual:GCDUartSocket]){
        if(data.length > 2)
        {
            NSData *sd =[data subdataWithRange:NSMakeRange(2, data.length-2)];
            
      
            NSLog(@"data.length=%d",(int)data.length);
            //接收到数据，在此解析
 
        }
        [GCDUartSocket readDataWithTimeout:-1 tag:0];
    }
}

- (void)DeviceUartSendBtnClick{
    
    Byte carData[7] = {0x7E,0x01,0x01,0x01,0x01,0x90,0x7E};

    NSMutableData *mData = [[NSMutableData alloc] init];
    NSData *adata = [[NSData alloc] initWithBytes:start length:2];
    NSData *bdata = [[NSData alloc] initWithBytes:carData length: sizeof(carData)];
    [mData appendData:adata];
    [mData appendData:bdata];
    
    NSData *subData =[mData subdataWithRange:NSMakeRange(0, mData.length)];
    
    [GCDUartSocket writeData:subData withTimeout:1.0 tag:100];

}

//Get Parameter
- (NSString *)Get_Parameter:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    return value;
}

//Back
- (void)_DeviceUartBackClick{
    _UartIsClose=YES;
    if (GCDUartSocket != nil) {
        [GCDUartSocket disconnect];//关闭建立的SOCKET
        GCDUartSocket = nil;
    }
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
    }];
}



@end
