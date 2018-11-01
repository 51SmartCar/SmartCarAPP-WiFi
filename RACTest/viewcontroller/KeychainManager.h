//
//  KeychainManager.h
//  camSight
//
//  Created by rakwireless on 16/8/5.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainManager : NSObject
+(KeychainManager*)default;
//根据字典存储对象到钥匙串
- (void)save:(NSString *)service data:(id)data;
//根据字典读取钥匙串里的对象
- (id)load:(NSString *)service;
//删除钥匙串里的数据
- (void)delete:(NSString *)service;
@end
