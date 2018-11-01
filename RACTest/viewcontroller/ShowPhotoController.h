//
//  ShowPhotoController.h
//  Feishen
//
//  Created by rakwireless on 15/11/6.
//  Copyright © 2015年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPhotoController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView* bgShowPhoto;
    UIButton* btnShowPhotoBack;
    UITableView* ShowPhotoTableview;
    UILabel *lableEditPhoto;
}
@end
