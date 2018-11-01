//
//  LX520.h
//  Lx520Demo
//
//  Created by liweixiang on 15/5/15.
//  Copyright (c) 2015年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LX520Delegate <NSObject>
/*
 state:
 STATE_IDLE = 0,
 STATE_PREPARING = 1,
 STATE_PLAYING = 2,
 STATE_STOPPED = 3
 */
- (void)state_changed:(int)state;//回调显示正常播放的时状态
- (void)video_info:(NSString *)codecName codecLongName:(NSString *)codecLongName;//视频格式
- (void)audio_info:(NSString *)codecName codecLongName:(NSString *)codecLongName sampleRate:(int)sampleRate channels:(int)channels;//音频格式
- (void)take_photo:(UIImage *)image;//回调获取拍照后的image
- (void)take_imageRef:(CGImageRef)imageRef;//回调获取rgb555 le格式的imageRef
- (void)GetYUVData:(int)width :(int)height
                  :(Byte*)yData :(Byte*)uData :(Byte*)vData
                  :(int)ySize :(int)uSize :(int)vSize;//回调获取解码后的YUV数据
- (void)GetH264Data:(int)width :(int)height :(int)size :(Byte*)data;//回调获取H264数据
@end

@interface LX520View : UIView
- (id)init;//初始化
- (id)initWithFrame:(CGRect)frame;//初始化一个视频播放的view
- (id)initWithFrame2:(CGRect)frame :(CGRect)frame1 : (CGRect)frame2;//初始化两个视频播放的view
- (void)setView1Frame:(CGRect)frame;//设置第一个view的frame
- (void)setView2Frame:(CGRect)frame;//设置第二个view的frame
- (void)addView2WithFrame:(CGRect)frame;//用添加的方式添加第二个view
- (void)removeView2;//移除第二个view
- (CGRect)getView1Frame;//获取第一个view的frame
- (CGRect)getView2Frame;//获取第二个view的frame
- (void)setView1Hidden:(BOOL)isHidden;//设置第一个view的可见性
- (void)setView2Hidden:(BOOL)isHidden;//设置第二个view的可见性
- (void)play:(NSString *)url useTcp:(BOOL)useTcp;//开始播放视频 url:RTSP链接地址 useTcp: true:使用TCP  false:使用UDP
- (void)stop;//停止播放视频
- (void)sound:(BOOL)play;//开启或关闭声音 play: true:开启声音  false:关闭声音
- (void)take_photo;//拍照，调用后即可通过回调获得image数据
- (void)take_imageRef:(BOOL)take;//调用后即可通过回调获得rgb555 le格式的imageRef
- (void)begin_record:(int)type;//type: 0:ffmpeg录制  1:mp4v2录制   默认存储到相册
- (void)begin_record2:(int)type :(NSString *)path;//type: 0:ffmpeg录制  1:mp4v2录制  path:录制视频的存储路径
- (void)end_record;//结束录制
- (void)set_record_frame_rate:(int)bit_rate;//设置录像帧率
- (void)delegate:(id<LX520Delegate>)d;//代理
/*
 LOG_LEVEL_VERBOSE 0
 LOG_LEVEL_DEBUG 1
 LOG_LEVEL_INFO 2
 LOG_LEVEL_ERROR 3
 LOG_LEVEL_QUIET 4
 */
- (void)set_log_level:(int)level;//设置打印级别
- (void)hardwareDecoder:(BOOL)enable;//使能硬件解码，使能后即可通过回调获得h264数据
- (void)startGetYUVData:(BOOL)start;//使能后即可通过回调获取解码后的YUV数据
@end
