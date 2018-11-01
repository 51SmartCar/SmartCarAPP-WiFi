//
//  VideoMedia.m
//  AoSmart
//
//  Created by rakwireless on 16/1/25.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "VideoMedia.h"
#import "CommanParameter.h"
#import "ShowPhotoController.h"
#import "ShowVideoController.h"

@interface VideoMedia ()

@end

@implementation VideoMedia

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _videoMediaBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _videoMediaBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_videoMediaBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_videoMediaBack addTarget:nil action:@selector(_videoMediaBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_videoMediaBack];
    
    _videoMediaTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, title_size*4, title_size)];
    _videoMediaTitle.center=CGPointMake(self.view.frame.size.width/2,_videoMediaBack.center.y);
    _videoMediaTitle.text = NSLocalizedString(@"device_media_title", nil);;
    _videoMediaTitle.font = [UIFont systemFontOfSize: main_help_size];
    _videoMediaTitle.backgroundColor = [UIColor clearColor];
    _videoMediaTitle.textColor = [UIColor grayColor];
    _videoMediaTitle.textAlignment = UITextAlignmentCenter;
    _videoMediaTitle.lineBreakMode = UILineBreakModeWordWrap;
    _videoMediaTitle.numberOfLines = 0;
    [self.view addSubview:_videoMediaTitle];
    
    _videoMediaTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _videoMediaBack.frame.size.height+_videoMediaBack.frame.origin.y+diff_top, viewW, self.view.frame.size.height*0.4) style:UITableViewStylePlain];
    _videoMediaTable.backgroundColor=[UIColor whiteColor];
    _videoMediaTable.dataSource = self;
    _videoMediaTable.delegate = self;
    _videoMediaTable.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:_videoMediaTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_videoMediaBackClick{
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
            imageView.frame = CGRectMake(0, 0, self.view.frame.size.height*0.12, self.view.frame.size.height*0.12);
            imageView.center=CGPointMake(imageView.frame.size.width/2+10, self.view.frame.size.height*0.1);
            imageView.image=[UIImage imageNamed:@"photo_media_list.png"];
            [cell addSubview:imageView];
            
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(10, 0, self.view.frame.size.width*0.5, add_title_size);
            label.textColor = [UIColor grayColor];
            label.font = [UIFont fontWithName:@"Arial" size:add_title_size];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
            label.text = NSLocalizedString(@"device_photo_text", nil);
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(10, label.frame.size.height+label.frame.origin.y, self.view.frame.size.width*0.5, add_text_size*4);
            label2.textColor = [UIColor lightGrayColor];
            label2.lineBreakMode = UILineBreakModeWordWrap;
            label2.numberOfLines = 0;
            label2.font = [UIFont fontWithName:@"Arial" size:add_text_size];
            label2.text = NSLocalizedString(@"device_photo_note", nil);;
            
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
            imageView.frame = CGRectMake(0, 0, self.view.frame.size.height*0.12, self.view.frame.size.height*0.12);
            imageView.center=CGPointMake(imageView.frame.size.width/2+10, self.view.frame.size.height*0.1);
            imageView.image=[UIImage imageNamed:@"video_media_list.png"];
            [cell addSubview:imageView];
            
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(10, 0, self.view.frame.size.width*0.5, add_title_size);
            label.textColor = [UIColor grayColor];
            label.font = [UIFont fontWithName:@"Arial" size:add_title_size];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
            label.text = NSLocalizedString(@"device_video_text", nil);
            
            UILabel *label2 = [[UILabel alloc] init];
            label2.frame = CGRectMake(10, label.frame.size.height+label.frame.origin.y, self.view.frame.size.width*0.5, add_text_size*4);
            label2.textColor = [UIColor lightGrayColor];
            label2.lineBreakMode = UILineBreakModeWordWrap;
            label2.numberOfLines = 0;
            label2.font = [UIFont fontWithName:@"Arial" size:add_text_size];
            label2.text = NSLocalizedString(@"device_video_note", nil);;
            
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
        ShowPhotoController *v = [[ShowPhotoController alloc] init];
        [self.navigationController pushViewController: v animated:true];
    }
    else if (indexPath.row==1) {
        ShowVideoController *v = [[ShowVideoController alloc] init];
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
