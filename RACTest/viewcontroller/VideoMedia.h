//
//  VideoMedia.h
//  AoSmart
//
//  Created by rakwireless on 16/1/25.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoMedia : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_videoMediaBack;
    UILabel  *_videoMediaTitle;
    UITableView *_videoMediaTable;
}
@end
