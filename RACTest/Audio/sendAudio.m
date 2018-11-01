//
//  sendAudio.m
//  audiotest
//
//  Created by 韦伟 on 15/7/31.
//  Copyright (c) 2015年 william.wei. All rights reserved.
//

#import "sendAudio.h"
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
@implementation sendAudio
static int creatsocket(void){
    int socket_num = socket(AF_INET, SOCK_STREAM, 0);
    if (socket_num < 0) {
        return -1;
    }
    return socket_num;
}
static int connect_tcp(int socket_num,const char *ip,uint16_t port)
{
    struct linger _linger;
    _linger.l_onoff = TRUE;
    _linger.l_linger = 30;
    setsockopt(socket_num, SOL_SOCKET, SO_LINGER, &_linger, sizeof(_linger));
    
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr.s_addr = inet_addr(ip);
    socketParameters.sin_port = htons(port);
    int ret = connect(socket_num, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
    if (ret < 0) {
        close(socket_num);
        return -2;
    }
    return ret;
}
+(void)sendWithIp:(NSString*)IP port:(int)PORT data:(NSData*)PCMUDATA{
    int sendSocket = -1;
    const Byte* b_data = [PCMUDATA bytes];
    sendSocket = creatsocket();
    int flg = connect_tcp(sendSocket,[IP UTF8String],PORT);
    if (flg < 0) {
        NSLog(@"connect socket error!");
        return;
    }
    NSLog(@"TCP connect ok!");
    
    NSMutableString* options = [[NSMutableString alloc] init];
    [options appendFormat:@"POST /audio.input HTTP/1.1\r\n"];
    [options appendFormat:@"Host: %@\r\n",IP];
    [options appendFormat:@"Content-Type: audio/wav\r\n"];
    [options appendFormat:@"Content-Length: %d\r\n",(int)PCMUDATA.length];
    [options appendFormat:@"Connection: keepalive\r\n"];
    [options appendFormat:@"Accept: */*\r\n\r\n"];
    NSLog(@"HTTP POST-> %@",options);
    NSData* data_d = [options dataUsingEncoding:NSASCIIStringEncoding];
    const Byte* aaa = [data_d bytes];
    send(sendSocket,aaa, data_d.length,0);
    int len = (int)PCMUDATA.length;
    int p = 0;
    int fpblen = 1024;//4096
    [NSThread sleepForTimeInterval:0.1];
    long sendLen = 0;
    while (len) {
        if (len > fpblen) {
            sendLen = send(sendSocket, &b_data[p], fpblen, 0);
            len -= fpblen;
            p += fpblen;
        }
        else{
            sendLen = send(sendSocket, &b_data[p], len,0);
            len = 0;
        }
        NSLog(@"sendLen = %d",(int)sendLen);
    }
    NSLog(@"send end");
    NSLog(@"close socket = %d",close(sendSocket));
    sendSocket = -1;
    return;
}
@end
