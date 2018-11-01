//
//  AlbumObject.m
//  camSight
//
//  Created by rakwireless on 16/8/4.
//  Copyright © 2016年 rak. All rights reserved.
//

#import "AlbumObject.h"
#import "AlbumDelegateProxy.h"
#import "KeychainManager.h"
#import <Photos/Photos.h>

@interface AlbumObject ()

-(void)_addAssetURL:(NSURL *)assetURL
        toAlbum:(NSString *)albumName
        failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;


@property (atomic, retain)  AlbumDelegateProxy *delegateProxy;

@end

@implementation AlbumObject

- (id)init
{
    _delegateProxy = [[AlbumDelegateProxy alloc] init];
    self = [super init];
    return self;
}

- (void)delegate:(id<AlbumDelegate>)d
{
    _delegateProxy.delegate = d;
}

- (ALAssetsLibraryAccessFailureBlock) failureBlock
{
    ALAssetsLibraryAccessFailureBlock _failureBlock;
    _failureBlock = ^(NSError *error)
    {
        
        //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
            if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
                
                [alert show];
                
            }
        });
    };
    return _failureBlock;
}

BOOL haveHDRGroup = NO;
- (void)createAlbumInPhoneAlbum:(NSString*)albumName
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            haveHDRGroup = NO;
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name hasPrefix:albumName])
                {
                    haveHDRGroup = YES;
                    NSLog(@"===>%@",[gp valueForProperty:ALAssetsGroupPropertyURL]);
                }
            }
            if (!haveHDRGroup)
            {
                NSString *newAlbumName=albumName;
                KeychainManager *manager = [KeychainManager default];
                NSString *data = [manager load:@"albumNum"];
                if (data == nil) {
                    newAlbumName=albumName;
                    [manager save:@"albumNum" data:@"0"];
                }
                else{
                    int albumNum = [data intValue];
                    albumNum++;
                    [manager save:@"albumNum" data:[NSString stringWithFormat:@"%d",albumNum]];
                    newAlbumName=[NSString stringWithFormat:@"%@_%d",albumName,albumNum];
                }
                NSLog(@"newAlbumName = %@",newAlbumName);
                
                [assetsLibrary addAssetsGroupAlbumWithName:newAlbumName resultBlock:^(ALAssetsGroup *group)
                 {
                     if (group!=nil) {
                         haveHDRGroup=YES;
                         [groups addObject:group];
                     }
                     else{
                         
                     }
                 }
                 failureBlock:nil];
            }
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = [self failureBlock];
    
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:failureBlock];
    
}


- (void)saveImageToAlbum:(UIImage*)image  albumName:(NSString*)albumName
{
    NSString *newAlbumName=albumName;
    KeychainManager *manager = [KeychainManager default];
    NSString *data = [manager load:@"albumNum"];
    if ((data == nil)||([data compare:@"0"]==NSOrderedSame)) {
        newAlbumName=albumName;
    }
    else{
        int albumNum = [data intValue];
        newAlbumName=[NSString stringWithFormat:@"%@_%d",albumName,albumNum];
    }
    
    [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:newAlbumName completionBlock:^
     {
         //这里可以创建添加成功的方法
         if (_delegateProxy.delegate) {
             [_delegateProxy.delegate saveImageToAlbum:YES];
         }
         
     }
     failureBlock:^(NSError *error)
     {
         if (_delegateProxy.delegate) {
             [_delegateProxy.delegate saveImageToAlbum:NO];
         }
     }];
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                     imageData:(NSData *)imageData
               customAlbumName:(NSString *)customAlbumName
               completionBlock:(void (^)(void))completionBlock
                  failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] hasPrefix:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(assetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrary, assetURL);
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

- (void)saveVideoToAlbum:(NSString*)path  albumName:(NSString*)albumName
{
    NSString *newAlbumName=albumName;
    KeychainManager *manager = [KeychainManager default];
    NSString *data = [manager load:@"albumNum"];
    if ((data == nil)||([data compare:@"0"]==NSOrderedSame)) {
        newAlbumName=albumName;
    }
    else{
        int albumNum = [data intValue];
        newAlbumName=[NSString stringWithFormat:@"%@_%d",albumName,albumNum];
    }
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if ([[group valueForProperty:ALAssetsGroupPropertyName] hasPrefix:newAlbumName]) {
            [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:path]
                                        completionBlock:^(NSURL *assetURL, NSError *error) {
                                            if (error) {
                                                NSLog(@"Save video fail:%@",error);
                                            } else {
                                                NSLog(@"Save video succeed.");
                                                [self _addAssetURL:[NSURL fileURLWithPath:path] toAlbum:newAlbumName failureBlock:nil];
                                            }
                                        }];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)_addAssetURL:(NSURL *)assetURL toAlbum:(NSString *)albumName
    failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock {
        __block BOOL albumWasFound = NO;
        
        ALAssetsLibraryGroupsEnumerationResultsBlock enumerationBlock;
        enumerationBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            // compare the names of the albums
            if ([albumName compare:[group valueForProperty:ALAssetsGroupPropertyName]] == NSOrderedSame) {
                // target album is found
                albumWasFound = YES;
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                // get a hold of the photo's asset instance
                [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                          // add photo to the target album
                          [group addAsset:asset];
                      } failureBlock:nil];
                
                // album was found, bail out of the method
                return;
            }
            
            if (group == nil && albumWasFound == NO) {
                // photo albums are over, target album does not exist, thus create it
                
                // Since you use the assets library inside the block,
                //   ARC will complain on compile time that there’s a retain cycle.
                //   When you have this – you just make a weak copy of your object.
                //
                //   __weak ALAssetsLibrary * weakSelf = self;
                //
                // by @Marin.
                //
                // I don't use ARC right now, and it leads a warning.
                // by @Kjuly
//                ALAssetsLibrary * weakSelf = self;
//                
//                // create new assets album
//                [self addAssetsGroupAlbumWithName:albumName
//                                      resultBlock:^(ALAssetsGroup *group) {
//                                          // get the photo's instance
//                                          [weakSelf assetForURL:assetURL
//                                                    resultBlock:^(ALAsset *asset) {
//                                                        // add photo to the newly created album
//                                                        [group addAsset:asset];
//                                                    }
//                                                   failureBlock:failureBlock];
//                                      }
//                                     failureBlock:failureBlock];
                
                // should be the last iteration anyway, but just in case
                return;
            }
        };
    }

- (void)readFileFromAlbum:(NSString*)albumName
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            ALAssetsGroup *gp;
            for (gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name hasPrefix:albumName])
                {
                    break;
                } 
            }
            if (_delegateProxy.delegate) {
                [_delegateProxy.delegate readFileFromAlbum:gp];
            }
        }
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = [self failureBlock];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:failureBlock];
}


- (void)removeFileFromAlbum:(NSString*)fileUrl
{
    NSURL *assetURL = [NSURL URLWithString:fileUrl];
    
    if (assetURL == nil)
    {
        return;
    }
    
    Class PHPhotoLibrary_Class = NSClassFromString(@"PHPhotoLibrary");
    if (PHPhotoLibrary_Class) {//适用于IOS 8.0及以上
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[assetURL] options:nil];
        if (result.count > 0)
        {
            PHAsset *phAsset = result.firstObject;
            if ((phAsset != nil) && ([phAsset canPerformEditOperation:PHAssetEditOperationDelete]))
            {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^
                 {
                     [PHAssetChangeRequest deleteAssets:@[phAsset]];
                 }
                                                  completionHandler:^(BOOL success, NSError *error)
                 {
                     if ((!success) && (error != nil))
                     {
                         NSLog(@"Error deleting asset: %@", [error description]);
                     }
                 }];
            }
        }
    }else{//适用于IOS 8.0及以下
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc]init];
        [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result.isEditable) {
                    NSString *url = [[[result defaultRepresentation]url]description];
                    if([url isEqualToString:fileUrl])
                    {
                        [result setImageData:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                            
                        }];
                    }
                }
            }];
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)getPathForRecord:(NSString*)albumName{
    NSFileManager * fileManger=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSAllDomainsMask, YES);
    NSString * baseDirctory=[NSString stringWithFormat:@"%@/",[paths objectAtIndex:0]];
    NSString *filePath = [baseDirctory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",albumName]];
}

@end
