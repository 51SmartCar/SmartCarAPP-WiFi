//
//  AudioRecord.m
//  main
//
//  Created by weimac on 14/12/25.
//  Copyright (c) 2014年 weimac. All rights reserved.
//

#import "AudioRecord.h"

@implementation AudioRecord
-(id) init{
    self = [super init];
    if (self){
        [self AudioRecordInit];
    }
    return  self;
}
-(void)AudioRecordInit{
    NSLog(@"AudioRecordInit");
    self.isRecording = NO;
    recordedFile = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/AudioRecord.caf"]];
    //录音设置
    recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM  kAudioFormatALaw
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatULaw] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    //编码比特率
    [recordSetting setValue:[NSNumber numberWithFloat:128000] forKey:AVEncoderBitRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量 AVAudioQualityMin /AVAudioQualityLow /AVAudioQualityMedium /AVAudioQualityHigh /AVAudioQualityMax
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
}
- (void)StartRecord{
    if(self.isRecording == NO)
    {
        self.isRecording = YES;
        session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
        
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSetting error:nil];
        [recorder prepareToRecord];
        [recorder record];
    }
}
- (NSData*)StopRecord{
    if(self.isRecording == YES)
    {
        self.isRecording = NO;
        [recorder stop];
        [session setCategory:AVAudioSessionCategoryAmbient error:nil];
        
        //[session setActive:NO error:nil];
        recorder = nil;
        NSData *reader = [NSData dataWithContentsOfURL:recordedFile];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:recordedFile error:nil];
        return reader;
    }
    return nil;
}

-(void)dealloc{
    if (recordedFile) {
        recordedFile = nil;
    }
    if (player) {
        player = nil;
    }
    if (recorder) {
        recorder = nil;
    }
    if (recordSetting) {
        recordSetting = nil;
    }
    if (session) {
        session = nil;
    }
   // NSLog(@"AudioRecord is released.");
}
@end
