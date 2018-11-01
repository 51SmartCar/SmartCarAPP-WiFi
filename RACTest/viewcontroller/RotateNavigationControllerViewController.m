//
//  RotateNavigationControllerViewController.m
//  CloudCompanion
//
//  Created by liweixiang on 15-1-22.
//  Copyright (c) 2015年 rak. All rights reserved.
//

#import "RotateNavigationControllerViewController.h"

@interface RotateNavigationControllerViewController ()

@end

@implementation RotateNavigationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setHidden:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    //NSLog(@"RotateNavigationControllerViewController supportedInterfaceOrientations = %i", self.topViewController.supportedInterfaceOrientations);
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //NSLog(@"RotateNavigationControllerViewController preferredInterfaceOrientationForPresentation = %i", [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation]);
    return [self.topViewController preferredInterfaceOrientationForPresentation];
    
}
@end
