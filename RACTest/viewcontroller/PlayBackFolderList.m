//
//  PlayBackFolderList.m
//  AoSmart
//
//  Created by rakwireless on 16/8/25.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "PlayBackFolderList.h"
#import "CommanParameter.h"
#import "HttpRequest.h"
#import "CommonFunc.h"
#import "PlayBackVideoList.h"

NSMutableArray *Folders;

@interface PlayBackFolderList ()
{
    NSString *deviceConnectingId;
    NSString *deviceConnectingIp;
    NSString *deviceConnectingpsk;
    int deviceConnectingPort;
}
@end

@implementation PlayBackFolderList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    Folders=[[NSMutableArray alloc]init];
    CGFloat W=self.view.frame.size.width;
    CGFloat H=self.view.frame.size.height;
    
    // Do any additional setup after loading the view.
    btnFolderListBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnFolderListBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [btnFolderListBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnFolderListBack addTarget:nil action:@selector(btnFolderListBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:btnFolderListBack];
    
    UILabel *line=[[UILabel alloc]init];
    line.frame=CGRectMake(0, btnFolderListBack.frame.origin.y+btnFolderListBack.frame.size.height+1+10, W, 1);
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    
    ShowFolderListTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, line.frame.origin.y +line.frame.size.height+1, W, H-line.frame.size.height-1) style:UITableViewStylePlain];
    ShowFolderListTableview.dataSource = self;
    ShowFolderListTableview.delegate = self;
    ShowFolderListTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:ShowFolderListTableview];
    
    deviceConnectingId=[self Get_Parameter:@"play_device_id"];
    deviceConnectingIp=[self Get_Parameter:@"play_device_ip"];
    NSString *key=[NSString stringWithFormat:@"Password=%@",deviceConnectingId];
    deviceConnectingpsk=[self Get_Parameter:key];
    if ([deviceConnectingIp compare:@"127.0.0.1"]==NSOrderedSame) {
        deviceConnectingPort=REMOTEPORTMAPPING;
    }
    else{
        deviceConnectingPort=80;
    }
    
    NSThread* httpThread = [[NSThread alloc] initWithTarget:self
                                                   selector:@selector(getFolderList)
                                                     object:nil];
    [httpThread start];
    
}

- (void)btnFolderListBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}

//Save Parameter
- (void)Save_Parameter:(NSString *)devices :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:devices forKey:key];
    [defaults synchronize];
}

//Get Parameter
- (NSString *)Get_Parameter:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    return value;
}

- (void)getFolderList{
    NSString *URL=[[NSString alloc]initWithFormat:@"http://%@:%d/param.cgi?action=list&group=videodir&fmt=link&pipe=0&type=0",deviceConnectingIp,deviceConnectingPort];
    HttpRequest* http_request = [HttpRequest HTTPRequestWithUrl:URL andData:nil andMethod:@"GET" andUserName:@"admin" andPassword:deviceConnectingpsk];
    if(http_request.StatusCode==200)
    {
        http_request.ResponseString=[http_request.ResponseString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"folderlist=%@",http_request.ResponseString);
        [self parseJsonString:http_request.ResponseString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShowFolderListTableview reloadData];
        });
    }
}

-(void)parseJsonString:(NSString *)str{
    [Folders removeAllObjects];
    NSString *srcStr=str;
    NSString *keyStr=@"\"folder\":\"";
    NSString *endStr=@"\"";
    while(true){
        NSRange range=[srcStr rangeOfString:keyStr];
        if (range.location != NSNotFound) {
            int i=(int)range.location;
            srcStr=[srcStr substringFromIndex:i+keyStr.length];
            NSRange range1=[srcStr rangeOfString:endStr];
            if (range1.location != NSNotFound) {
                int j=(int)range1.location;
                NSRange diffRange=NSMakeRange(0, j);
                NSString *_ssid=[srcStr substringWithRange:diffRange];
                [Folders addObject:_ssid];
            }
            else{
                break;
            }
        }else{
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return list_row_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Folders.count;
}
#pragma mark 设置分组标题内容高度
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIImageView *newImageView=[[UIImageView alloc]init];
    newImageView.frame=CGRectMake(diff_x, list_row_height*0.1, list_row_height*0.8*126/120, list_row_height*0.8);
    newImageView.image=[UIImage imageNamed:@"dl_downloaded_directory.png"];
    [cell.contentView addSubview: newImageView];
    
    UILabel *newLabel=[[UILabel alloc]init];
    newLabel.frame=CGRectMake(newImageView.frame.size.width+newImageView.frame.origin.x+diff_x, 0, self.view.frame.size.width, list_row_height);
    newLabel.font = [UIFont fontWithName:@"Arial" size:add_text_size];
    newLabel.text=Folders[indexPath.row];
    [cell.contentView addSubview: newLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"name=%@",Folders[indexPath.row]);
    [self Save_Parameter:Folders[indexPath.row] :@"folder"];
    PlayBackVideoList *v = [[PlayBackVideoList alloc] init];
    [self.navigationController pushViewController: v animated:true];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
