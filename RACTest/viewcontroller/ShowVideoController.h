//
//  ShowVideoController.h
//  Feishen
//
//  Created by rakwireless on 15/11/6.
//  Copyright © 2015年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowVideoController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UIImageView* bgShowVideo;
    UIButton* btnShowVideoBack;
    UITableView *ShowVideoTableview;
    UILabel *lableEditVideo;
}
@end
