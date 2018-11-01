//
//  SendPacket.m
//  EasyConfig
//
//  Created by wei-mac on 14-4-9.
//  Copyright (c) 2014年 cz. All rights reserved.
//

#import "SendPacket.h"

@implementation SendPacket

static Byte pskssid[128];
static Byte ee_pskssid[128];
static Byte *pskssidByte;
-(id)initWithPSK:(NSString *)pskStr andssid:(NSString*)ssidStr{

    //if (self=[super init]) {
    memset(pskssid, 0, sizeof(pskssid));
    memset(ee_pskssid, 0, sizeof(ee_pskssid));
    
    if ((pskStr.length==0)&&(ssidStr.length==0)) {
        self.pskssid_len = 16;
        self.pskssid=ee_pskssid;
    }else if ((pskStr.length==0)&&(ssidStr.length > 0)) {
        NSData *ssidData=[ssidStr dataUsingEncoding:NSUTF8StringEncoding];
        
        pskssidByte=(Byte *)[ssidData bytes];
        for(int i=0;i<ssidData.length;i++) {
            pskssid[1+i] = pskssidByte[i];
        }
        self.pskssid_len = (int)ssidData.length + 1;
        int i = self.pskssid_len / 16;
        int j = self.pskssid_len % 16;
        if (j > 0) {
            self.pskssid_len = (i+1) * 16;
        }
        else{
            self.pskssid_len = i * 16;
        }
        [self encrypt:self.pskssid_len byte1:pskssid  byte2:ee_pskssid];
        self.pskssid=ee_pskssid;
    }else if ((pskStr.length > 0)&&(ssidStr.length == 0)) {
        NSData *pskData=[pskStr dataUsingEncoding:NSUTF8StringEncoding];
        
        pskssidByte=(Byte *)[pskData bytes];
        for(int i=0;i<pskData.length;i++) {
            pskssid[i] = pskssidByte[i];
        }
        self.pskssid_len = (int)pskData.length;
        int i = self.pskssid_len / 16;
        int j = self.pskssid_len % 16;
        if (j > 0) {
            self.pskssid_len = (i+1) * 16;
        }
        else{
            self.pskssid_len = i * 16;
        }
        [self encrypt:self.pskssid_len byte1:pskssid  byte2:ee_pskssid];
        self.pskssid=ee_pskssid;
    }else if ((pskStr.length > 0)&&(ssidStr.length > 0)) {
        NSData *pskData=[pskStr dataUsingEncoding:NSUTF8StringEncoding];
        NSData *ssidData=[ssidStr dataUsingEncoding:NSUTF8StringEncoding];
        Byte* pskByte=(Byte *)[pskData bytes];
        Byte* ssidByte=(Byte *)[ssidData bytes];
        for(int i=0;i<pskData.length;i++) {
            pskssid[i] = pskByte[i];
        }
        for(int i=0;i<ssidData.length;i++) {
            pskssid[1+pskData.length+i] = ssidByte[i];
        }
        self.pskssid_len = (int)pskData.length + (int)ssidData.length + 1;
        int i = self.pskssid_len / 16;
        int j = self.pskssid_len % 16;
        if (j > 0) {
            self.pskssid_len = (i+1) * 16;
        }
        else{
            self.pskssid_len = i * 16;
        }
        [self encrypt:self.pskssid_len byte1:pskssid  byte2:ee_pskssid];
        self.pskssid=ee_pskssid;
    }
    return self;
}
-(int)encrypt:(int)size byte1:(Byte*)byte1 byte2:(Byte*)byte2 {
    Byte h[] = {52,42,7,44,28,57,60,86,32,44,9,47,27,96,54,49};
    void* rk;
    rk = aes_encrypt_init(h, 16);//AES加密初始化
    
    if (rk == nil) {
        return 0;
    }
    aes_encrypt(rk, byte1, byte2);
    int len = 0;
    do{
        size -= 16;
        len += 16;
        if (size > 0) {
            aes_encrypt(rk, byte1+len, byte2+len);
        }
    }while (size);
    
    aes_encrypt_deinit(rk);
    return 1;
}
@end
