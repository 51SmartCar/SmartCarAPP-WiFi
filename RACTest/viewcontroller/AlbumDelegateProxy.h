//
//  AlbumDelegateProxy.h
//  camSight
//
//  Created by rakwireless on 16/8/4.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumObject.h"

@interface AlbumDelegateProxy : NSObject

@property(atomic,assign) id<AlbumDelegate> delegate;

@end
