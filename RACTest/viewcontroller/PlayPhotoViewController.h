//
//  PlayPhotoViewController.h
//  AoSmart
//
//  Created by rakwireless on 16/1/30.
//  Copyright © 2016年 rak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayPhotoViewController : UIViewController
{
    UIImageView* playPhotoViewImage;
    UIButton* playPhotoViewBack;
}
@property (nonatomic) NSString *imageUrl;
@end
