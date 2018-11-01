
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RockDirection)
{
    RockDirectionLeft = 0,
    RockDirectionUp,
    RockDirectionRight,
    RockDirectionDown,
    RockDirectionCenter,
};

@protocol GTRockerDelegate;

@interface GTRocker : UIView

@property (weak ,nonatomic) id <GTRockerDelegate> delegate;
@property (nonatomic, readonly) RockDirection direction;

@end

@protocol GTRockerDelegate <NSObject>

@optional
- (void)rockerDidChangeDirection:(GTRocker *)rocker locationX:(CGFloat)x locationY:(CGFloat)y locationDirec:(NSInteger)direc;

@end
