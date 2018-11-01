//
//  ViewController.m
//  AoSmart
//
//  Created by rakwireless on 16/1/20.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "ViewController.h"
#import "DeviceData.h"
#import "DeviceInfo.h"
#import "Rak_Lx52x_Device_Control.h"

#import "DevicePlayViewController.h"
#import "remote.h"
#import "HttpRequest.h"
#import "GTCommon.h"

NSString *deviceConnectId;
NSString *deviceConnectIp;
NSString *deviceConnectName;
int deviceConnectPort=80;

Rak_Lx52x_Device_Control *_device_Scan;
DeviceData *_device_Data;
NSMutableArray *_collection_Items;
NSMutableArray *_local_Items;
UIAlertView *waitAlertView;




@interface ViewController ()
{
    bool _isExit;
    
    nabto_tunnel_state_t nabtoConnectStatus;
    nabto_tunnel_t tunnel_80;
    int nabto_remote_count;
    NSString *pwdstrs;
}

@property (weak, nonatomic) IBOutlet UIButton *videoRefresh;
@property (strong ,nonatomic) GTCommon *commonFunc;

@end

@implementation ViewController

-(GTCommon *)commonFunc{
    if (!_commonFunc) {
        _commonFunc = [[GTCommon alloc]init];
    }
    return _commonFunc;
}


- (IBAction)videoRefreshClick:(UIButton *)sender {
    
    [self scanDevice];
}

- (IBAction)pushVideoPage:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DevicePlayViewController *v = [storyboard instantiateViewControllerWithIdentifier:@"DevicePlayViewController"];
    
    [self.navigationController pushViewController: v animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isExit=NO;
    
 
    [self.commonFunc saveParameter:@"1" :@"screen"];
    [self.commonFunc saveParameter:@"h264" :@"videotype"];
    pwdstrs = @"admin";//密码写死
    deviceConnectId=[self.commonFunc getParameter:@"play_device_id"];
    deviceConnectIp=[self.commonFunc getParameter:@"play_device_ip"];
    deviceConnectName=[self.commonFunc getParameter:@"play_device_name"];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    _isExit=NO;
    _device_Scan = [[Rak_Lx52x_Device_Control alloc] init];
    [self scanDevice];
    
    _collection_Items=[[NSMutableArray alloc]init];
    _local_Items=[[NSMutableArray alloc]init];
    _device_Data=[[DeviceData alloc]init];
}
- (void) viewDidDisappear:(BOOL)animated
{
    _isExit=YES;
    [super viewDidDisappear:animated];
}





#pragma mark -- scanDevice
- (void)scanDevice
{
    if (_isExit) {
        return;
    }
    waitAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"main_scan_indicator_title", nil)
                                               message:NSLocalizedString(@"main_scan_indicator", nil)
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil, nil];
    [waitAlertView show];
    [_local_Items removeAllObjects];
    [_collection_Items removeAllObjects];
    [NSThread detachNewThreadSelector:@selector(scanDeviceTask) toTarget:self withObject:nil];
}

- (void)scanDeviceTask
{
    Lx52x_Device_Info *result = [_device_Scan ScanDeviceWithTime:1.5f];
    [self performSelectorOnMainThread:@selector(scanDeviceOver:) withObject:result waitUntilDone:NO];
}

- (void)scanDeviceOver:(Lx52x_Device_Info *)result;
{
    NSMutableArray *_deviceInfos=[_device_Data getDeviceIds];
    if (result.Device_ID_Arr.count > 0) {
        NSLog(@"Scan Over...");
        [result.Device_ID_Arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *deviceIp = [result.Device_IP_Arr objectAtIndex:idx];
            NSString *deviceId = [result.Device_ID_Arr objectAtIndex:idx];
            bool tempsame=NO;
            for (int i=0;i<[_local_Items count]; i++) {
                DeviceInfo *temp=_local_Items[i];
                if ([deviceId compare:temp.deviceID]==NSOrderedSame){
                    tempsame=YES;
                    break;
                }
            }
            if (!tempsame) {
                DeviceInfo *localDevice=[[DeviceInfo alloc]init];
                localDevice.deviceID=deviceId;
                localDevice.deviceName=[_device_Data getDeviceNameById:deviceId];
                localDevice.deviceIp=deviceIp;
                localDevice.deviceStatus=_deviceOnline;
                NSLog(@"Scan nothing1...");
                [_local_Items addObject:localDevice];//本地设备
                [_collection_Items addObject:localDevice];//添加已经扫描到的本地设备
                NSLog(@"Scan nothing2...");
            }
        }];
    }
    else
    {
        NSLog(@"Scan nothing...");
    }
    [_deviceInfos enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //保存的所有设备都为offline
        DeviceInfo *_saveInfo=_deviceInfos[idx];
        NSString *_saveId=_saveInfo.deviceID;
        
        DeviceInfo *_localInfo;
        int index=0;
        bool same=NO;
        for(int i=0;i<[_local_Items count];i++)
        {
            _localInfo=_local_Items[i];
            NSString *_localId=_localInfo.deviceID;
            //相同，表示已经保存过，则更新设备名称和设备状态为online
            NSLog(@"%@",_saveId);
            NSLog(@"%@",_localId);
            if([_saveId compare:_localId]==NSOrderedSame ){
                index=i;
                NSLog(@"%d",i);
                same=YES;
                break;
            }
        }
        //不相同则直接添加
        if (!same) {
            NSLog(@"Scan nothing3...");
            [_collection_Items addObject:_saveInfo];
            NSLog(@"Scan nothing4...");
        }
        else{
            NSLog(@"Scan nothing5...");
            //_collection_Items和_local_Items是相同的
            DeviceInfo *newInfo=_localInfo;//ip id为扫描到的值
            newInfo.deviceName=_saveInfo.deviceName;//name 为保存值
            newInfo.deviceStatus=_deviceOnline;//status 为在线
            [_collection_Items replaceObjectAtIndex:index withObject:newInfo];//更新这个设备信息
            same=YES;
        }
    }];
    
    [waitAlertView dismissWithClickedButtonIndex:0 animated:YES];

    if (_collection_Items.count >0) {
        DeviceInfo *_device= _collection_Items[0];
        NSString *deviceName=[_device_Data getDeviceNameById:_device.deviceID];
        [self.commonFunc saveParameter:_device.deviceID :@"play_device_id"];
        [self.commonFunc saveParameter:_device.deviceIp :@"play_device_ip"];
        [self.commonFunc saveParameter:deviceName :@"play_device_name"];
//        DeviceConnect *v = [[DeviceConnect alloc] init];
//        [self.navigationController pushViewController: v animated:true];
          [self _DeviceConnectBtnClick];

        
    }
   
}



//Back 关闭
- (void)_DeviceConnectBackClick{
    if ([deviceConnectIp compare:@"127.0.0.1"]==NSOrderedSame){
        CloseTunnel(&tunnel_80);
        nabtoConnectStatus = NTCS_CLOSED;
    }
}


- (void)_DeviceConnectBtnClick{
    NSString *key=[NSString stringWithFormat:@"Password=%@",deviceConnectId];
    [self.commonFunc saveParameter:pwdstrs :key];
    //get version
    NSString *URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=get_version",deviceConnectIp,deviceConnectPort];
    HttpRequest* http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"GET" andUserName:@"admin" andPassword:pwdstrs];
    if(http_request.StatusCode==200)
    {
        http_request.ResponseString=[http_request.ResponseString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *version=[self.commonFunc parseJsonString:http_request.ResponseString];
        if ([version compare:@""]==NSOrderedSame) {
            version=http_request.ResponseString;
        }
        NSLog(@"version=%@",version);
        [self.commonFunc saveParameter:version :@"version"];
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
                [self.commonFunc saveParameter:[fps substringToIndex:(range1.location+1)] :@"fps"];
                NSLog(@"fps=%@",[fps substringToIndex:(range1.location+1)]);
            }
            else{
                [self.commonFunc saveParameter:@"20" :@"fps"];
            }
        }
        else{
            [self.commonFunc saveParameter:@"20" :@"fps"];
        }
    }
    else{
        [self.commonFunc saveParameter:@"20" :@"fps"];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DevicePlayViewController *v = [storyboard instantiateViewControllerWithIdentifier:@"DevicePlayViewController"];

    [self.navigationController pushViewController: v animated:true];
    
}




@end
