//
//  ShowPhotoController.m
//  Feishen
//
//  Created by rakwireless on 15/11/6.
//  Copyright © 2015年 rak. All rights reserved.
//

#import "ShowPhotoController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MediaData.h"
#import "MediaGroup.h"
#import "CommanParameter.h"
#import "PlayPhotoViewController.h"
#import "AlbumObject.h"

// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]
// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]
// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

CGFloat H;
CGFloat W;
UITableViewCell *cell;
NSMutableArray *Medias;
NSMutableArray *selectedDic;

@interface ShowPhotoController ()
@property (nonatomic,strong) NSMutableArray *groupArrays;
@property (nonatomic,strong) NSMutableArray *Medias;
@end

@implementation ShowPhotoController
{
    AlbumObject *_albumObject;
    NSString *albumName;
}
@synthesize groupArrays;

- (void)viewDidLoad {
    [super viewDidLoad];
    albumName=@"RAK VIDEO";
    // 初始化
    self.groupArrays = [NSMutableArray array];
    Medias=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    H=self.view.frame.size.height;
    W=self.view.frame.size.width;
    selectedDic = [[NSMutableArray alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
//    bgShowPhoto=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"file_bg.png"]];
//    bgShowPhoto.frame = CGRectMake(0, 0, W, H);
//    bgShowPhoto.contentMode=UIViewContentModeScaleToFill;
//    [self.view addSubview:bgShowPhoto];
    
    btnShowPhotoBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnShowPhotoBack.frame=CGRectMake(diff_x, diff_top, add_title_size, add_title_size);
    [btnShowPhotoBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnShowPhotoBack addTarget:nil action:@selector(btnShowPhotoBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:btnShowPhotoBack];
    
    lableEditPhoto=[[UILabel alloc]init];
    lableEditPhoto.frame = CGRectMake(0, 0, title_size*4, title_size);
    lableEditPhoto.center=CGPointMake(W-lableEditPhoto.frame.size.width/2-diff_x, btnShowPhotoBack.center.y);
    lableEditPhoto.text=NSLocalizedString(@"edit_text", nil);
    lableEditPhoto.textAlignment=UITextAlignmentRight;
    lableEditPhoto.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lableEditPhotoClick)];
    [lableEditPhoto addGestureRecognizer:labelTapGestureRecognizer];
    lableEditPhoto.font=[UIFont fontWithName:@"Arial" size:add_title_size];
    lableEditPhoto.textColor=[UIColor grayColor];
    [self.view addSubview:lableEditPhoto];
    
    ShowPhotoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, btnShowPhotoBack.frame.origin.y +btnShowPhotoBack.frame.size.height+10, W, H-btnShowPhotoBack.frame.size.height-10) style:UITableViewStyleGrouped];
    ShowPhotoTableview.dataSource = self;
    ShowPhotoTableview.delegate = self;
    ShowPhotoTableview.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view  addSubview:ShowPhotoTableview];
        
    //[self Get_Image];
    _albumObject = [[AlbumObject alloc]init];
    [_albumObject delegate:self];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_albumObject readFileFromAlbum:albumName];
    });
}

- (void)readFileFromAlbum:(ALAssetsGroup *)group
{
    if (group) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop) {
            if ([result thumbnail] != nil) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                {
                    NSString *date= [self DateToString:[result valueForProperty:ALAssetPropertyDate]];
                    UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                    NSString *fileName = [[result defaultRepresentation] filename];
                    NSString *url = [[[result defaultRepresentation] url] absoluteString];
                    //int64_t fileSize = [[result defaultRepresentation] size];
                    //NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[result valueForProperty:ALAssetPropertyDate] timeIntervalSince1970]];
                    
                    is_grouped=false;
                    [Medias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        MediaGroup *get_group=Medias[idx];
                        //已分组则将数据添加到对应组
                        if ([date compare:[get_group getName]]==NSOrderedSame ) {
                            is_grouped=true;
                            MediaData *get_media=[MediaData initWithDate:date andName:fileName andUrl:url andTimesamp:@"" andImage:image];
                            [get_group.medias addObject:get_media];
                        }
                    }];
                    //未分组则添加一组，并将数据添加进去
                    if (is_grouped==false) {
                        MediaData *media=[MediaData initWithDate:date andName:fileName andUrl:url andTimesamp:@"" andImage:image];
                        MediaGroup *group=[MediaGroup initWithName:date andMedias:[NSMutableArray arrayWithObjects:media, nil]];
                        [Medias addObject:group];
                    }
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ShowPhotoTableview reloadData];
        });
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int count = (int)[selectedDic count];
    if (buttonIndex==0) {
        
    }
    else if(buttonIndex==1){
        NSMutableArray *videos=[self Get_Paths:@"video_flag"];
        NSMutableArray *mutaArray = [[NSMutableArray alloc] init];
        [mutaArray addObjectsFromArray:videos];
        for (int i = 0; i < count; i++) {
            [Medias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                //根据记录的删除的键值，删除组内元素
                MediaGroup *get_medias=Medias[idx];
                [get_medias.medias enumerateObjectsUsingBlock:^(id obj, NSUInteger idx2, BOOL *stop) {
                    MediaData *media=get_medias.medias[idx2];
                    if([([media getName]) compare:(selectedDic[i])]==NSOrderedSame ){
                        [[Medias[idx] getMedias] removeObject:media];
                        [_albumObject removeFileFromAlbum:[media getUrl]];
                        NSLog(@"Medias=%@",[media getUrl]);
                    }
                }];
                //当组内元素为0时，删除组
                if ([[Medias[idx] getMedias] count]==0) {
                    [Medias removeObject :Medias[idx]];
                }
            }];
        }
        
        [ShowPhotoTableview reloadData];
    }
    [selectedDic removeAllObjects];
    lableEditPhoto.text=@"Edit";
    lableEditPhoto.textColor=[UIColor whiteColor];
    [ShowPhotoTableview setEditing:NO animated:YES];
}

- (void)lableEditPhotoClick{
    if ([lableEditPhoto.text compare:NSLocalizedString(@"edit_text", nil)]==NSOrderedSame) {
        lableEditPhoto.text= [NSLocalizedString(@"delete_text", nil) stringByAppendingString:@"(0)"];
        lableEditPhoto.textColor=[UIColor redColor];
        [ShowPhotoTableview setEditing:YES animated:YES];
    }
    else{
        if ([lableEditPhoto.text compare:[NSLocalizedString(@"delete_text", nil) stringByAppendingString:@"(0)"]]==NSOrderedSame) {
            lableEditPhoto.text=NSLocalizedString(@"edit_text", nil);
            lableEditPhoto.textColor=[UIColor grayColor];
            [ShowPhotoTableview setEditing:NO animated:YES];
        }
        else{
            int count = (int)[selectedDic count];
            if (count > 0 ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"delete_photo_title_note", nil)
                                                          message:NSLocalizedString(@"delete_photo_admin_note", nil)
                                                          delegate:self cancelButtonTitle:NSLocalizedString(@"modify_device_delete_cancel", nil)
                                                          otherButtonTitles:NSLocalizedString(@"modify_device_delete_ok", nil), nil, nil];
                [alert show];
            }else {
                lableEditPhoto.text=NSLocalizedString(@"edit_text", nil);;
                lableEditPhoto.textColor=[UIColor grayColor];
                [ShowPhotoTableview setEditing:NO animated:YES];
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

BOOL is_grouped;
BOOL _isExist;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return list_row_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MediaGroup *group1=Medias[section];
    return group1.medias.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Medias.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    MediaGroup *group=Medias[section];
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
    label.frame = CGRectMake(30, 0, W, list_group_height);
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
    MediaGroup *group=Medias[indexPath.section];
    MediaData *contact=group.medias[indexPath.row];
    UIImage *image=(UIImage*)[contact getImage];
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(10, 0, W, self.view.frame.size.height*0.08);
    cell.imageView.image=image;
    cell.textLabel.text=[contact getName];
    cell.detailTextLabel.text=contact.Date;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([lableEditPhoto.text compare:NSLocalizedString(@"edit_text", nil)]==NSOrderedSame){
        MediaGroup *group=Medias[indexPath.section];
        MediaData *contact=group.medias[indexPath.row];
        PlayPhotoViewController *v = [[PlayPhotoViewController alloc] init];
        v.imageUrl=[contact getUrl];
        [self.navigationController pushViewController: v animated:true];
        
    }
    else{
        NSInteger sec = indexPath.section;
        NSInteger row = indexPath.row;
        NSMutableArray *media=[Medias[sec] getMedias];
        [selectedDic addObject:[media[row] getName]];
        lableEditPhoto.text=[NSLocalizedString(@"delete_text", nil) stringByAppendingString:[NSString stringWithFormat:@"(%d)",(int)[selectedDic count]]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([lableEditPhoto.text compare:NSLocalizedString(@"edit_text", nil)]==NSOrderedSame){
        
    }
    else{
        NSInteger sec = indexPath.section;
        NSInteger row = indexPath.row;
        NSMutableArray *media=[Medias[sec] getMedias];
        [selectedDic removeObject:[media[row] getName]];
        lableEditPhoto.text=[NSLocalizedString(@"delete_text", nil) stringByAppendingString:[NSString stringWithFormat:@"(%d)",(int)[selectedDic count]]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1.删除数据
        [Medias[indexPath.section] removeObjectAtIndex:indexPath.row];
        
        // 2.更新UITableView UI界面
        [Medias[indexPath.section] reloadData];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnShowPhotoBackClick{
    [self.navigationController popViewControllerAnimated:YES];
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
