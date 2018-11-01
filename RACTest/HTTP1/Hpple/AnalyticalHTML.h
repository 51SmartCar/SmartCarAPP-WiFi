//
//  AnalyticalHTML.h
//  EasyConfig
//
//  Created by weimac on 15/1/14.
//  Copyright (c) 2015年 cz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticalHTML : NSObject

@property (nonatomic) NSMutableArray* SSID;
@property (nonatomic) NSMutableArray* BSSID;
@property (nonatomic) NSMutableArray* CHAN;
@property (nonatomic) NSMutableArray* RSSI;
+(AnalyticalHTML*)AnalyticalHTMLWithData:(NSData *)htmlData andPath:(NSString*)Path;
@end
