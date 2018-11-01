//
//  ShowVideoController.m
//  Feishen
//
//  Created by rakwireless on 15/11/6.
//  Copyright © 2015年 rak. All rights reserved.
//

#import "ShowVideoController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MediaData.h"
#import "MediaGroup.h"
#import "PlayVideoViewController.h"
#import "CommanParameter.h"

// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]
// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]
// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

CGFloat VH;
CGFloat VW;
UITableViewCell *Vcell;
NSMutableArray *VMedias;
NSMutableArray *VselectedDic;

@interface ShowVideoController ()
@property (nonatomic,strong) NSMutableArray        *groupArrays;
@end

@implementation ShowVideoController
@synthesize groupArrays;

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.groupArrays = [NSMutableArray array];
    VMedias=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    VH=self.view.frame.size.height;
    VW=self.view.frame.size.width;
    VselectedDic = [[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
//    bgShowVideo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"file_bg.png"]];
//    bgShowVideo.frame = CGRectMake(0, 0, VW, VH);
//    bgShowVideo.contentMode=UIViewContentModeScaleToFill;
//    [self.view addSubview:bgShowVideo];
    
    btnShowVideoBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnShowVideoBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [btnShowVideoBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnShowVideoBack addTarget:nil action:@selector(btnShowVideoBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:btnShowVideoBack];
    
    lableEditVideo=[[UILabel alloc]init];
    lableEditVideo.frame = CGRectMake(0, 0, title_size*4, title_size);
    lableEditVideo.center=CGPointMake(VW-lableEditVideo.frame.size.width/2-diff_x, btnShowVideoBack.center.y);
    lableEditVideo.text=NSLocalizedString(@"edit_text", nil);
    lableEditVideo.textAlignment=UITextAlignmentRight;
    lableEditVideo.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableEditVideoClick)];
    [lableEditVideo addGestureRecognizer:labelTapGestureRecognizer];
    lableEditVideo.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    lableEditVideo.textColor=[UIColor grayColor];
    [self.view addSubview:lableEditVideo];

    ShowVideoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, btnShowVideoBack.frame.origin.y +btnShowVideoBack.frame.size.height+10, VW, VH-btnShowVideoBack.frame.size.height-10) style:UITableViewStyleGrouped];
    ShowVideoTableview.dataSource = self;
    ShowVideoTableview.delegate = self;
    ShowVideoTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:ShowVideoTableview];
    
    [self Get_Video];
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int count = (int)[VselectedDic count];
    if (buttonIndex==0) {
        
    }
    else if(buttonIndex==1){
        NSMutableArray *videos=[self Get_Paths:@"video_flag"];
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        [mutaArray addObjectsFromArray:videos];
        for (int i = 0; i < count; i++) {
            [VMedias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                //根据记录的删除的键值，删除组内元素
                MediaGroup *get_medias=VMedias[idx];
                [get_medias.medias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx2, BOOL *stop) {
                    MediaData *media=get_medias.medias[idx2];
                    if([([media getName]) compare:(VselectedDic[i])]==NSOrderedSame ){
                        NSString *timeSp=[media getTimesamp];
                        
                        for(int i=0;i<[videos count];i++)
                        {
                            if (([timeSp compare:videos[i]]==NSOrderedSame )) {
                                [mutaArray removeObject:timeSp];
                                break;
                            }
                        }
                        [[VMedias[idx] getMedias] removeObject:media];
                    }
                }];
                //当组内元素为0时，删除组
                if ([[VMedias[idx] getMedias] count]==0) {
                    [VMedias removeObject :VMedias[idx]];
                }
            }];
        }
        [self Save_Paths:mutaArray :@"video_flag"];
        [ShowVideoTableview reloadData];
    }
    [VselectedDic removeAllObjects];
    lableEditVideo.text=NSLocalizedString(@"edit_text", nil);
    lableEditVideo.textColor=[UIColor grayColor];
    [ShowVideoTableview setEditing:NO animated:YES];
}


- (void)lableEditVideoClick{
    if ([lableEditVideo.text compare:NSLocalizedString(@"edit_text", nil)]==NSOrderedSame) {
        lableEditVideo.text=[NSLocalizedString(@"delete_text", nil) stringByAppendingString:@"(0)"];
        lableEditVideo.textColor=[UIColor redColor];
        [ShowVideoTableview setEditing:YES animated:YES];
    }
    else{
        if ([lableEditVideo.text compare:[NSLocalizedString(@"delete_text", nil) stringByAppendingString:@"(0)"]]==NSOrderedSame) {
            lableEditVideo.text=NSLocalizedString(@"edit_text", nil);
            lableEditVideo.textColor=[UIColor grayColor];
            [ShowVideoTableview setEditing:NO animated:YES];
        }
        else{
            int count = (int)[VselectedDic count];
            if (count > 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete_video_title_note", nil)
                                                                message:NSLocalizedString(@"delete_video_admin_note", nil)
                                                               delegate:self cancelButtonTitle:NSLocalizedString(@"modify_device_delete_cancel", nil)
                                                      otherButtonTitles:NSLocalizedString(@"modify_device_delete_ok", nil), nil, nil];
                [alert show];
            }else {
                lableEditVideo.text=NSLocalizedString(@"edit_text", nil);
                lableEditVideo.textColor=[UIColor grayColor];
                [ShowVideoTableview setEditing:NO animated:YES];
            }
        }
    }
}

- (NSString *)DateToString:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    NSLog(@"%@", strDate);
    //[dateFormatter release];
    return strDate;
}

- (NSMutableArray *)Get_Paths:(NSString *)key
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *value=[defaults objectForKey:key];
    return value;
}

- (void)Save_Paths:(NSMutableArray *)Timesamp :(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:Timesamp forKey:key];
    [defaults synchronize];
}

BOOL Vis_grouped;
BOOL _VisExist;
- (void)Get_Video
{
    __weak ShowVideoController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [weakSelf.groupArrays addObject:group];
            } else {
                [weakSelf.groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if ([result thumbnail] != nil) {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                               
                            }
                            // 视频
                            else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                                NSString *date= [self DateToString:[result valueForProperty:ALAssetPropertyDate]];
                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                //UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                NSString *fileName = [[result defaultRepresentation] filename];
                                NSString *url = [[[result defaultRepresentation] url] absoluteString];
                                int64_t fileSize = [[result defaultRepresentation] size];
                                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[result valueForProperty:ALAssetPropertyDate] timeIntervalSince1970]];
                                
                                NSLog(@"date = %@",date);
                                NSLog(@"fileName = %@",fileName);
                                NSLog(@"url = %@",url);
                                NSLog(@"fileSize = %lld",fileSize);
                                NSMutableArray *videos=[self Get_Paths:@"video_flag"];
                                _VisExist=false;
                                for(int i=0;i<[videos count];i++)
                                {
                                    if ([timeSp compare:videos[i]]==NSOrderedSame) {
                                        _VisExist=true;
                                        break;
                                    }
                                }
                                
                                if (_VisExist){
                                    Vis_grouped=false;
                                    [VMedias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                        MediaGroup *get_group=VMedias[idx];
                                        //已分组则将数据添加到对应组
                                        if ([date compare:[get_group getName]]==NSOrderedSame ) {
                                            Vis_grouped=true;
                                            MediaData *get_media=[MediaData initWithDate:date andName:fileName andUrl:url andTimesamp:timeSp andImage:image];
                                            [get_group.medias addObject:get_media];
                                        }
                                        }];
                                    //未分组则添加一组，并将数据添加进去
                                    if (Vis_grouped==false) {
                                        MediaData *media=[MediaData initWithDate:date andName:fileName andUrl:url andTimesamp:timeSp andImage:image];
                                        MediaGroup *group=[MediaGroup initWithName:date andMedias:[NSMutableArray arrayWithObjects:media, nil]];
                                        [VMedias addObject:group];
                                    }
                                }
                            }
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [ShowVideoTableview reloadData];
                            });
                        }
                    }];
                }];
                
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil,nil];
                [alertView show];
            });
        };
        
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return list_row_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MediaGroup *group1=VMedias[section];
    return group1.medias.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return VMedias.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MediaGroup *group=VMedias[section];
    return group.name;
}
#pragma mark 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return list_group_height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(30, 0, VW, list_group_height);
    label.center=CGPointMake(30+label.frame.size.width*0.5, list_group_height*0.6);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont fontWithName:@"Arial" size:add_title_size];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, list_group_height)];
    //[sectionView setBackgroundColor:[UIColor blackColor]];
    [sectionView addSubview:label];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MediaGroup *group=VMedias[indexPath.section];
    MediaData *contact=group.medias[indexPath.row];
    UIImage *image=(UIImage*)[contact getImage];
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(10, 0, VW, self.view.frame.size.height*0.08);
    cell.imageView.image=image;
    cell.textLabel.text=[contact getName];
    cell.detailTextLabel.text=contact.Date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([lableEditVideo.text compare:NSLocalizedString(@"edit_text", nil)]==NSOrderedSame){
        MediaGroup *group=VMedias[indexPath.section];
        MediaData *contact=group.medias[indexPath.row];
        PlayVideoViewController *v = [[PlayVideoViewController alloc] init];
        v.Videourl=[contact getUrl];
        [self.navigationController pushViewController: v animated:true];
        
    }
    else{
        NSInteger sec = indexPath.section;
        NSInteger row = indexPath.row;
        NSMutableArray *media=[VMedias[sec] getMedias];
        [VselectedDic addObject:[media[row] getName]];
        lableEditVideo.text=[NSLocalizedString(@"delete_text", nil) stringByAppendingString:[NSString stringWithFormat:@"(%d)",(int)[VselectedDic count]]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([lableEditVideo.text compare:NSLocalizedString(@"edit_text", nil)]==NSOrderedSame){
        
    }
    else{
        NSInteger sec = indexPath.section;
        NSInteger row = indexPath.row;
        NSMutableArray *media=[VMedias[sec] getMedias];
        [VselectedDic removeObject:[media[row] getName]];
        lableEditVideo.text=[NSLocalizedString(@"delete_text", nil) stringByAppendingString:[NSString stringWithFormat:@"(%d)",(int)[VselectedDic count]]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1.删除数据
        [VMedias[indexPath.section] removeObjectAtIndex:indexPath.row];
        
        // 2.更新UITableView UI界面
        [VMedias[indexPath.section] reloadData];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)btnShowVideoBackClick{
    [self.navigationController popViewControllerAnimated:YES];
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
