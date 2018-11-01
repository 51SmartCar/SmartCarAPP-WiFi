
#import "GTGyro.h"
#import <CoreMotion/CoreMotion.h>
@interface GTGyro ()

/**
 回调间隔
 */
@property (nonatomic) NSTimeInterval updateInterval;;
@property (nonatomic, strong) CMMotionManager *mManager;
//@property (nonnull, assign) NSInteger *cdirXData;
//@property (nonnull, assign) NSInteger *cdirX;
//@property (nonnull, assign) NSInteger *cdirYData;
//@property (nonnull, assign) NSInteger *cdirY;
@end


@implementation GTGyro




- (CMMotionManager *)mManager
{
    if (!_mManager) {
        _updateInterval = 0.2;
        _mManager = [[CMMotionManager alloc] init];
        
    }
    return _mManager;
}


- (void)startUpdateAccelerometerResult:(void (^)(int dir , int dirData, BOOL flag))result
{
    if ([self.mManager isAccelerometerAvailable] == YES) {
        //回调会一直调用,建议获取到就调用下面的停止方法，需要再重新开始，当然如果需求是实时不间断的话可以等离开页面之后再stop
        [self.mManager setAccelerometerUpdateInterval:self.updateInterval];
        [self.mManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             
             
             double x = round(accelerometerData.acceleration.x *10)/10;
             double y = round(accelerometerData.acceleration.y*10)/10;
             
//             double z = -round(accelerometerData.acceleration.z*10)/10;
//
//             NSLog(@"x:%.1f-- y:%.1f -- z:%.1f",x,y,z);
             
             
             
             
             
//         平    0    0
//         左    0    1
//         右    0    -1
//         前    1    0
//         后    -1    0
//         0,0.1,0.2,0.3, 0.4,0.5, 0.6 0.7, 0.8,0.9,1.0
             
             
             //前后
             int dirX = (x == 0 ? 0 :(x >0 ? 2: 1));
             
             int dirXData = 0;
             static int cdirX = 0;
             static int cdirXData = 0;
             
             float fabsX = fabs(x);
             if (fabsX <= 0.3) {
                 dirXData = 0;
             }else if (fabsX <= 0.5) {
                 dirXData = 1;
             }else if (fabsX <= 0.7) {
                 dirXData = 2;
             }else if (fabsX <= 1.0) {
                 dirXData = 3;
             }
             
             if(dirXData ==0 || dirX == 0){
                 dirX = 0;
                 dirXData = 0;
             }
             
             if (dirX != cdirX || dirXData != cdirXData) {
                  cdirX = dirX;
                  cdirXData = dirXData;
                 !result?:result(dirX, dirXData, 1);
             }

             
             
             //转弯
             int dirY = (y == 0 ? 0 :(y >0 ? 2: 1));
             
             int dirYData = 0;
             static int cdirY = 0;
             static int cdirYData = 0;
             
             float fabsY = fabs(y);
             if (fabsY <= 0.3) {
                 dirYData = 0;
             }else if (fabsY <= 0.5) {
                 dirYData = 1;
             }else if (fabsY <= 0.7) {
                 dirYData = 2;
             }else if (fabsY <= 1.0) {
                 dirYData = 3;
             }
             
             if (dirY != cdirY || dirYData != cdirYData) {
                 cdirY = dirY;
                 cdirYData = dirYData;
                 !result?:result(dirY, dirYData, 0);
             }
             
         }];
    }
    
    
    
    
}

- (void)stopUpdate
{
    if ([self.mManager isAccelerometerActive] == YES)
    {
        [self.mManager stopAccelerometerUpdates];
    }
}

- (void)dealloc
{
    _mManager = nil;
}
@end
