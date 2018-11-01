//
//  CommonFunc.h
//  seanycar_2
//
//  Created by liweixiang on 14-12-28.
//  Copyright (c) 2014年 Rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "mavlink.h"

#define REMOTEPORTPLAY 5555
#define REMOTEPORTMAPPING 6666
#define REMOTECONNECTTIMEOUT 20
#define SCANDEVICETIMROUT 3000.0f     //设备扫描超时时间
#define UARTINTERVAL 10.0            //UART间隔发送时间
#define ENABLE_VIDEO
#define ENABLE_REMOTE
#define ENABLE_LOGIN
typedef enum {
    defaultTypeAnimate = 0,
    TransitionFadeAnimate,
    TransitionPushAnimate,
    TransitionMoveInAnimate,
    TransitionRevealAnimate,
    CubeAnimate,
    SuckEffectAnimate,
    OglFlipAnimate,
    RippleEffectAnimate,
    PageCurlAnimate,
    PageUnCurlAnimate,
    CameraIrisHollowOpenAnimate,
    CameraIrisHollowCloseAnimate
}AnimatedType;

typedef enum {
    SingleShot = 0,
    ThreeShot,
    FiveShot,
    TenShot
}CameraSetype;

typedef enum {
    FiveM = 0,
    EightM,
    TwelveM,
    SixteenM
}ResoluteSetype;

typedef enum {
    Auto = 0,
    Sunlight,
    Cloudy,
    Fluorescent,
    Incandescent
}WhiteBalanceSetype;

typedef enum {
    FixedPointMode = 0,
    FixedHeightMode,
    HeadlessMode
}OtherSetype;

typedef enum {
    Back = 0,
    Land
}UncontrolType;
@interface CommonFunc : NSObject

+ (NSString *) getDeviceSSID;
+ (float)getVolume;
+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;     //图片重绘 改变大小
+ (NSString *)stringTrim:(NSString *)str;

+ (void)saveKeyValue:(NSString *)key :(NSString *)value;        //存放 持久化数据
+ (NSString *)getKeyValue:(NSString *)key;              //取出 持久化数据
+ (BOOL)checkIsKeyExist:(NSString *)key;                //检查是否存在key值
+ (void)removeKeyValue:(NSString *)key;                    //删除 持久化数据

+ (NSDictionary *)getKeyValue_Dic:(NSString *)key;                      //取出 字典型持久化数据
+ (id)getKeyValue_Dic_string:(NSString *)dicKey :(NSString *)key;                       //取出 字典型持久化数据
+ (void)saveKeyValue_Dic:(NSString *)dicKey :(NSString *)key :(NSString *)value;    //保存 字典型持久化数据
+ (BOOL)checkIsKeyExistInDic:(NSString *)dictionaryKey :(NSString *)key;    //检查指定字典里面是否存在key
+ (void)removekeyValue_Dic:(NSString *)dictionaryKey :(NSString *)key; //删除指定字典里面的key value

+ (NSString *)saveImageToFile:(NSString *)saveName :(UIImage *)image;           //保存图片到相册
+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)AFBase64EncodedStringFromString:(NSString *)string;
+ (NSString *)timeFormatted:(long)totalSeconds;
+ (NSString *)stringByURLEncodingStringParameter:(NSString *)urlString;

+ (CGRect)screenSize;           //因为ios7及其以下在获取屏幕大小的时候不会因为横竖屏而改变尺寸，所谓该方法用于适配屏幕旋转时获取大小
+ (NSString *)getCurLanguages;  //获取当前系统语言
+ (NSString *)getAnimatedType:(AnimatedType)type;       //获取viewcontroller切换动画
+ (UIImage*)createImageWithColor: (UIColor*)color;
+ (void)viewScaleAnim:(UIView *)animView :(CGFloat)scalePercent;               //放大缩小view
+ (float)rad2angle:(double)rad;
+ (float)angle2rad:(double)angle;   //角度转换为弧度
+ (void)copyToClipboard:(NSString *)object; //保存数据到剪切版
+ (BOOL)isContainsString:(NSString *)originalString :(NSString *)string;        //检测string是否包含在originalString中
+ (CGFloat)getLabelTextPixeWidth:(UILabel *)label;              //获取label的文字占的长度
+ (CGFloat)getLabelTextPixeHeight:(UILabel *)label;              //获取label的文字占的高度
+ (CGPoint)getRotatePos:(CGPoint )center :(CGFloat)rad :(CGFloat)degree;      //根据圆心获取旋转一定角度后的圆周上的坐标
+ (CGPoint)getPosFromPoints:(CGPoint)firstPos :(CGPoint)secondsPos; //获取两点之间的pos

+ (BOOL)getCurrenDeviceIsIpad;
+ (double)getCurSystemVersion;
+ (float)ms2mph:(float)value;

+ (NSString *)getStringFromMavState:(MAV_STATE)state;
+ (float)getSystemVersion;

+ (void)addCornerToView:(UIView *)view :(UIRectCorner)scope :(CGFloat)radius;
@end
