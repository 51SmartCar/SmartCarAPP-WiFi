//
//  MediaData.h
//  Feishen
//
//  Created by rakwireless on 15/12/21.
//  Copyright © 2015年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaData : NSObject
#pragma mark 日期
@property (nonatomic,copy) NSString *Date;
#pragma mark 名字
@property (nonatomic,copy) NSString *Name;
#pragma mark 链接
@property (nonatomic,copy) NSString *Url;
#pragma mark 时间戳
@property (nonatomic,copy) NSString *Timesamp;
#pragma mark 缩略图
@property (nonatomic,copy) NSObject *Image;

#pragma mark 带参数的构造函数
-(MediaData *)initWithDate:(NSString *)Date andName:(NSString *)Name andUrl:(NSString *)Url andTimesamp:(NSString *)Timesamp andImage:(NSObject *)image;

#pragma mark 取得名字
-(NSString *)getName;
-(NSString *)getDate;
-(NSString *)getUrl;
-(NSString *)getTimesamp;
-(NSObject *)getImage;

#pragma mark 带参数的静态对象初始化方法
+(MediaData *)initWithDate:(NSString *)Date andName:(NSString *)Name andUrl:(NSString *)Url andTimesamp:(NSString *)Timesamp andImage:(NSObject *)image;
@end
