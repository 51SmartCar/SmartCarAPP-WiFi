//
//  MediaGroup.h
//  Feishen
//
//  Created by rakwireless on 15/12/21.
//  Copyright © 2015年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaData.h"

@interface MediaGroup : NSObject
#pragma mark 组名
@property (nonatomic,copy) NSString *name;

#pragma mark 组成员
@property (nonatomic,strong) NSMutableArray *medias;
-(NSString *)getName;
-(NSMutableArray *)getMedias;
-(void)getMedias:(NSMutableArray *)medias;

#pragma mark 带参数个构造函数
-(MediaGroup *)initWithName:(NSString *)name andMedias:(NSMutableArray *)medias;

#pragma mark 静态初始化方法
+(MediaGroup *)initWithName:(NSString *)name andMedias:(NSMutableArray *)medias;
@end
