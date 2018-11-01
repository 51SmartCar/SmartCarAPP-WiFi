//
//  PlayPhotoViewController.m
//  AoSmart
//
//  Created by rakwireless on 16/1/30.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "PlayPhotoViewController.h"
#import "CommanParameter.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PlayPhotoViewController ()
{
    CGFloat image_width;
    CGFloat image_height;
}
@end

@implementation PlayPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    // Do any additional setup after loading the view.
    playPhotoViewImage.userInteractionEnabled=YES;
    playPhotoViewImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"file_bg.png"]];
    playPhotoViewImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //playPhotoViewImage.contentMode=UIViewContentModeScaleToFill;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [playPhotoViewImage addGestureRecognizer:singleTap];
    [self.view addSubview:playPhotoViewImage];
    
    playPhotoViewBack=[UIButton buttonWithType:UIButtonTypeCustom];
    playPhotoViewBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [playPhotoViewBack setImage:[UIImage imageNamed:@"video_back.png"] forState:UIControlStateNormal];
    [playPhotoViewBack addTarget:nil action:@selector(playPhotoViewBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:playPhotoViewBack];
    
    [self getImage:self.imageUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playPhotoViewBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getImage:(NSString *)urlStr
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    NSURL *url=[NSURL URLWithString:urlStr];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        if ([image.description containsString:@"720"]==YES) {
            image_width=1280;
            image_height=720;
        }
        else{
            image_width=640;
            image_height=480;
        }
        playPhotoViewImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*image_height/image_width);
        playPhotoViewImage.center=self.view.center;
        playPhotoViewImage.image=image;
        
    }failureBlock:^(NSError *error) {
        NSLog(@"error=%@",error);
    }];
}

- (void)onClickImage{
    [self.navigationController popViewControllerAnimated:YES];
}

//Set StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        NSLog(@"Portrait");
    }
    else
    {
        NSLog(@"Portrait2");
    }
    playPhotoViewImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*image_height/image_width);
    playPhotoViewImage.center=self.view.center;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
    
}


@end
