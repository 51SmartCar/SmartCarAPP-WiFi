//
//  VideoHelp.m
//  AoSmart
//
//  Created by rakwireless on 16/1/25.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "VideoHelp.h"
#import "CommanParameter.h"

@interface VideoHelp ()

@end

@implementation VideoHelp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    CGFloat viewW=self.view.frame.size.width;
    CGFloat viewH=self.view.frame.size.height;
    
    _videoHelpBack=[UIButton buttonWithType:UIButtonTypeCustom];
    _videoHelpBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [_videoHelpBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_videoHelpBack addTarget:nil action:@selector(_videoHelpBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:_videoHelpBack];
    
    _videoHelpTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, title_size*4, title_size)];
    _videoHelpTitle.center=CGPointMake(self.view.frame.size.width/2,_videoHelpBack.center.y);
    _videoHelpTitle.text = NSLocalizedString(@"help_title", nil);;
    _videoHelpTitle.font = [UIFont systemFontOfSize: main_help_size];
    _videoHelpTitle.backgroundColor = [UIColor clearColor];
    _videoHelpTitle.textColor = [UIColor grayColor];
    _videoHelpTitle.textAlignment = UITextAlignmentCenter;
    _videoHelpTitle.lineBreakMode = UILineBreakModeWordWrap;
    _videoHelpTitle.numberOfLines = 0;
    [self.view addSubview:_videoHelpTitle];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _videoHelpBack.frame.size.height+_videoHelpBack.frame.origin.y+diff_top,viewW, viewH-_videoHelpBack.frame.size.height-_videoHelpBack.frame.origin.y-diff_top)];
    scrollView.contentSize = CGSizeMake(viewW, viewH*2.5);//滚动条视图内容范围的大小
    scrollView.showsHorizontalScrollIndicator = FALSE;//水平滚动条是否显示
    scrollView.showsVerticalScrollIndicator = FALSE;//垂直滚动条是否显示
//    [self.view addSubview:scrollView];
//    
//    _videoHelp1 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, 0, viewW-2*diff_x, title_size)];
//    _videoHelp1.text = NSLocalizedString(@"help_text_0", nil);;
//    _videoHelp1.font = [UIFont systemFontOfSize: add_text_size];
//    _videoHelp1.backgroundColor = [UIColor clearColor];
//    _videoHelp1.textColor = [UIColor blackColor];
//    _videoHelp1.textAlignment = UITextAlignmentLeft;
//    _videoHelp1.lineBreakMode = UILineBreakModeWordWrap;
//    _videoHelp1.numberOfLines = 0;
//    [scrollView addSubview:_videoHelp1];
//    
//    _videoHelpAndroid=[UIButton buttonWithType:UIButtonTypeCustom];
//    _videoHelpAndroid.frame = CGRectMake(diff_x, _videoHelp1.frame.size.height+_videoHelp1.frame.origin.y, viewW-2*diff_x, title_size);
//    [_videoHelpAndroid setTitle: NSLocalizedString(@"help_url_android", nil) forState: UIControlStateNormal];
//    _videoHelpAndroid.titleLabel.font = [UIFont systemFontOfSize: add_text_size];
//    [_videoHelpAndroid setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
//    [_videoHelpAndroid setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
//    _videoHelpAndroid.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//    [_videoHelpAndroid addTarget:nil action:@selector(_videoHelpAndroidClick) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView  addSubview:_videoHelpAndroid];
//    
//    _videoHelp2 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _videoHelpAndroid.frame.size.height+_videoHelpAndroid.frame.origin.y, viewW-2*diff_x, title_size)];
//    _videoHelp2.text = NSLocalizedString(@"help_text_1", nil);;
//    _videoHelp2.font = [UIFont systemFontOfSize: add_text_size];
//    _videoHelp2.backgroundColor = [UIColor clearColor];
//    _videoHelp2.textColor = [UIColor blackColor];
//    _videoHelp2.textAlignment = UITextAlignmentLeft;
//    _videoHelp2.lineBreakMode = UILineBreakModeWordWrap;
//    _videoHelp2.numberOfLines = 0;
//    [scrollView addSubview:_videoHelp2];
//    
//    _videoHelpIOS=[UIButton buttonWithType:UIButtonTypeCustom];
//    _videoHelpIOS.frame = CGRectMake(diff_x, _videoHelp2.frame.size.height+_videoHelp2.frame.origin.y, viewW-2*diff_x, title_size);
//    [_videoHelpIOS setTitle: NSLocalizedString(@"help_url_ios", nil) forState: UIControlStateNormal];
//    _videoHelpIOS.titleLabel.font = [UIFont systemFontOfSize: add_text_size];
//    [_videoHelpIOS setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
//    [_videoHelpIOS setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
//    _videoHelpIOS.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//    [_videoHelpIOS addTarget:nil action:@selector(_videoHelpIOSClick) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView  addSubview:_videoHelpIOS];
    
    _videoHelp3 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _videoHelpIOS.frame.size.height+_videoHelpIOS.frame.origin.y, viewW-2*diff_x, title_size*8)];
    _videoHelp3.text = NSLocalizedString(@"help_text_2", nil);;
    _videoHelp3.font = [UIFont systemFontOfSize: add_text_size];
    _videoHelp3.backgroundColor = [UIColor clearColor];
    _videoHelp3.textColor = [UIColor blackColor];
    _videoHelp3.textAlignment = UITextAlignmentLeft;
    _videoHelp3.lineBreakMode = UILineBreakModeWordWrap;
    _videoHelp3.numberOfLines = 0;
    [scrollView addSubview:_videoHelp3];
    
    _videoHelp4 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _videoHelp3.frame.size.height+_videoHelp3.frame.origin.y, viewW-2*diff_x, title_size)];
    _videoHelp4.text = NSLocalizedString(@"help_text_3_title", nil);;
    _videoHelp4.font = [UIFont systemFontOfSize: add_title_size];
    _videoHelp4.backgroundColor = [UIColor clearColor];
    _videoHelp4.textColor = [UIColor blackColor];
    _videoHelp4.textAlignment = UITextAlignmentLeft;
    _videoHelp4.lineBreakMode = UILineBreakModeWordWrap;
    _videoHelp4.numberOfLines = 0;
    [scrollView addSubview:_videoHelp4];
    
    _videoHelp5 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _videoHelp4.frame.size.height+_videoHelp4.frame.origin.y, viewW-2*diff_x, title_size*8)];
    _videoHelp5.text = NSLocalizedString(@"help_text_3_text", nil);;
    _videoHelp5.font = [UIFont systemFontOfSize: add_text_size];
    _videoHelp5.backgroundColor = [UIColor clearColor];
    _videoHelp5.textColor = [UIColor blackColor];
    _videoHelp5.textAlignment = UITextAlignmentLeft;
    _videoHelp5.lineBreakMode = UILineBreakModeWordWrap;
    _videoHelp5.numberOfLines = 0;
    [scrollView addSubview:_videoHelp5];
    
    _videoHelp6 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _videoHelp5.frame.size.height+_videoHelp5.frame.origin.y, viewW-2*diff_x, title_size)];
    _videoHelp6.text = NSLocalizedString(@"help_text_4_title", nil);;
    _videoHelp6.font = [UIFont systemFontOfSize: add_title_size];
    _videoHelp6.backgroundColor = [UIColor clearColor];
    _videoHelp6.textColor = [UIColor blackColor];
    _videoHelp6.textAlignment = UITextAlignmentLeft;
    _videoHelp6.lineBreakMode = UILineBreakModeWordWrap;
    _videoHelp6.numberOfLines = 0;
    [scrollView addSubview:_videoHelp6];
    
    _videoHelp7 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _videoHelp6.frame.size.height+_videoHelp6.frame.origin.y, viewW-2*diff_x, title_size*11)];
    _videoHelp7.text = NSLocalizedString(@"help_text_4_text", nil);;
    _videoHelp7.font = [UIFont systemFontOfSize: add_text_size];
    _videoHelp7.backgroundColor = [UIColor clearColor];
    _videoHelp7.textColor = [UIColor blackColor];
    _videoHelp7.textAlignment = UITextAlignmentLeft;
    _videoHelp7.lineBreakMode = UILineBreakModeWordWrap;
    _videoHelp7.numberOfLines = 0;
    [scrollView addSubview:_videoHelp7];
    
    _videoHelp8 = [[UILabel alloc] initWithFrame:CGRectMake(diff_x, _videoHelp7.frame.size.height+_videoHelp7.frame.origin.y, viewW-2*diff_x, title_size*3)];
    _videoHelp8.text = NSLocalizedString(@"help_text_end", nil);;
    _videoHelp8.font = [UIFont systemFontOfSize: add_title_size];
    _videoHelp8.backgroundColor = [UIColor clearColor];
    _videoHelp8.textColor = [UIColor redColor];
    _videoHelp8.textAlignment = UITextAlignmentLeft;
    _videoHelp8.lineBreakMode = UILineBreakModeWordWrap;
    _videoHelp8.numberOfLines = 0;
    [scrollView addSubview:_videoHelp8];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_videoHelpBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_videoHelpAndroidClick{
//    NSString *iTunesLink;
//    iTunesLink = NSLocalizedString(@"help_url_android", nil);
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

- (void)_videoHelpIOSClick{
//    NSString *iTunesLink;
//    iTunesLink = NSLocalizedString(@"help_url_ios", nil);
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
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
