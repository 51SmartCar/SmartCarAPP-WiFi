
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GTGyro : NSObject
- (void)startUpdateAccelerometerResult:(void (^)(int dir , int dirData, BOOL flag))result;

- (void)stopUpdate;
@end
