//
//  HttpRequest.m
//  EasyConfig
//
//  Created by weimac on 15/1/14.
//  Copyright (c) 2015年 cz. All rights reserved.
//

#import "HttpRequest.h"
#import "BASE64.h"
@implementation HttpRequest
+(HttpRequest*)HTTPRequestWithUrl:(NSString*)HttpURL andData:(NSString*)PostData andMethod:(NSString*)Method andUserName:(NSString*)UserName andPassword:(NSString*)Password{
    HttpRequest* _HttpRequest = [[HttpRequest alloc]init];
    NSString* BasicStr = [[NSString alloc] initWithFormat:@"%@:%@",UserName,Password];
    NSString* admindata = [BASE64 encodeBase64String:BasicStr];
    NSString* data = [[NSString alloc]initWithFormat:@"Basic %@",admindata];
//    NSLog(@"admindata:%@",data);
    NSData* postData;
    if (PostData.length > 0) {
        postData = [PostData dataUsingEncoding:NSUTF8StringEncoding];
    }
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    //NSString *postLength = @"1024";
//    NSLog(@"postLength=%@",postLength);
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    NSString* URL = HttpURL;//;
    [request setURL:[NSURL URLWithString:URL]];
    //设置提交方式为 POST
    [request setHTTPMethod:Method];
    //设置http-header:Content-Type，
    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [request setValue:data forHTTPHeaderField:@"Authorization"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    if (PostData.length > 0) {
        [request setHTTPBody:postData];
    }
    [request setTimeoutInterval:5.0];
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    //NSLog(@"request:%@",request);
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //NSLog(@"statusCode:%ld",(long)urlResponse.statusCode);
    _HttpRequest.StatusCode = (int)urlResponse.statusCode;
    if (_HttpRequest.StatusCode==200) {
        _HttpRequest.ContentLength = (int)[urlResponse.allHeaderFields.allValues[0] intValue];
        _HttpRequest.Server = urlResponse.allHeaderFields.allValues[1];
        //_HttpRequest.ContentType = urlResponse.allHeaderFields.allValues[2];
        //_HttpRequest.Connection = urlResponse.allHeaderFields.allValues[3];
        _HttpRequest.ResponseData = responseData;
        NSLog(@"urlResponse:%@",urlResponse);
    }
    if (responseData == nil) {
        NSLog(@"send request failed: %@", error);
        //return;
    }
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    _HttpRequest.ResponseString = result;
    NSLog(@"user login check result:%@",result);
    
//    if ([@"success" compare:result]==NSOrderedSame) {
//        return;
//    }
    return _HttpRequest;
}
@end
