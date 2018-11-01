//
//  AddDeviceStep3.h
//  AoSmart
//
//  Created by rakwireless on 16/1/23.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyConfig.h"

@interface AddDeviceStep3 : UIViewController<EasyConfigDelegate>
{
    UIButton *_AddDeviceStep3Back;
    UILabel *_AddDeviceStep3Text;
}
@property (retain, nonatomic) EasyConfig *_EasyConfig;
-(void)SendStop;
+(void)back;
@end
