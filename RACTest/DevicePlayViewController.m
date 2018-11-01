//
//  DevicePlay.m
//  AoSmart
//
//  Created by rakwireless on 16/1/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "DevicePlayViewController.h"
#import "CommanParameter.h"
#import "MBProgressHUD.h"
#import "LX520View.h"
#import "Rak_Lx52x_Device_Control.h"
#import "CommonFunc.h"
#import "UIColor+Hex.h"
#import "remote.h"
#import "DeviceConnectFailed.h"
#import "DeviceData.h"
#import "AudioRecord.h"
#import "sendAudio.h"
#import "HttpRequest.h"

#import "AlbumObject.h"

#import "GTCommon.h"

//car
#import <AudioToolbox/AudioToolbox.h>
#import "GTGyro.h"

//Bluetooth

#import <CoreBluetooth/CoreBluetooth.h>
//#define MyDeviceName @"HC-08" //07003F86-B2AB-D458-EB66-A230B683852B
#define MyDeviceUDID @"07003F86-B2AB-D458-EB66-A230B683852B"



LX520View *_videoView;
NSString *_qualityHD=@"h264";
NSString *_qualityBD=@"h264-1";
NSTimer* CheckVideoPlay = nil;
static NSTimer* CheckVideoRemoteConnect = nil;//用于定时1秒检查视频通道远程打通状态
static NSTimer* CheckUartRemoteConnect = nil;//用于定时1秒检查TCP 80端口通道远程打通状态
nabto_tunnel_t videoTunnel;
nabto_tunnel_t httpTunnel;
NSString *devicePlayIp;
nabto_tunnel_state_t nabtoConnectStatus;
int nabto_remote_count;
BOOL _isExit;
BOOL _isOpened;
int fps=20;
UINavigationController *_self;
NSString *album_name=@"RAK VIDEO";

@interface DevicePlayViewController ()<GTRockerDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,GTPathPlanningDelegate>
{
    NSString *devicePlayId;
    NSString *devicePlayPsk;
    int devicePlayPort;
    int deviceSendPort;
    BOOL _isRecord;
    BOOL _isOpenVoice;
    BOOL _isTcp;
    int voiceRecordSecond;
    
    NSString *_qualityNow;
    NSMutableArray *photo_timesamp;
    NSMutableArray *video_timesamp;
    NSString *url ;
    
    AudioRecord* audioRecord;
    NSTimer *voiceRecordTimer;  //用户双向语音录音计时
    
    CGFloat viewW;
    CGFloat viewH;
    NSString *version;
    NSString *videotype;
    NSString *videoscreen;
    BOOL _isLx520;
    AlbumObject *_albumObject;
    
    //uart
    NSString* deviceConnectingId;
    NSString* deviceConnectingIp;
    NSString* deviceConnectingpsk;
    NSString* deviceVersion;
    int deviceConnectingPort;
    bool _UartIsClose;
}
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayBack;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayVoice;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayTakePhoto;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayRecord;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayAudio;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlaySdRecord;

@property (weak, nonatomic) IBOutlet UIButton *DevicePlayChangePipe;
@property (weak, nonatomic) IBOutlet UIView *ControlView;
@property (weak, nonatomic) IBOutlet UIView *PipeView;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayBD;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayHD;
@property (weak, nonatomic) IBOutlet UIButton *DevicePlayAuto;
@property (weak, nonatomic) IBOutlet UIView *DevicePlayRecordVoiceView;
@property (weak, nonatomic) IBOutlet UIImageView *DevicePlayRecordVoiceImage;
@property (weak, nonatomic) IBOutlet UILabel *DevicePlayRecordVoiceText;


//Bluetooth
@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;
@property (nonatomic, assign) NSInteger animateTimes;


@property (assign, nonatomic) uint8_t *array;
@property (assign, nonatomic) BOOL vehicleStatus_Buzzer;
@property (assign, nonatomic) BOOL vehicleStatus_Light;
@property (assign, nonatomic) BOOL vehicleStatus_Engine;
@property (assign, nonatomic) BOOL vehicleStatus_gravity;

@property (nonatomic,strong) GTGyro *gyro;
@property (strong ,nonatomic) NSString *bluetoothName;
@property (strong ,nonatomic) NSThread *heartThread;

@property (strong ,nonatomic) GTCommon *commonFunc;


@end

@implementation DevicePlayViewController

-(GTCommon *)commonFunc{
    if (!_commonFunc) {
        _commonFunc = [[GTCommon alloc]init];
    }
    return _commonFunc;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _self=self.navigationController;
    self.view.backgroundColor=[UIColor blackColor];
    viewW=self.view.frame.size.width;
    viewH=self.view.frame.size.height;
    _albumObject=[[AlbumObject alloc]init];
    [_albumObject delegate:self];
    audioRecord = [[AudioRecord alloc]init];
    _isRecord=NO;
    _isExit=NO;
    _isOpened=NO;
    _isOpenVoice=NO;
    _isLx520=YES;
    devicePlayPort=554;
    deviceSendPort=80;
    devicePlayId=[self.commonFunc getParameter:@"play_device_id"];
    devicePlayIp=[self.commonFunc getParameter:@"play_device_ip"];
    fps=[[self.commonFunc getParameter:@"fps"] intValue];
    version=[self.commonFunc getParameter:@"version"];
    videoscreen=[self.commonFunc getParameter:@"screen"];
    version=version.lowercaseString;
    videotype=[self.commonFunc getParameter:@"videotype"];
    if ([videotype isEqualToString:@"mjpeg"]) {
        _qualityHD=@"mpeg4";
        _qualityBD=@"mpeg4-1";
    }
    else{
        _qualityHD=@"h264";
        _qualityBD=@"h264-1";
    }
    
    NSLog(@"fps==>%d\n",fps);
    if ([version containsString:@"wifiv"]) {
        _isLx520=NO;//图传模块
    }
    [self showAllTextDialog:devicePlayIp];
    [self viewInit];
    CheckVideoPlay = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckVideoPlayTimer) userInfo:nil repeats:YES];

    if ([devicePlayIp compare:@"127.0.0.1"]==NSOrderedSame) {
        [self play_video:_qualityBD];
    }
    else{
        [self play_video:_qualityHD];
    }
    
    [self.view sendSubviewToBack: _videoView];
    
    
    //rotepalning
    self.toucheView.layer.masksToBounds = YES;
    self.toucheView.layer.cornerRadius = self.toucheView.bounds.size.height/2.0+12.0;
    self.pathRouteView.delegate = self;
    [self.view bringSubviewToFront:self.pathPlanningView];
    
    //初始化串口数据界面
    [self initCarData];
}

bool isPortrait = YES;
- (void)setViewNewFrame: (CGFloat)width :(CGFloat)height{
    if (isPortrait) {
        if ([videoscreen compare:@"1"]==NSOrderedSame){
            if (viewW*height/width>viewH) {
                _videoView.frame=CGRectMake(0, 0, viewH*width/height, viewH);
                [_videoView setView1Frame:CGRectMake(0, 0, viewH*width/height, viewH)];
            }
            else{
                _videoView.frame=CGRectMake(0, 0, viewW, viewW*height/width);
                [_videoView setView1Frame:CGRectMake(0, 0, viewW, viewW*height/width)];
            }
        }
        else{
            if (viewW*0.5*height/width>viewH) {
                CGFloat diff=(viewW-2*viewH*width/height)/3;
                [_videoView setView1Frame:CGRectMake(diff, 0, viewH*width/height, viewH)];
                [_videoView setView2Frame:CGRectMake(diff*2+viewH*width/height, 0,  viewH*width/height, viewH)];
            }
            else{
                CGFloat diff=(viewH-(title_size+diff_top+60)-2*viewW*height/width)/3;
                [_videoView setView1Frame:CGRectMake(0, diff+title_size+diff_top, viewW, viewW*height/width)];
                [_videoView setView2Frame:CGRectMake(0, 2*diff+title_size+diff_top+viewW*height/width, viewW, viewW*height/width)];
            }
        }
    }
    else{
        if ([videoscreen compare:@"1"]==NSOrderedSame){
            if (viewW*height/width>viewH) {
                _videoView.frame=CGRectMake(0, 0, viewH*width/height, viewH);
                [_videoView setView1Frame:CGRectMake(0, 0, viewH*width/height, viewH)];
            }
            else{
                _videoView.frame=CGRectMake(0, 0, viewW, viewW*height/width);
                [_videoView setView1Frame:CGRectMake(0, 0, viewW, viewW*height/width)];
            }
        }
        else{
            if (viewW*height*0.5/width>viewH) {
                CGFloat diff=(viewW-2*viewH*width/height)/3;
                [_videoView setView1Frame:CGRectMake(diff, 0, viewH*width/height, viewH)];
                [_videoView setView2Frame:CGRectMake(diff*2+viewH*width/height, 0,  viewH*width/height, viewH)];
            }
            else{
                CGFloat diff=(viewH-0.5*viewW*height/width)/2;
                [_videoView setView1Frame:CGRectMake(0, diff, viewW*0.5, viewW*0.5*height/width)];
                [_videoView setView2Frame:CGRectMake(viewW*0.5, diff, viewW*0.5, viewW*0.5*height/width)];
            }
        }
    }
}


- (void)viewInit{
    devicePlayIp=[self.commonFunc getParameter:@"play_device_ip"];
    _videoView.userInteractionEnabled = YES;
    if ([devicePlayIp compare:@"127.0.0.1"]==NSOrderedSame) {
        
    }
    else{
        
        if ([videoscreen compare:@"1"]==NSOrderedSame) {//单屏
            _videoView = [[LX520View alloc] initWithFrame:CGRectMake(0, 0, viewW, viewH)];
        }
        [self setViewNewFrame:1280 :720];
    }
    
    _videoView.center=self.view.center;
    _videoView.backgroundColor = [UIColor blackColor];
    [_videoView set_log_level:1];
    [_videoView delegate:self];
    [self.view addSubview:_videoView];

    UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesImage)];
    doubleTapTwo.numberOfTouchesRequired = 1;
    doubleTapTwo.numberOfTapsRequired = 2;
    [_videoView addGestureRecognizer:doubleTapTwo];

    
    [_DevicePlayBack addTarget:nil action:@selector(_DevicePlayBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_DevicePlaySdRecord addTarget:nil action:@selector(_DevicePlaySdRecordClick) forControlEvents:UIControlEventTouchUpInside];

    [_DevicePlayChangePipe setTitle: NSLocalizedString(@"video_auto", nil) forState: UIControlStateNormal];

    [_DevicePlayChangePipe addTarget:nil action:@selector(_DevicePlayChangePipeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_DevicePlayVoice addTarget:nil action:@selector(_DevicePlayVoiceClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_DevicePlayTakePhoto addTarget:nil action:@selector(_DevicePlayTakePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_DevicePlayRecord addTarget:nil action:@selector(_DevicePlayRecordClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_DevicePlayAudio addTarget:self action:@selector(onVoiceRecordButtonClicked) forControlEvents:UIControlEventTouchDown];
    [_DevicePlayAudio addTarget:self action:@selector(onVoiceRecordButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [_DevicePlayAudio addTarget:self action:@selector(onVoiceRecordButtonTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    
    
   
    [_DevicePlayBD addTarget:nil action:@selector(_DevicePlayBDClick) forControlEvents:UIControlEventTouchUpInside];

    [_DevicePlayHD addTarget:nil action:@selector(_DevicePlayHDClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_DevicePlayAuto addTarget:self action:@selector(_DevicePlayAutoClick) forControlEvents:UIControlEventTouchUpInside];
    
    _PipeView.hidden=YES;
    
    _DevicePlayRecordVoiceView.hidden=YES;
    
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(GetSdStatus)
                                                     object:nil];
    [httpThread start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Show or Hidden views
-(void)touchesImage{
    if (_ControlView.hidden) {
        _ControlView.hidden=NO;
        _topView.hidden=NO;
        _slider.hidden = NO;
        _rocker.hidden = NO;
    }
    else{
        _ControlView.hidden=YES;
        _topView.hidden=YES;
        _slider.hidden = YES;
        _rocker.hidden = YES;
    }
    
    _PipeView.hidden=YES;
     self.textView.text = @"------------------";
}

#pragma mark --Play Video
- (void) play_video :(NSString *)quility{
    _qualityNow=quility;
    NSString *key=[NSString stringWithFormat:@"Password=%@",devicePlayId];
    devicePlayPsk=[self.commonFunc getParameter:key];
    if ([devicePlayIp compare:@"127.0.0.1"]==NSOrderedSame) {
       //如果设备不在本地去执行远程连接
        NabtoLibraryInit();
        nabto_remote_count=0;
        int status =Async_ConnectDeviceWithTunnel(&videoTunnel ,devicePlayId ,554 ,REMOTEPORTPLAY);
        NSLog(@"Video status = %d",status);
        CheckVideoRemoteConnect = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckVideoRemoteConnectTimer:) userInfo:nil repeats:YES];//用定时器1秒去查询一次远程通道打通状态。
    }
    else{
        url = [NSString stringWithFormat:@"rtsp://admin:%@@%@:%d/cam1/%@",devicePlayPsk,devicePlayIp,devicePlayPort,quility];
        _isTcp=NO;
        [_videoView play:url useTcp:_isTcp];
        [_videoView sound:_isOpenVoice];
        [_videoView startGetYUVData:YES];
        [_videoView set_record_frame_rate:fps];
        // Path:@"cam1/h264" 为获取720P(1280X720)图像数据，仅限本地走RTSP UDP 传输时可用
        // 如果要获取QVGA(320X240)图像数据则 Path:@"cam1/h264-1" 。
    }

    
}

-(void)CheckVideoRemoteConnectTimer:(NSTimer *)timer{
    
}

#pragma mark --LX520Delegate
- (void)state_changed:(int)state
{
    NSLog(@"state = %d", state);
    switch (state) {
        case 0: //STATE_IDLE
        {
            break;
        }
        case 1: //STATE_PREPARING
        {
            break;
        }
        case 2: //STATE_PLAYING
        {
            _isOpened = YES;
            dispatch_async(dispatch_get_main_queue(),^ {
                _DeviceConnectingView.hidden=YES;

            });
            break;
        }
        case 3: //STATE_STOPPED
        {
            _isOpened = NO;
            NSLog(@"STATE_STOPPED=====");
            break;
        }
            
        default:
            break;
    }
}

- (void)video_info:(NSString *)codecName codecLongName:(NSString *)codecLongName
{
    
}

- (void)audio_info:(NSString *)codecName codecLongName:(NSString *)codecLongName sampleRate:(int)sampleRate channels:(int)channels
{
    
}


+(void)back{

    _isExit=YES;
    NSLog(@"back");
    if (_isOpened)
    {
        [_videoView sound:NO];
        [_videoView stop];
        NSLog(@"stop play");
    }
    [CheckVideoPlay invalidate];
    CheckVideoPlay = nil;
    if ([devicePlayIp compare:@"127.0.0.1"]==NSOrderedSame) {
        CloseTunnel(&videoTunnel);
        CloseTunnel(&httpTunnel);
//        free(videoTunnel);
//        free(httpTunnel);
        nabtoConnectStatus = NTCS_CLOSED;
    }
    

    
    [_self popViewControllerAnimated:YES];
}

//Back
- (void)_DevicePlayBackClick{
    
    
    [DevicePlayViewController back];
}

//Sd Record
- (void)_DevicePlaySdRecordClick{
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(SdRecord)
                                                     object:nil];
    [httpThread start];
}

bool isSdRecord=false;
-(void)GetSdStatus{
    NSString *URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=is_pipe_record&type=h264&pipe=0",devicePlayIp,deviceSendPort];
    HttpRequest* http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"GET" andUserName:@"admin" andPassword:devicePlayPsk];
    if(http_request.StatusCode==200)
    {
        if([http_request.ResponseString compare:@"{\"value\": \"0\"}"]==NSOrderedSame)
        {
            isSdRecord=false;
            dispatch_async(dispatch_get_main_queue(),^ {
                [_DevicePlaySdRecord setImage:[UIImage imageNamed:@"ico_sdcard.png"] forState:UIControlStateNormal];
            });
        }
        else if([http_request.ResponseString compare:@"{\"value\": \"1\"}"]==NSOrderedSame)
        {
            isSdRecord=true;
            dispatch_async(dispatch_get_main_queue(),^ {
                [_DevicePlaySdRecord setImage:[UIImage imageNamed:@"ico_sdcarding.png"] forState:UIControlStateNormal];
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(),^ {
            [self showAllTextDialog:@"Get Sd-Record status failed"];
        });
    }
}

-(void)SdRecord{
    NSString *URL=@"";
    if (isSdRecord) {
        URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=stop_record&type=h264&pipe=0",devicePlayIp,deviceSendPort];
    }
    else{
        URL=[[NSString alloc]initWithFormat:@"http://%@:%d/server.command?command=start_record_pipe&type=h264&pipe=0",devicePlayIp,deviceSendPort];
    }
    
    HttpRequest* http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"GET" andUserName:@"admin" andPassword:devicePlayPsk];
    
    if(http_request.StatusCode==200)
    {
        if([http_request.ResponseString compare:@"{\"value\": \"0\"}"]==NSOrderedSame)
        {
            dispatch_async(dispatch_get_main_queue(),^ {
                if (isSdRecord) {
                    [self showAllTextDialog:@"Stop Sd-Record success"];
                    [_DevicePlaySdRecord setImage:[UIImage imageNamed:@"ico_sdcard.png"] forState:UIControlStateNormal];
                }
                else{
                    [self showAllTextDialog:@"Start Sd-Record success"];
                    [_DevicePlaySdRecord setImage:[UIImage imageNamed:@"ico_sdcarding.png"] forState:UIControlStateNormal];
                }
                isSdRecord=!isSdRecord;
                
            });
        }
        else if([http_request.ResponseString compare:@"{\"value\": \"-4\"}"]==NSOrderedSame)
        {
            dispatch_async(dispatch_get_main_queue(),^ {
                [self showAllTextDialog:@"busy,It is recording now"];
            });
        }
        else if([http_request.ResponseString compare:@"{\"value\": \"-22\"}"]==NSOrderedSame)
        {
            dispatch_async(dispatch_get_main_queue(),^ {
                [self showAllTextDialog:@"No sd-card or sd-card is full"];
            });
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (isSdRecord) {
                [self showAllTextDialog:@"Stop Sd-Record failed"];
            }
            else{
                [self showAllTextDialog:@"Start Sd-Record failed"];
            }
        });
    }
}


//ChangePipe
- (void)_DevicePlayChangePipeClick{
    if (_PipeView.hidden) {
        _PipeView.hidden=NO;
    }
    else{
        _PipeView.hidden=YES;
    }
}

//Auto
- (void)_DevicePlayAutoClick{
    _PipeView.hidden=YES;
    if (!_isOpened) {
        return;
    }
    if ([devicePlayIp compare:@"127.0.0.1"]==NSOrderedSame) {
        if ([_qualityNow compare:_qualityBD]==NSOrderedSame) {
            [self showAllTextDialog:NSLocalizedString(@"video_BD_ok", nil)];
        }
        else{
            [_videoView stop];
            _DeviceConnectingView.hidden=NO;
            [self setViewNewFrame:640 :480];
            _videoView.center=self.view.center;
            url = [NSString stringWithFormat:@"rtsp://admin:%@@%@:%d/cam1/%@",devicePlayPsk,devicePlayIp,devicePlayPort,_qualityBD];
            _qualityNow=_qualityBD;
            [_videoView play:url useTcp:_isTcp];
            [_videoView sound:_isOpenVoice];
            [_videoView startGetYUVData:YES];
            //[_videoView set_record_frame_rate:fps];
        }
    }
    else{
        if ([_qualityNow compare:_qualityHD]==NSOrderedSame) {
            [self showAllTextDialog:NSLocalizedString(@"video_HD_ok", nil)];
        }
        else{
            [_videoView stop];
            _DeviceConnectingView.hidden=NO;
            [self setViewNewFrame:1280 :720];
            _videoView.center=self.view.center;
            url = [NSString stringWithFormat:@"rtsp://admin:%@@%@:%d/cam1/%@",devicePlayPsk,devicePlayIp,devicePlayPort,_qualityHD];
            _qualityNow=_qualityBD;
            [_videoView play:url useTcp:_isTcp];
            [_videoView sound:_isOpenVoice];
            [_videoView startGetYUVData:YES];
            //[_videoView set_record_frame_rate:fps];
        }
    }
}

- (void)GetYUVData:(int)width :(int)height
                  :(Byte*)yData :(Byte*)uData :(Byte*)vData
                  :(int)ySize :(int)uSize :(int)vSize
{
    //NSLog(@"get video");
}

//VHD
- (void)_DevicePlayVHDClick{
    _PipeView.hidden=YES;
    if (!_isOpened) {
        return;
    }
    if (_isLx520) {
        return;
    }
    else{
        
    }
}

//HD
- (void)_DevicePlayHDClick{
    _PipeView.hidden=YES;
    if (!_isOpened) {
        return;
    }
    if ([_qualityNow compare:_qualityHD]==NSOrderedSame) {
        [self showAllTextDialog:NSLocalizedString(@"video_HD_ok", nil)];
    }
    else{
        [_videoView stop];
        _DeviceConnectingView.hidden=NO;
        [self setViewNewFrame:1280 :720];
        _videoView.center=self.view.center;
        url = [NSString stringWithFormat:@"rtsp://admin:%@@%@:%d/cam1/%@",devicePlayPsk,devicePlayIp,devicePlayPort,_qualityHD];
        _qualityNow=_qualityHD;
        [_videoView play:url useTcp:_isTcp];
        [_videoView sound:_isOpenVoice];
        [_videoView startGetYUVData:YES];
        //[_videoView set_record_frame_rate:fps];
    }
}

//BD
- (void)_DevicePlayBDClick{
    _PipeView.hidden=YES;
    if (!_isOpened) {
        return;
    }
    if ([_qualityNow compare:_qualityBD]==NSOrderedSame) {
        [self showAllTextDialog:NSLocalizedString(@"video_BD_ok", nil)];
    }
    else{
        [_videoView stop];
        [self setViewNewFrame:640 :480];
        _videoView.center=self.view.center;
        url = [NSString stringWithFormat:@"rtsp://admin:%@@%@:%d/cam1/%@",devicePlayPsk,devicePlayIp,devicePlayPort,_qualityBD];
        _qualityNow=_qualityBD;
        [_videoView play:url useTcp:_isTcp];
        [_videoView sound:_isOpenVoice];
        [_videoView startGetYUVData:YES];
        //[_videoView set_record_frame_rate:fps];
    }
}

//Voice
- (void)_DevicePlayVoiceClick{
    _isOpenVoice=!_isOpenVoice;
    [_videoView sound:_isOpenVoice];
    if (_isOpenVoice) {
        [_DevicePlayVoice setImage:[UIImage imageNamed:@"video_voice_on.png"] forState:UIControlStateNormal];
    }
    else{
        [_DevicePlayVoice setImage:[UIImage imageNamed:@"video_voice_off.png"] forState:UIControlStateNormal];
    }
}

//Take Photo
- (void)_DevicePlayTakePhotoClick{
    if (!_isOpened) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_albumObject createAlbumInPhoneAlbum:album_name];
        [_albumObject getPathForRecord:album_name];
    });
    [self.commonFunc playSound:@"shutter.mp3"];
    [_videoView take_photo];
}



- (void)Save_Paths:(NSMutableArray *)Timesamp :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:Timesamp forKey:key];
    [defaults synchronize];
}

- (NSMutableArray *)Get_Paths:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *value=[defaults objectForKey:key];
    return value;
}

- (void)take_photo:(UIImage *)image
{
    long recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timesamp=[NSString stringWithFormat:@"%ld",recordTime];
    NSLog(@"photo_timesamp:%@",timesamp);
    photo_timesamp=[self Get_Paths:@"photo_flag"];
    if (photo_timesamp==nil) {
        photo_timesamp=[[NSMutableArray alloc]init];
    }
    NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
    [mutaArray addObjectsFromArray:photo_timesamp];
    [mutaArray addObject:timesamp];
    [self Save_Paths:mutaArray :@"photo_flag"];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [_albumObject saveImageToAlbum:image albumName:album_name];
}

//拍照回调
- (void)saveImageToAlbum:(BOOL)success{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            [self showAllTextDialog:NSLocalizedString(@"video_take_photo_text", nil)];
        }
        else{
            [self showAllTextDialog:@"Save photo to album failed"];
        }
    });
}

//拍照回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(NSDictionary  *)contextInfo
{
    if (error==nil) {
        [self showAllTextDialog:NSLocalizedString(@"video_take_photo_text", nil)];
    }
}

//Record
- (void)_DevicePlayRecordClick{
    if (!_isOpened) {
        return;
    }
    
    if (_isRecord) {
        _isRecord = NO;
        [self.commonFunc playSound:@"end_record.mp3"];
        [l_recodevideo removeFromSuperview];
        [_videoView end_record];
        [self showAllTextDialog:NSLocalizedString(@"video_record_text", nil)];
    }
    else{
        _isRecord = YES;
        //获取当前时间戳
        [self.commonFunc playSound:@"begin_record.mp3"];
        long recordTime = [[NSDate date] timeIntervalSince1970];
        NSString *timesamp=[NSString stringWithFormat:@"%ld",recordTime];
        NSLog(@"video_timesamp:%@",timesamp);
        video_timesamp=[self Get_Paths:@"video_flag"];
        if (video_timesamp==nil) {
            video_timesamp=[[NSMutableArray alloc]init];
        }
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        [mutaArray addObjectsFromArray:video_timesamp];
        [mutaArray addObject:timesamp];
        [self Save_Paths:mutaArray :@"video_flag"];
        [_videoView begin_record:0];
        VideoRecordTimerTick_s = 0;
        VideoRecordTimerTick_m = 0;
        l_recodevideo = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width -110, 80+10, 100, 40)];
        l_recodevideo.text = @"REC 00:00";
        //l_recodevideo.font = [UIFont boldSystemFontOfSize:20];
        l_recodevideo.textColor = [UIColor redColor];
        l_recodevideo.adjustsFontSizeToFitWidth = YES;
        l_recodevideo.numberOfLines = 1;
        l_recodevideo.backgroundColor=[UIColor clearColor];
        [self.view addSubview:l_recodevideo];
    }
}

int VideoRecordTimerTick_s = 0;
int VideoRecordTimerTick_m = 0;
-(void)updateVideoRecordTimer{
    if (_isRecord == NO) {
        return;
    }
    VideoRecordTimerTick_s ++;
    if (VideoRecordTimerTick_s > 59) {
        VideoRecordTimerTick_m++;
        VideoRecordTimerTick_s = 0;
    }
    if (VideoRecordTimerTick_m > 59) {
        VideoRecordTimerTick_m = 0;
    }
    l_recodevideo.text = [NSString stringWithFormat:@"REC %.2d:%.2d",VideoRecordTimerTick_m,VideoRecordTimerTick_s];
}
-(void)CheckVideoPlayTimer{
    [self updateVideoRecordTimer];
}


//Audio
- (void)onVoiceRecordButtonClicked
{
    if (!_isOpened) {
        return;
    }
    if (![self.commonFunc openVoiceIndicator]) {
        return;
    }
    
    [_DevicePlayRecordVoiceView setHidden:NO];
    voiceRecordSecond = 0;
    [audioRecord StartRecord];
    voiceRecordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(voiceRecordTimer) userInfo:nil repeats:YES];
}

- (void)onVoiceRecordButtonTouchUp
{
    if (!_isOpened) {
        return;
    }
    [_DevicePlayRecordVoiceView setHidden:YES];
    [voiceRecordTimer invalidate];
    voiceRecordTimer = nil;
    _DevicePlayRecordVoiceText.text = @"00:00";
    NSData* PCMUData = [audioRecord StopRecord];
    NSLog(@"PCMUData LEN = %lu",(unsigned long)PCMUData.length);
    [sendAudio sendWithIp:devicePlayIp port:deviceSendPort data:PCMUData];
}



-(void)voiceRecordTimer{
    voiceRecordSecond ++;
    uint64_t hour = voiceRecordSecond / 3600;
    uint64_t min = (voiceRecordSecond - hour * 3600) / 60;
    uint64_t sec = voiceRecordSecond - hour * 3600 - min * 60;
    if(min < 10)
    {
        if(sec < 10)
            _DevicePlayRecordVoiceText.text = [NSString stringWithFormat:@"0%llu:0%llu", min,sec];
        else
            _DevicePlayRecordVoiceText.text = [NSString stringWithFormat:@"0%llu:%llu", min, sec];
    }
    else
    {
        if(sec < 10)
            _DevicePlayRecordVoiceText.text = [NSString stringWithFormat:@"%llu:0%llu", min, sec];
        else
            _DevicePlayRecordVoiceText.text = [NSString stringWithFormat:@"%llu:%llu", min, sec];
    }
}


//心跳包
-(void)sendHeartBeat{
//    Byte keep_alive_data[] = {0x7E,0x00,0x01,0x00,0x00,0x00,0x7E};
    [NSThread sleepForTimeInterval:5.0f];

    while (true) {
        [NSThread sleepForTimeInterval:1.0f];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            //Update UI in UI thread here
            [self setDataWithID:0x07 andHeightData:0x00 lowData:0x02];
        });
    }
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



//car

-(GTGyro *)gyro{
    if (!_gyro) {
        _gyro = [[GTGyro alloc] init];
    }
    return _gyro;
}


- (void)initCarData {
    
    [self initBluetoothAndScaning];

    [self initUI];
    
    self.sliderLabel.text =  @"0";
    self.rockerLabel.text =  @"0";
    self.bluetoothName = @"SmartCar";
    
    self.rocker.delegate = self;
    
}


-(void)initUI {
    
    self.slider.sliderStyle = GTSliderStyle_Cross;
    self.slider.thumbTintColor = [UIColor colorWithRed:0.96 green:0.82 blue:0.30 alpha:1.00];
    self.slider.thumbShadowColor = [UIColor colorWithRed:229/255.0 green:251/255.0 blue:0 alpha:1];
    self.slider.thumbShadowOpacity = 1.0f;
    self.slider.thumbDiameter = 45;
    self.slider.scaleLineColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.40];
    self.slider.scaleLineWidth = 2.0f;
    self.slider.scaleLineHeight = 10;
    self.slider.scaleLineNumber = 6;//总的多少份
    [self.slider setSelectedIndex: 3];//当前默认多少
    [self.slider addTarget:self action:@selector(sliderChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    [self customerUIs];
}


- (void)sliderChangeAction:(GTSlider *)sender {
    NSInteger cIdx = -(sender.currentIdx-3);
    self.sliderLabel.text =  [NSString stringWithFormat:@"%ld",cIdx];
    [self setdatawithiOperateID:7 andHeightData: cIdx>0 ? 0x02:0x01 lowData: labs(cIdx)];//左右的值 为0情况
    
}

- (void)rockerDidChangeDirection:(GTRocker *)rocker locationX:(CGFloat)x locationY:(CGFloat)y locationDirec:(NSInteger)direc
{
  //  NSLog(@"main:%f    %f   %ld",x,y,(long)direc);
    
    _rockerLabel.text = [NSString stringWithFormat:@"%ld",direc];
    
    [self setdatawithiOperateID:4 andHeightData: direc>0 ? 0x01:0x02 lowData: labs(direc)];
}


-(void)initVehicleUIWithOperateID:(Byte)opid status:(Byte)sts AndeHightData:(Byte)hightData LowData: (Byte)lowData{
    UInt32 newData = 0;
    
    switch (opid) {
        case 2:
            if (sts == 0x02) {//开
                _vehicleStatus_Buzzer = true;
            }else if (sts == 0x01){
                _vehicleStatus_Buzzer = false;
            }
            break;
        case 3:
            if (sts == 0x02) {//开
                _vehicleStatus_Light = true;
            }else if (sts == 0x01){
                _vehicleStatus_Light = false;
            }
            break;
        case 5:
            if (sts == 0x02) {//开
                [self displayAnimations];
            }
            break;
        case 6:
            if (sts == 0x02) {//开
                _vehicleStatus_Engine = true;
            }else if (sts == 0x01){
                _vehicleStatus_Engine = false;
            }
            break;
        case 7:
             newData = (hightData<<8) +lowData;
            self.distanceLabel.text = [NSString stringWithFormat:@"%d cm",newData];
            break;
        default:
            break;
    }
    
    [self customerUIs];
}

- (void)displayAnimations
{
    self.findCarBtn.enabled = NO;
    
    self.animateTimes = 0;
    NSTimeInterval perImageDuration = 0.2;
    
    NSArray *imageArray = @[[UIImage imageNamed:@"findcar_open"], [UIImage imageNamed:@"findcar_open"], [UIImage imageNamed:@"findcar_open"], [UIImage imageNamed:@"findcar_close"]];
    self.findCarBtn.imageView.animationImages = imageArray;
    
    NSTimeInterval animationDuration = perImageDuration * imageArray.count;
    [self stepByStepAnimationWithPerStepDuration:animationDuration];
}

- (void)stepByStepAnimationWithPerStepDuration:(NSTimeInterval)duration
{
    if (self.animateTimes >= 3) {
        self.findCarBtn.imageView.hidden = YES;
        self.findCarBtn.enabled = YES;
        return;
    }
    
    self.findCarBtn.imageView.animationDuration = duration;
    self.findCarBtn.imageView.animationRepeatCount = 1;
    if (self.findCarBtn.imageView.isAnimating) {
        [self.findCarBtn.imageView stopAnimating];
    }
    [self.findCarBtn.imageView startAnimating];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    self.findCarBtn.imageView.hidden = NO;
    [UIView animateWithDuration:duration animations:^{
        self.findCarBtn.imageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.findCarBtn.imageView.alpha = 1.0;
        self.animateTimes ++;
        
        [self stepByStepAnimationWithPerStepDuration:duration];
    }];
}

-(void)customerUIs{
    [self.lightButton setBackgroundImage:[UIImage imageNamed: _vehicleStatus_Light ? @"light_open":@"light_close"] forState:UIControlStateNormal];
    
    [self.buzzerBtton setBackgroundImage:[UIImage imageNamed: _vehicleStatus_Buzzer ?@"buzzer_open" : @"buzzer_colse"] forState:UIControlStateNormal];
    
    [self.engineBtn setBackgroundImage:[UIImage imageNamed: _vehicleStatus_Engine ?@"engine_open" : @"engine_close"] forState:UIControlStateNormal];
    
    [self.gravityBtn setBackgroundImage:[UIImage imageNamed: _vehicleStatus_gravity ?@"gravity_open" : @"gravity_close"] forState:UIControlStateNormal];
    
}

-(void)initVehicleStatusWithData:(NSData *)data{
    
    if ([data length] == 7) {
        
        Byte *carData = (Byte *)[data bytes];
        
        if ((carData[0]&0xff) ==0x7E &&(carData[6]&0xff) == 0x7E) {
            
            int CRCSum = 0;
            for(int i=1;i<[data length]-2;i++){
                CRCSum+=carData[i];
                //            NSLog(@"%d",i);
            }
            CRCSum =CRCSum -1;
            
            if ((carData[5]&0xff) != CRCSum ||(carData[2]&0xff) != 0x02) {
                [self showData: @"check data error"];
                
                return;
            }
            
            [self initVehicleUIWithOperateID: carData[1] status:carData[4] AndeHightData:carData[3] LowData:carData[4]];
        }
        
        
    }
}


-(void)setDataWithID:(Byte)ID andHeightData:(Byte)heightData lowData:(Byte)lowData{
    
    Byte carData[] = {0x7E,ID,0x01,heightData,lowData,0x00,0x7E};
    
    Byte  CRCSum=carData[1]+carData[2]+carData[3]+carData[4]-0x01;
    
    carData[5]= CRCSum;
    
    NSData *bdata = [[NSData alloc] initWithBytes:carData length: sizeof(carData)];

    if (_discoveredPeripheral ==nil) {
        return;
    }
    
    [_discoveredPeripheral writeValue:bdata forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];

    NSString *str =  [self.commonFunc hexStringFromData: [NSData dataWithBytes:carData length:sizeof(carData)]];

    [self showData: str];
    
    
}




-(void)showData:(NSString *)newMessage{
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
    NSString *locationString=[dateformatter stringFromDate:[NSDate date]];
    
    [self textViewAddText:[NSString stringWithFormat:@"%@  %@",locationString, newMessage]];
    
    
}

- (void)textViewAddText:(NSString *)text {
    //加上换行
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.textView.text = [text stringByAppendingFormat:@"\n%@",self.textView.text ];

    }];
}


-(void)setdatawithiOperateID:(NSInteger)opid andHeightData:(Byte)heightData lowData:(Byte)lowData {
    
    switch (opid) {
            
        case 2://打开连接
            [self  initBluetoothAndScaning];
            
            break;
        case 3://断开链接
            [self  disBluetoothconnectAction];
            
            break;
        case 4: //方向
            [self setDataWithID:0x01 andHeightData:heightData lowData:lowData ];
            break;
        case 5: //1蜂鸣器关,2蜂鸣器开
            [self setDataWithID:0x02 andHeightData:0X00 lowData: _vehicleStatus_Buzzer ? 0x01 : 0x02 ];
            break;
        case 6: //1灯关,2灯开
            [self setDataWithID:0x03 andHeightData:0X00 lowData: _vehicleStatus_Light ? 0x01 : 0x02 ];
            break;
        case 7: //油门
            [self setDataWithID:0x04 andHeightData:heightData  lowData: lowData ];
            break;
        case 8: //寻车
            [self setDataWithID:0x05 andHeightData: 0x00  lowData: 0x02 ];
            break;
        case 9: //引擎
            [self setDataWithID:0x06 andHeightData:0X00 lowData: _vehicleStatus_Engine ? 0x01 : 0x02 ];
            break;
            
        case 100: //设置按钮
            self.textView.hidden = !self.textView.hidden;
           
            break;
        case 101: //重力感应
            [self startGyroControl];
            break;
        case 102: //手动划路径
            [self showPathPlanning];
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonClickedAction:(UIButton *)sender {
    NSInteger sendertag = sender.tag;
    
    [self setdatawithiOperateID:sendertag andHeightData:0x00 lowData:0x00];
    
}


-(void)startGyroControl{
    _vehicleStatus_gravity = !_vehicleStatus_gravity;
    
    if (_vehicleStatus_gravity) {
        [self.gyro startUpdateAccelerometerResult:^(int dir , int dirData, BOOL flag) {
            
            if (!flag) {
                self.rockerLabel.text = [NSString stringWithFormat:@"%d",dirData];

            }else{
                self.sliderLabel.text = [NSString stringWithFormat:@"%d",dirData];

            }
            
            //            前后:1  0x04   左右 ：0  0x01
            [self setDataWithID:flag ? 0x04:0x01 andHeightData:dir lowData:dirData ];
            
        }];
    }else{
        [self.gyro stopUpdate];
    }
    
    [self customerUIs];
    
}


-(void)connectDeviceSuccess{
    [self.connectStatusBtn setBackgroundImage:[UIImage imageNamed:@"connect_open"] forState:UIControlStateNormal ];
    
    [self textViewAddText:@"has connected"];
    
    [self showAllTextDialog:@"蓝牙连接成功"];

    //下发命令
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
        UIButton *button = [[UIButton alloc]init];
        button.tag = 9;
        
        [self buttonClickedAction: button];
        
    });
    
    if (!self.heartThread) {
        self.heartThread = [[NSThread alloc] initWithTarget:self selector:@selector(sendHeartBeat) object:nil];
    }
    
    [self.heartThread start];
    

    
//     [NSThread detachNewThreadSelector:@selector(sendHeartBeat) toTarget:self withObject:nil];//心跳

    
}


- (void)disBluetoothconnectAction {
    
    [self.heartThread cancel];
    self.heartThread = nil;
    
    if (_discoveredPeripheral == nil) {
        return;
    }
    
    [self.centralMgr  cancelPeripheralConnection:_discoveredPeripheral];
    
    [self disconnectDeviceSuccess];
}



-(void)disconnectDeviceSuccess{
    
    [self.connectStatusBtn setBackgroundImage:[UIImage imageNamed:@"connect_close"] forState:UIControlStateNormal ];
    
    [self textViewAddText:@"disconnected"];
    [self showAllTextDialog:@"蓝牙连接失败"];

    
}

- (void)stopScaning {
    [self.centralMgr stopScan];
}


- (void)initBluetoothAndScaning {
    
    if (!self.centralMgr) {
        
        self.centralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
    }else{
        [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
        [self textViewAddText:@"scaning..."];
        
    }
    
    
}


//1.建立一个Central Manager实例进行蓝牙管理  ;检查App的设备BLE是否可用 （ensure that Bluetooth low energy is supported and available to use on the central device）
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state)
    {
        case CBCentralManagerStateUnknown:
            NSLog(@"初始的时候是未知的（刚刚创建的时候）");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"正在重置状态");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"设备不支持的状态");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"设备未授权状态");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"设备关闭状态");
            [self showAllTextDialog:@"蓝牙未打开"];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"设备开启状态 -- 可用状态");
            
            //discover what peripheral devices are available for your app to connect to
            //第一个参数为CBUUID的数组，需要搜索特点服务的蓝牙设备，只要每搜索到一个符合条件的蓝牙设备都会调用didDiscoverPeripheral代理方法
            [self initBluetoothAndScaning];//开始扫描
            
        default:
            break;
    }
}

// 2.搜索外围设备  发现外设后调用的方法

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //找到需要的蓝牙设备，停止搜素，保存数据
    if([peripheral.name isEqualToString: _bluetoothName]){
        _discoveredPeripheral = peripheral;
        [_centralMgr connectPeripheral:peripheral options:nil];
    }
}

//3.连接外围设备

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //Before you begin interacting with the peripheral, you should set the peripheral’s delegate to ensure that it receives the appropriate callbacks（设置代理）
    [_discoveredPeripheral setDelegate:self];
    //discover all of the services that a peripheral offers,搜索服务,回调didDiscoverServices
    [_discoveredPeripheral discoverServices:nil];
    
    [self connectDeviceSuccess];
    
}

// 3 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
    [self disconnectDeviceSuccess];
}

// 3丢失连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=断开连接", __FUNCTION__, __LINE__, peripheral.name);
    
    [self disBluetoothconnectAction];
    
    //尝试从连接
    [self initBluetoothAndScaning];
    
}


//获取服务后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverServices : %@", [error localizedDescription]);
        return;
    }
    
    for (CBService *s in peripheral.services)
    {
        NSLog(@"Service found with UUID : %@", s.UUID);
        //Discovering all of the characteristics of a service,回调didDiscoverCharacteristicsForService
        [s.peripheral discoverCharacteristics:nil forService:s];
    }
}

//获取特征后的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *c in service.characteristics)
    {
        NSLog(@"c.properties:%lu",(unsigned long)c.properties) ;
        //Subscribing to a Characteristic’s Value 订阅
        [peripheral setNotifyValue:YES forCharacteristic:c];
        // read the characteristic’s value，回调didUpdateValueForCharacteristic
        [peripheral readValueForCharacteristic:c];
        _writeCharacteristic = c;
    }
    
}

//订阅的特征值有新的数据时回调
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
    
    [peripheral readValueForCharacteristic:characteristic];
    
}

// 获取到特征的值时回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSData *data = characteristic.value;
    
    NSString * newMessage = [self.commonFunc hexStringFromData:data];
    //车况返现
    [self initVehicleStatusWithData:data];
    
    [self showData: newMessage];
    
}

#pragma mark 写数据后回调
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error writing characteristic value: %@",
              [error localizedDescription]);
        return;
    }
    NSLog(@"写入%@成功",characteristic);
}


-(void)pathPlanningDidChangedWithDirection:(PathPlanningDirection)direction DirectionLevel:(PathPlanningLevel)directionLevel PathPlanningAngle:(PathPlanningAngle)angle AngleLevel:(PathPlanningLevel)angleLevel{
    
    NSLog(@"xxxdirection=%ld,angle=%ld,angleLevel=%ld",(long)direction,(long)angle,(long)angleLevel);
    
    [self setdatawithiOperateID:4 andHeightData:angle   lowData: angleLevel];//左右转动
    
    double delayInSeconds = 0.05;
    __block DevicePlayViewController* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [bself setdatawithiOperateID:7 andHeightData:direction  lowData: directionLevel];//油门
    });

}


- (void)showPathPlanning{
    self.pathPlanningView.hidden = NO;
    [self touchesImage];

    
    [self switchBtnStatusChanged];
    
    [self.routeSwitchBtn addTarget:self action:@selector(switchBtnStatusChanged) forControlEvents:UIControlEventValueChanged];
  
}

-(void)switchBtnStatusChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GTNotificationName" object:nil userInfo: @{@"switchStatus": [NSNumber numberWithBool:self.routeSwitchBtn.isOn]}];

}


- (IBAction)colsePathPlanningView:(UIButton *)sender {
    self.pathPlanningView.hidden = YES;
    [self touchesImage];
}

@end
