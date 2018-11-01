//
//  CommonFunc.m
//  seanycar_2
//
//  Created by liweixiang on 14-12-28.
//  Copyright (c) 2014年 Rak. All rights reserved.
//

#import "CommonFunc.h"
#import "sys/utsname.h"
@implementation CommonFunc

+ (NSString *)getDeviceSSID
{
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }

    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *ssid = [dctySSID objectForKey:@"SSID"];

    return ssid;
    
}

+ (float)getVolume
{   
    //range: 0~~1.0
    //未解决问题；获取到的初始化音量错误
    float volume =[[MPMusicPlayerController applicationMusicPlayer] volume];
    //NSLog(@"systemVolume is %f", volume);
    return volume;
}

+ (UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (NSString *)stringTrim:(NSString *)str
{
    return [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (void)saveKeyValue:(NSString *)key :(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getKeyValue:(NSString *)key
{
    NSString *utf8key = [NSString stringWithUTF8String:[key UTF8String]];
    return [[NSUserDefaults standardUserDefaults] stringForKey:utf8key];
}

+ (BOOL)checkIsKeyExist:(NSString *)key
{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:key] != nil) {
        return YES;
    }
    return NO;
}

+ (void)removeKeyValue:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+ (void)saveKeyValue_Dic:(NSString *)dicKey :(NSString *)key :(NSString *)value
{
    NSDictionary *dicBuffer = [CommonFunc getKeyValue_Dic:dicKey];
    if (dicBuffer != nil) {
        NSMutableDictionary *mDicbuffer = [[NSMutableDictionary alloc] initWithDictionary:dicBuffer];
        //添加数据
        [mDicbuffer setObject:value forKey:key];
        //NSMutableDictionary转换为NSDictionary
        NSDictionary *result = [[NSDictionary alloc] initWithObjects:[[mDicbuffer objectEnumerator] allObjects] forKeys:[[mDicbuffer keyEnumerator] allObjects]];
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:dicKey];
    }
    else
    {
        dicBuffer = [[NSDictionary alloc] initWithObjectsAndKeys: value, key, nil];
        [[NSUserDefaults standardUserDefaults] setObject:dicBuffer forKey:dicKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)checkIsKeyExistInDic:(NSString *)dictionaryKey :(NSString *)key
{
    NSDictionary *bufferDic = [CommonFunc getKeyValue_Dic:dictionaryKey];
    if ([bufferDic objectForKey:key] != nil) {
        return YES;
    }
    return NO;
}

+ (void)removekeyValue_Dic:(NSString *)dictionaryKey :(NSString *)key
{
    NSDictionary *bufferDic = [CommonFunc getKeyValue_Dic:dictionaryKey];
    if (bufferDic != nil) {
        NSMutableDictionary *mDicbuffer = [[NSMutableDictionary alloc] initWithDictionary:bufferDic];
        [mDicbuffer removeObjectForKey:key];
        bufferDic = [[NSDictionary alloc] initWithObjects:[[mDicbuffer objectEnumerator] allObjects] forKeys:[[mDicbuffer keyEnumerator] allObjects]];
        [[NSUserDefaults standardUserDefaults] setObject:bufferDic forKey:dictionaryKey];
    }
}

+ (NSDictionary *)getKeyValue_Dic:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:key];
}

+ (id)getKeyValue_Dic_string:(NSString *)dicKey :(NSString *)key;
{
    NSDictionary *dicBuffer = [CommonFunc getKeyValue_Dic:dicKey];
    
    return [dicBuffer objectForKey:key];
}

+ (NSString *)saveImageToFile:(NSString *)saveName :(UIImage *)image
{
    // Create paths to output images
    NSString *pngPath =@"Documents/";
    pngPath = [pngPath stringByAppendingFormat:@"%@.png", saveName];
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:pngPath];
    
    // Write image to PNG
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];

    // Let's check to see if files were successfully written...
    
    // Create file manager
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    return pngPath;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)AFBase64EncodedStringFromString:(NSString *)string
{
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

+ (NSString *)timeFormatted:(long)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (NSString *)stringByURLEncodingStringParameter:(NSString *)urlString
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                              (CFStringRef)urlString,
                                                                              NULL,
                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                              kCFStringEncodingUTF8);
    return outputStr;
}

+ (CGRect)screenSize
{
    if (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft ||
         [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) {
        //横屏幕
        CGRect rectBuffer = [UIScreen mainScreen].bounds;
        CGSize sizeBuffer = [UIScreen mainScreen].bounds.size;

        rectBuffer.size = CGSizeMake(MAX(sizeBuffer.width, sizeBuffer.height), MIN(sizeBuffer.width, sizeBuffer.height));
        return rectBuffer;
    }
    return [UIScreen mainScreen].applicationFrame;
}

+ (float)getSystemVersion
{
    float system_version =  [[[UIDevice currentDevice] systemVersion] floatValue];
    return system_version;
}

+ (NSString *)getCurLanguages
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    //NSLog (@"%@" , currentLanguage);
    return currentLanguage;
}

+ (NSString *)getAnimatedType:(AnimatedType)type
{
    NSString *result;
    
    switch (type) {
        case TransitionFadeAnimate:
            result = kCATransitionFade;
            break;
        case TransitionPushAnimate:
            result = kCATransitionPush;
            break;
        case TransitionMoveInAnimate:
            result = kCATransitionMoveIn;
            break;
        case TransitionRevealAnimate:
            result = kCATransitionReveal;
            break;
        case CubeAnimate:
            result = @"cube";
            break;
        case SuckEffectAnimate:
            result = @"suckEffect";
            break;
        case OglFlipAnimate:
            result = @"oglFlip";
            break;
        case RippleEffectAnimate:
            result = @"rippleEffect";
            break;
        case PageCurlAnimate:
            result = @"pageCurl";
            break;
        case PageUnCurlAnimate:
            result = @"pageUnCurl";
            break;
        case CameraIrisHollowOpenAnimate:
            result = @"cameraIrisHollowOpen";
            break;
        case CameraIrisHollowCloseAnimate:
            result = @"cameraIrisHollowClose";
            break;
        default:
            result = kCATransitionPush;
            break;
    }
    return result;
}

+ (UIImage*)createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (void)viewScaleAnim:(UIView *)animView :(CGFloat)scalePercent
{
    CGPoint centerBuffer = animView.center;
    [UIView beginAnimations:@"ViewScale" context:nil];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform newTransform =  CGAffineTransformScale(animView.transform, scalePercent, scalePercent);
    [animView setTransform:newTransform];
    animView.center = centerBuffer;
    if (scalePercent < 1.0)
        [animView setAlpha:0.8];
    else
        [animView setAlpha:1.0];
    [UIView commitAnimations];
}

+ (float)angle2rad:(double)angle
{
    return angle * M_PI / 180;
}

+ (float)rad2angle:(double)rad
{
    return rad / M_PI * 180;
}

+ (void)copyToClipboard:(NSString *)object
{
    [[UIPasteboard generalPasteboard] setPersistent:YES];
    [[UIPasteboard generalPasteboard] setValue:object forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
}

+ (BOOL)isContainsString:(NSString *)originalString :(NSString *)string
{
    NSRange range = [originalString rangeOfString:string];
    return range.length != 0;
}

+ (CGFloat)getLabelTextPixeWidth:(UILabel *)label
{
    return [label.text sizeWithFont:label.font].width;
}

+ (CGFloat)getLabelTextPixeHeight:(UILabel *)label
{
    return [label.text sizeWithFont:label.font].height;
}

+ (CGPoint)getRotatePos:(CGPoint )center :(CGFloat)rad :(CGFloat)degree;
{
    double rotateAngle = [CommonFunc angle2rad:degree];
    double rotateX = center.x + sin(rotateAngle) * rad;
    double rotateY = center.y - cos(rotateAngle) * rad;

    return CGPointMake(rotateX, rotateY);
}

+ (CGPoint)getPosFromPoints:(CGPoint)firstPos :(CGPoint)secondsPos
{
    return CGPointMake((firstPos.x + secondsPos.x) / 2, (firstPos.y + secondsPos.y) / 2);
}

+ (BOOL)getCurrenDeviceIsIpad
{
    NSString *deviceName = [UIDevice currentDevice].model;
    return [CommonFunc isContainsString:deviceName :@"iPad"];
}

+ (double)getCurSystemVersion
{
    return [[UIDevice currentDevice].systemVersion doubleValue];
}

+ (float)ms2mph: (float)value
{
    return value / 0.44704;
}

+ (NSString *)getStringFromMavState: (MAV_STATE)state
{
    switch (state) {
        case MAV_STATE_BOOT: /* System is booting up. | */
            return @"Boot";
        case MAV_STATE_CALIBRATING: /* System is calibrating and not flight-ready. | */
            return @"Calibrating";
        case MAV_STATE_STANDBY: /* System is grounded and on standby. It can be launched any time. | */
            return @"Standby";
        case MAV_STATE_ACTIVE: /* System is active and might be already airborne. Motors are engaged. | */
            return @"Active";
        case MAV_STATE_CRITICAL: /* System is in a non-normal flight mode. It can however still navigate. | */
            return @"Critical";
        case MAV_STATE_EMERGENCY: /* System is in a non-normal flight mode. It lost control over parts or over the whole airframe. It is in mayday and going down. | */
            return @"Emergency";
        case MAV_STATE_POWEROFF: /* System just initialized its power-down sequence, will shut down now. | */
            return @"Poweroff";
            default: return @"Unknown";
    }
}

+ (void)addCornerToView:(UIView *)view :(UIRectCorner)scope :(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:scope cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
@end
