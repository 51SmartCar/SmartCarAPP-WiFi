//
//  PlayBackFolderList.h
//  AoSmart
//
//  Created by rakwireless on 16/8/25.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayBackFolderList : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIButton* btnFolderListBack;
    UITableView* ShowFolderListTableview;
}

@end
