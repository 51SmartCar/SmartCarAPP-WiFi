//
//  AddDeviceStep2AP.h
//  AoSmart
//
//  Created by rakwireless on 16/2/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceStep2AP : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_AddDeviceStep2APBack;
    UILabel  *_AddDeviceStep2APTitle;
    UILabel  *_AddDeviceStep2APText;
    UILabel  *_AddDeviceStep2APNote;
    UILabel  *_AddDeviceStep2APNetText;
    UILabel  *_AddDeviceStep2APPskText;
    UITextField *_AddDeviceStep2APNetField;
    UITextField *_AddDeviceStep2APPskField;
    UIButton *_AddDeviceStep2APGetWifi;
    UIButton *_AddDeviceStep2APShowPsk;
    UIButton *_AddDeviceStep2APNext;
    
    UIView *_wifiListBgView;
    UIView *_wifiListView;
    UILabel *_wifiListTitle;
    UITableView *_wifiListTable;
}

@end
