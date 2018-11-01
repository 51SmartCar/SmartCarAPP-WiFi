//
//  AnalyticalHTML.m
//  EasyConfig
//
//  Created by weimac on 15/1/14.
//  Copyright (c) 2015年 cz. All rights reserved.
//

#import "AnalyticalHTML.h"
#import "TFHpple.h"
@implementation AnalyticalHTML
+(AnalyticalHTML*)AnalyticalHTMLWithData:(NSData *)htmlData andPath:(NSString*)Path{
    AnalyticalHTML* _AnalyticalHTML = [[AnalyticalHTML alloc] init];
    _AnalyticalHTML.SSID = [[NSMutableArray alloc] init];
    _AnalyticalHTML.BSSID = [[NSMutableArray alloc] init];
    _AnalyticalHTML.CHAN = [[NSMutableArray alloc] init];
    _AnalyticalHTML.RSSI = [[NSMutableArray alloc] init];
    
    TFHpple *xpathparser = [[TFHpple alloc]initWithHTMLData:htmlData];
    NSArray *array1 = [xpathparser searchWithXPathQuery:Path];
    int arrnum = 0;
    int _AnalyticalHTMLnum = 0;
    for (int i = 0; i < array1.count; i++) {
        TFHppleElement *element = [array1 objectAtIndex:i];
        if ([element content] != nil) {
            NSString* Str = [element content];
            if ([Str isEqualToString:@"SSID"]) {
                arrnum = 1;
                i += 4;
            }else{
                if (arrnum == 1) {
                    _AnalyticalHTML.SSID[_AnalyticalHTMLnum] = Str;
                    arrnum = 2;
                }else if (arrnum == 2) {
                    _AnalyticalHTML.BSSID[_AnalyticalHTMLnum] = Str;
                    arrnum = 3;
                }else if (arrnum == 3) {
                    _AnalyticalHTML.CHAN[_AnalyticalHTMLnum] = Str;
                    arrnum = 4;
                }else if (arrnum == 4) {
                    _AnalyticalHTML.RSSI[_AnalyticalHTMLnum] = Str;
                    arrnum = 1;
                    _AnalyticalHTMLnum ++;
                    i++;
                }
            }
        }
        //NSLog(@"%@", [element content]);
    }
    return _AnalyticalHTML;
}

@end
