//
//  remote.m
//  
//
//  Created by 韦伟 on 15/5/20.
//  Copyright (c) 2015年 william.wei. All rights reserved.
//

#import "remote.h"

@implementation remote

typedef enum {
    CLOSED,
    OPENED
}SessionStatus;

typedef enum {
    Stoped,
    Start,
    Started
}NabtoLogStatus;
static NabtoLogStatus _NabtoLogStatus;

static SessionStatus _SessionStatus;

static nabto_handle_t nabsession;

static BOOL LX520log = NO;

static int Tunnel_Open_Number = 0;
int NabtoLibraryInit(void){
    if (Tunnel_Open_Number > 0) {
        //Tunnel_Open_Number = 0;
        NSLog(@"NabtoLibraryInit error!");
        return -1;
    }
    nabtoInit();
    Tunnel_Open_Number = 0;
    _SessionStatus = CLOSED;
    return 0;
}
nabto_status_t CloseTunnel(nabto_tunnel_t* tunnel){
    NSLog(@"CloseTunnel Tunnel_Open_Number = %d",Tunnel_Open_Number);
    nabto_status_t status = nabtoTunnelClose(*tunnel);
    if (Tunnel_Open_Number > 0) {
        Tunnel_Open_Number --;
    }
    if ((Tunnel_Open_Number == 0)&&(_SessionStatus == OPENED)) {
        _SessionStatus = CLOSED;
        int flg = nabtoCloseSession(nabsession);
        NSLog(@"nabtoCloseSession = %d",flg);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"nabtoShutdown = %d",nabtoShutdown());
        });

        Tunnel_Open_Number = 0;
    }
    NSLog(@"nabto_status_t = %d",status);
    return status;
}

nabto_tunnel_state_t Sync_ConnectDeviceWithTunnel(nabto_tunnel_t* tunnel, NSString* RemoteId,int RemotePort, int LocalPort, float times){
    if (_SessionStatus == CLOSED) {
        _SessionStatus = OPENED;
        NabtoOpenSession();
    }
    NSString *target = @"127.0.0.1";
    nabto_status_t status = nabtoTunnelOpenTcp(tunnel, nabsession, LocalPort, [RemoteId UTF8String], [target UTF8String],RemotePort);
    if (status == NABTO_OK){
        Tunnel_Open_Number ++;
        NSLog(@"Tunnel_Open_Number = %d",Tunnel_Open_Number);
    }else{
        return NTCS_CLOSED;
    }
    nabto_tunnel_state_t status_tunnel = NTCS_CLOSED;
    int timeout_num = (int)times;
    do{
        if (timeout_num < 1) {
            CloseTunnel(tunnel);
            return NTCS_CLOSED;
        }
        timeout_num --;
        status_tunnel = CheckConnectStatus(tunnel);
        [NSThread sleepForTimeInterval:1.0f];
    }while(status_tunnel == NTCS_CONNECTING);
    if (status_tunnel == NTCS_CLOSED) {
        CloseTunnel(tunnel);
    }
    return status_tunnel;
}

nabto_status_t Async_ConnectDeviceWithTunnel(nabto_tunnel_t* tunnel, NSString* RemoteId, int RemotePort, int LocalPort){
    if (_SessionStatus == CLOSED) {
        _SessionStatus = OPENED;
        NabtoOpenSession();
    }
    NSString *target = @"127.0.0.1";
    nabto_status_t status = nabtoTunnelOpenTcp(tunnel, nabsession, LocalPort, [RemoteId UTF8String], [target UTF8String],RemotePort);
    if (status == NABTO_OK){
        Tunnel_Open_Number ++;
    }
    return status;
}
NSString* getHomeDir(void) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //return [documentsDir stringByAppendingPathComponent:@"nabto/nabto.bundle/"];
    return [documentsDir stringByAppendingPathComponent:@"nabto/"];
}
nabto_tunnel_state_t CheckConnectStatus(nabto_tunnel_t* tunnel){
    nabto_tunnel_state_t status = NTCS_CLOSED;
    nabtoTunnelInfo(*tunnel, NTI_STATUS, sizeof(status), &status);
    return status;
}
int ReturnErrorCode(nabto_tunnel_t* tunnel){
    int status = 0;
    nabtoTunnelInfo(*tunnel, NTI_LAST_ERROR, sizeof(status), &status);
    return status;
}

static NSMutableString* NabtoLogs = nil;
// Logging mechanism
void nabtoLogCallback(const char* line, size_t size) {
    const size_t interestingStuffStart = 50;
    size_t offset = size > interestingStuffStart ? interestingStuffStart : 0;
    const size_t bufSize = size + 1 - offset;
    char* nullTerminatedString = (char *)malloc(bufSize);
    memcpy(nullTerminatedString, line+offset, size-offset);
    nullTerminatedString[bufSize-1] = 0;
    
    NSData* buffer = [NSData dataWithBytesNoCopy:nullTerminatedString length:bufSize freeWhenDone:YES];
    NSString *entry = [[NSString alloc] initWithBytes:buffer.bytes length:buffer.length encoding:NSASCIIStringEncoding];
    
    if (_NabtoLogStatus == Start) {
        NabtoLogs = [[NSMutableString alloc] init];
        _NabtoLogStatus = Started;
    }
    if (_NabtoLogStatus == Started) {
        [NabtoLogs appendFormat:@"%@\r\n",entry];
    }
    if (LX520log == YES) {
        NSLog(@"Nabto log: %@", entry);
    }
}

void NabtoLogStart(void){
    NSLog(@"NabtoLogStart");
    _NabtoLogStatus = Start;
}
void NabtoLogStop(void){
    NSLog(@"NabtoLogStop");
    _NabtoLogStatus = Stoped;
}

void SaveNabtoLog(NSString* NabtoID){
    NSLog(@"SaveNabtoLog");
    NabtoLogStop();
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"MMddhhmm"];
    NSString* LogName = [[NSString alloc] initWithFormat:@"%@_%@.txt", [formatter stringFromDate:[NSDate date]],NabtoID];
    NSLog(@"NabtoLogs:%@",NabtoLogs);
    NSString* TXTFILE = @"NabtoErrorLog";
    NSData *data =[NabtoLogs dataUsingEncoding:NSUTF8StringEncoding];
    SetDocumentsToPath_NabtoLog(TXTFILE,data,LogName);
}
BOOL SetDocumentsToPath_NabtoLog(NSString* filename, NSData* data, NSString* name)
{
    ///*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *imageDir = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], filename];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"creat dir.");
    }
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:[imageDir stringByAppendingPathComponent:name]];
    imageDir = [imageDir stringByAppendingString:@"/"];
    imageDir = [imageDir stringByAppendingString:name];
    if (result)
    {
        [fileManager removeItemAtPath:imageDir error:nil];
        NSLog(@"delete!");
    }
    BOOL writeResult = [data writeToFile:imageDir atomically:YES];
    if (writeResult)
    {
        NSLog(@"write to path succeed");
        return YES;
    }
    else
    {
        NSLog(@"write to path failure");
        return NO;
    }
    //*/
}
static void nabtoInit(void) {
    // Initialize nabto with home directory set
    NSString* dir = getHomeDir();
    nabto_status_t status = nabtoStartup([dir UTF8String]);
    if (status != NABTO_OK) {
        if (LX520log == YES) {
            NSLog(@"Error setting home dir");
        }
    }
    else {
        if (LX520log == YES) {
            nabtoRegisterLogCallback(nabtoLogCallback);
        }
    }
    if (LX520log == YES) {
        NSLog(@"Nabto initialised");
    }
}

static void NabtoOpenSession(void) {
    // Use guest certificate to open session
    NSString *email = @"guest";
    NSString *pass = @"";//@"foobar";
    //if (LX520log == YES) {
        NSLog(@"Opening nabto session...");
    //}
    nabto_status_t status = nabtoOpenSession(&nabsession, [email UTF8String], [pass UTF8String]);
    
    if (status == NABTO_OPEN_CERT_OR_PK_FAILED) {
        // Attempt to create profile
        status = nabtoCreateProfile([email UTF8String], [pass UTF8String]);
        if (status != NABTO_OK) {
            //if (LX520log == YES) {
                NSLog(@"Failed to create profile");
            //}
            return;
        }
        // Attempt to open session again with newly created profile
        status = nabtoOpenSession(&nabsession, [email UTF8String], [pass UTF8String]);
    }
    _SessionStatus = OPENED;
    //if (LX520log == YES) {
        NSLog(@"Nabto open session status code: %d", status);
    //}
}
@end
