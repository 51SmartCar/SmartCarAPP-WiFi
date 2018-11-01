//
//  AddDeviceStep0.m
//  AoSmart
//
//  Created by rakwireless on 16/1/21.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AddDeviceStep0.h"
#import "CommanParameter.h"
#import "AddDeviceStep01.h"
#import "AddDeviceRemote.h"

@interface AddDeviceStep0 ()

@end

@implementation AddDeviceStep0

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _AddDeviceStep0Back=[UIButton buttonWithType:UIButtonTypeCustom];
    _AddDeviceStep0Back.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_AddDeviceStep0Back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_AddDeviceStep0Back addTarget:nil action:@selector(_AddDeviceStep0BackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_AddDeviceStep0Back];
    
    _AddDeviceStep0Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, title_size*4, title_size)];
    _AddDeviceStep0Title.center=CGPointMake(self.view.frame.size.width/2,_AddDeviceStep0Back.center.y);
    _AddDeviceStep0Title.text = NSLocalizedString(@"add_device_step0_title", nil);;
    _AddDeviceStep0Title.font = [UIFont systemFontOfSize: main_help_size];
    _AddDeviceStep0Title.backgroundColor = [UIColor clearColor];
    _AddDeviceStep0Title.textColor = [UIColor grayColor];
    _AddDeviceStep0Title.textAlignment = UITextAlignmentCenter;
    _AddDeviceStep0Title.lineBreakMode = UILineBreakModeWordWrap;
    _AddDeviceStep0Title.numberOfLines = 0;
    [self.view addSubview:_AddDeviceStep0Title];
    
    _AddDeviceStep0Table = [[UITableView alloc] initWithFrame:CGRectMake(0, _AddDeviceStep0Back.frame.size.height+_AddDeviceStep0Back.frame.origin.y+diff_top, viewW, self.view.frame.size.height*0.4) style:UITableViewStylePlain];
    _AddDeviceStep0Table.backgroundColor=[UIColor whiteColor];
    _AddDeviceStep0Table.dataSource = self;
    _AddDeviceStep0Table.delegate = self;
    _AddDeviceStep0Table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:_AddDeviceStep0Table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Back
- (void)_AddDeviceStep0BackClick{
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
            label.text = NSLocalizedString(@"add_device_step0_local_title", nil);
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(10, label.frame.size.height+label.frame.origin.y, self.view.frame.size.width*0.5, add_text_size*4);
            label2.textColor = [UIColor lightGrayColor];
            label2.lineBreakMode = UILineBreakModeWordWrap;
            label2.numberOfLines = 0;
            label2.font = [UIFont fontWithName:@"Arial" size:add_text_size];
            label2.text = NSLocalizedString(@"add_device_step0_local_text", nil);;
            
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
            imageView.image=[UIImage imageNamed:@"main_device_remote.png"];
            [cell addSubview:imageView];
            
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(10, 0, self.view.frame.size.width*0.5, add_title_size);
            label.textColor = [UIColor grayColor];
            label.font = [UIFont fontWithName:@"Arial" size:add_title_size];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
            label.text = NSLocalizedString(@"add_device_step0_remote_title", nil);
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(10, label.frame.size.height+label.frame.origin.y, self.view.frame.size.width*0.5, add_text_size*4);
            label2.textColor = [UIColor lightGrayColor];
            label2.lineBreakMode = UILineBreakModeWordWrap;
            label2.numberOfLines = 0;
            label2.font = [UIFont fontWithName:@"Arial" size:add_text_size];
            label2.text = NSLocalizedString(@"add_device_step0_remote_text", nil);;
            
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
        AddDeviceStep01 *v = [[AddDeviceStep01 alloc] init];
        [self.navigationController pushViewController: v animated:true];
    }
    else if (indexPath.row==1) {
        AddDeviceRemote *v = [[AddDeviceRemote alloc] init];
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
