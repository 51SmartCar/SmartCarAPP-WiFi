//
//  AddDeviceStep01.m
//  AoSmart
//
//  Created by rakwireless on 16/2/26.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep01.h"
#import "CommanParameter.h"
#import "AddDeviceStep1.h"
#import "AddDeviceStep1AP.h"

@interface AddDeviceStep01 ()

@end

@implementation AddDeviceStep01

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceStep01Back=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep01Back.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep01Back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep01Back addTarget:nil action:@selector(_AddDeviceStep01BackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep01Back];
    
    _AddDeviceStep01Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, title_size*4, title_size)];
    _AddDeviceStep01Title.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceStep01Back.center.y);
    _AddDeviceStep01Title.text = NSLocalizedString(@"add_device_step01_title", nil);;
    _AddDeviceStep01Title.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep01Title.backgroundColor = [UIColor clearColor];
    _AddDeviceStep01Title.textColor = [UIColor grayColor];
    _AddDeviceStep01Title.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep01Title.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep01Title.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep01Title];
    
    _AddDeviceStep01Table = [[UITableView alloc] initWithFrame:CGRectMake(0, _AddDeviceStep01Back.frame.size.height+_AddDeviceStep01Back.frame.origin.y+diff_top, viewW, self.view.frame.size.height*0.4) style:UITableViewStylePlain];
    _AddDeviceStep01Table.backgroundColor=[UIColor whiteColor];
    _AddDeviceStep01Table.dataSource = self;
    _AddDeviceStep01Table.delegate = self;
    _AddDeviceStep01Table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:_AddDeviceStep01Table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Back
- (void)_AddDeviceStep01BackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 设置列表
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height*0.2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
        {
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.frame = CGRectMake(0, 0, self.view.frame.size.height*0.15, self.view.frame.size.height*0.15);
            imageView.center=CGPointMake(imageView.frame.size.width/2+10, self.view.frame.size.height*0.1);
            imageView.image=[UIImage imageNamed:@"main_device_local.png"];
            [cell addSubview:imageView];
            
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(10, 0, self.view.frame.size.width*0.5, add_title_size);
            label.textColor = [UIColor grayColor];
            label.font = [UIFont fontWithName:@"Arial" size:add_title_size];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
            label.text = NSLocalizedString(@"add_device_step01_easy_title", nil);
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(10, label.frame.size.height+label.frame.origin.y, self.view.frame.size.width*0.5, add_text_size*4);
            label2.textColor = [UIColor lightGrayColor];
            label2.lineBreakMode = UILineBreakModeWordWrap;
            label2.numberOfLines = 0;
            label2.font = [UIFont fontWithName:@"Arial" size:add_text_size];
            label2.text = NSLocalizedString(@"add_device_step01_easy_text", nil);;
            
            UIView *view=[[UIView alloc]init];
            view.frame=CGRectMake(0, 0, self.view.frame.size.width*0.5, label.frame.size.height+label2.frame.size.height);
            view.center=CGPointMake(imageView.frame.size.width+20+view.frame.size.width/2, self.view.frame.size.height*0.1);
            [cell addSubview:view];
            [view addSubview:label];
            [view addSubview:label2];
            
            UIImageView *imageView2=[[UIImageView alloc]init];
            imageView2.frame = CGRectMake(0, 0, self.view.frame.size.height*0.08, self.view.frame.size.height*0.08);
            imageView2.center=CGPointMake(self.view.frame.size.width- imageView2.frame.size.width/2-10, self.view.frame.size.height*0.1);
            imageView2.image=[UIImage imageNamed:@"arrow1.png"];
            [cell addSubview:imageView2];
        }
            break;
            
        case 1:
        {
            UIImageView *imageView=[[UIImageView alloc]init];
            imageView.frame = CGRectMake(0, 0, self.view.frame.size.height*0.15, self.view.frame.size.height*0.15);
            imageView.center=CGPointMake(imageView.frame.size.width/2+10, self.view.frame.size.height*0.1);
            imageView.image=[UIImage imageNamed:@"main_device_local.png"];
            [cell addSubview:imageView];
            
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(10, 0, self.view.frame.size.width*0.5, add_title_size);
            label.textColor = [UIColor grayColor];
            label.font = [UIFont fontWithName:@"Arial" size:add_title_size];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
            label.text = NSLocalizedString(@"add_device_step01_ap_title", nil);
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(10, label.frame.size.height+label.frame.origin.y, self.view.frame.size.width*0.5, add_text_size*4);
            label2.textColor = [UIColor lightGrayColor];
            label2.lineBreakMode = UILineBreakModeWordWrap;
            label2.numberOfLines = 0;
            label2.font = [UIFont fontWithName:@"Arial" size:add_text_size];
            label2.text = NSLocalizedString(@"add_device_step01_ap_text", nil);;
            
            UIView *view=[[UIView alloc]init];
            view.frame=CGRectMake(0, 0, self.view.frame.size.width*0.5, label.frame.size.height+label2.frame.size.height);
            view.center=CGPointMake(imageView.frame.size.width+20+view.frame.size.width/2, self.view.frame.size.height*0.1);
            [cell addSubview:view];
            [view addSubview:label];
            [view addSubview:label2];
            
            UIImageView *imageView2=[[UIImageView alloc]init];
            imageView2.frame = CGRectMake(0, 0, self.view.frame.size.height*0.08, self.view.frame.size.height*0.08);
            imageView2.center=CGPointMake(self.view.frame.size.width- imageView2.frame.size.width/2-10, self.view.frame.size.height*0.1);
            imageView2.image=[UIImage imageNamed:@"arrow1.png"];
            [cell addSubview:imageView2];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        AddDeviceStep1 *v = [[AddDeviceStep1 alloc] init];
        [self.navigationController pushViewController: v animated:true];
    }
    else if (indexPath.row==1) {
        AddDeviceStep1AP *v = [[AddDeviceStep1AP alloc] init];
        [self.navigationController pushViewController: v animated:true];
    }
}


//Set StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden//for iOS7.0
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
