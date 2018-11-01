//
//  EasyConfig.m
//  EasyConfig
//
//  Created by wei-mac on 14-4-9.
//  Copyright (c) 2014年 cz. All rights reserved.
//

#import "EasyConfig.h"
#import "GCDAsyncUdpSocket.h"
#import "SendPacket.h"

#include <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
static SendPacket *_SendPacket;

static GCDAsyncUdpSocket *rak_send_udpSocket = nil;
static GCDAsyncUdpSocket *rak_rev_udpSocket = nil;
static GCDAsyncUdpSocket *rak410_rev_udpSocket = nil;
static NSTimer *UdpSocket_rev_timer=nil;
#define UdpSocket_rev_timer_Value 1
static BOOL connect_flg = NO;
static NSMutableArray *macarray;
static NSString *broadcast_addr;
@implementation EasyConfig

-(id) init:(id<EasyConfigDelegate>)delegate{
    self = [super init];
    if (self){
        self.delegate= delegate;//[delegate retain];
    }
    broadcast_addr = [self routerIp];
    //broadcast_addr = @"255.255.255.255";
   // NSLog(@"broadcast_addr:%@",broadcast_addr);
    return  self;
}
- (NSString *) routerIp {
    
    NSString *address = @"error";
    NSString *broadcast_addr = @"error";
    NSString *netmask = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        //*/
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String //ifa_addr
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    broadcast_addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    //广播地址
                    //NSLog(@"broadcast address--%@",broadcast_addr);
                    //本机地址
                    //NSLog(@"local device ip--%@",address);
                    //子网掩码地址
                    //NSLog(@"netmask--%@",netmask);
                    //端口地址
                    //NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return broadcast_addr;
}
- (void)SendDataWithPsk:(NSString *)psk andSSID:(NSString*)SSID{
    macarray = [[NSMutableArray alloc] init];
    [macarray removeAllObjects];
    if (rak_rev_udpSocket != NULL) {
        [rak_rev_udpSocket close];
        rak_rev_udpSocket = NULL;
    }
    if (rak410_rev_udpSocket != NULL) {
        [rak410_rev_udpSocket close];
        rak410_rev_udpSocket = NULL;
    }
    rak_rev_udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [rak_rev_udpSocket bindToPort:55556 error: nil];
    [rak_rev_udpSocket beginReceiving:nil];
    [rak_rev_udpSocket enableBroadcast:YES error:nil];
    
    rak410_rev_udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [rak410_rev_udpSocket bindToPort:25000 error: nil];
    [rak410_rev_udpSocket beginReceiving:nil];
    [rak410_rev_udpSocket enableBroadcast:NO error:nil];
    
    UdpSocket_rev_timer=[NSTimer scheduledTimerWithTimeInterval:UdpSocket_rev_timer_Value
                                            target:self
                                          selector:@selector(UdpSocket_rev_timer_callback:)
                                          userInfo:nil
                                           repeats:YES];

    _SendPacket=[[SendPacket alloc] initWithPSK:psk andssid:SSID];
    NSThread *send = [[NSThread alloc] initWithTarget:self selector:@selector(sendWithPacket:)object:_SendPacket];
    [send start];
 
}

-(void)UdpSocket_rev_timer_callback:(NSTimer *)onTimer{

    [rak_rev_udpSocket sendData:[@"@LT_EASY_DEVICE@" dataUsingEncoding: NSUTF8StringEncoding] toHost:broadcast_addr port:55555 withTimeout:-1 tag:0];
}
- (void)stop_send{
    //NSLog(@"connect end.");
    connect_flg = NO;
    [UdpSocket_rev_timer setFireDate:[NSDate distantFuture]];
    if (rak_send_udpSocket != NULL) {
        [rak_send_udpSocket close];
        rak_send_udpSocket = NULL;
    }
    if (rak_rev_udpSocket != NULL) {
        [rak_rev_udpSocket close];
        rak_rev_udpSocket = NULL;
    }
    if (rak410_rev_udpSocket != NULL) {
        [rak410_rev_udpSocket close];
        rak410_rev_udpSocket = NULL;
    }
}
- (void)sendWithPacket:(SendPacket *)info{
    connect_flg = YES;
    if (rak_send_udpSocket != NULL) {
        [rak_send_udpSocket close];
        rak_send_udpSocket = NULL;
    }
    rak_send_udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
   // [rak_send_udpSocket enableBroadcast:YES error:nil];
   // NSLog(@"start:");
    long Tag = 0;
    while (connect_flg == YES) {
        NSData *data1 = [self getByte:20];
        NSData *data2 = [self getByte:2];
        NSData *data3 = [self getByte:150];
        NSData *data4 = [self getByte:30];

        for (int i = 0; i < 2; i++) {//发送4次,头部
            [self sendData:data1 andip:@"228.4.5.6" andport:12345 andtag:Tag];
            Tag ++;
            [self sendData:data2 andip:@"228.4.5.6" andport:12345 andtag:Tag];
            Tag ++;
        }
        NSString *mac_str = nil;
        for (int j=1; j<=info.pskssid_len/2; j++) {
            mac_str=[self mac2ipWithNMac1:info.pskssid[(j-1)*2] andMac2:info.pskssid[(j-1)*2+1] andIndex:j];
            [self sendData:data3 andip:mac_str andport:12345 andtag:Tag];
            Tag ++;
        }
        [self sendData:data4 andip:mac_str andport:12345 andtag:Tag];
        Tag ++;
    }
    //NSLog(@"stop.");
    
    if (rak_send_udpSocket != NULL) {
        [rak_send_udpSocket close];
        rak_send_udpSocket = NULL;
    }
    if (rak_rev_udpSocket != NULL) {
        [rak_rev_udpSocket close];
        rak_rev_udpSocket = NULL;
    }
    if (rak410_rev_udpSocket != NULL) {
        [rak410_rev_udpSocket close];
        rak410_rev_udpSocket = NULL;
    }
}
-(void)sendData:(NSData*)data andip:(NSString *)ip andport:(int)port andtag:(long)tag {
    //printf(".");
    //dispatch_async(dispatch_get_main_queue(),^ {
        [rak_send_udpSocket sendData:data toHost:ip port:port withTimeout:-1 tag:tag];
    //});
    [NSThread sleepForTimeInterval:0.01f];//12ms
}
-(NSString *)mac2ipWithNMac1:(Byte)mac1 andMac2:(Byte)mac2 andIndex:(int)index{
    NSString *mac=nil;
    int mac_1=0,mac_2=0;
    if (mac1<0) {
        mac_1=mac1+256;
    }else{
        mac_1=mac1;
    }
    if (mac2<0) {
        mac_2=mac2+256;
    }else{
        mac_2=mac2;
    }
    mac=[[NSString alloc] initWithFormat:@"228.%d.%d.%d",index,mac_1,mac_2];
    return mac;
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	// You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	// You could add checks here
}

//RecvPacket *smartRecvPacket;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    if ((data==nil)||(data.length<42)) {
        return;
    }
    
    Byte *dip = (Byte *)[address bytes];
    NSMutableString *_ip=[[NSMutableString alloc]init];
    NSMutableString *_id=[[NSMutableString alloc]init];
    [_ip appendFormat:@"%d.%d.%d.%d",dip[4],dip[5],dip[6],dip[7]];
    if ([_ip isEqualToString:@"0.0.0.0"]) {
        return;
    }
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    aString=[aString substringFromIndex:43];
    RecvPacket *smartRecvPacket=[[RecvPacket alloc] init];
    smartRecvPacket.module_id = @"";
    smartRecvPacket.module_ip = @"";
    if (aString==nil) {
        return;
    }
    [_id appendString:aString];
    smartRecvPacket.module_id = _id;
    smartRecvPacket.module_ip = _ip;
    if ([_delegate respondsToSelector:@selector(RecvWithPacket:)]) {
        [_delegate RecvWithPacket:smartRecvPacket];
    }
    return;
}

-(NSData*)getByte:(int)length {
    Byte bytes[length];
    memset(bytes, 0, sizeof(bytes));
    NSData *data = [[NSData alloc]initWithBytes:&bytes length:length];
    return data;
}

@end
