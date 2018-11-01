//
//  MediaGroup.m
//  Feishen
//
//  Created by rakwireless on 15/12/21.
//  Copyright © 2015年 rak. All rights reserved.
//

#import "MediaGroup.h"
#import "MediaData.h"

@implementation MediaGroup
-(MediaGroup *)initWithName:(NSString *)name andMedias:(NSMutableArray *)medias{
    if (self=[super init]) {
        self.name=name;
        self.medias=medias;
    }
    return self;
}

-(NSString *)getName{
    return [NSString stringWithFormat:@"%@",_name];
}

-(NSMutableArray *)getMedias{
    return _medias;
}

-(void)getMedias:(NSMutableArray *)medias{
    _medias= medias;
}
    
+(MediaGroup *)initWithName:(NSString *)name andMedias:(NSMutableArray *)medias{
    MediaGroup *group1=[[MediaGroup alloc]initWithName:name andMedias:medias];
    return group1;
}


@end
