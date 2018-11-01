//
//  GTPathPlanning.h
//  RACTest
//
//  Created by TianYuan on 2018/10/21.
//  Copyright © 2018年 SmartCar. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, PathPlanningDirection)
{
    PathPlanningDirectionCenter = 0,
    PathPlanningDirectionDown,
    PathPlanningDirectionUp
};

typedef NS_ENUM(NSInteger, PathPlanningAngle)
{
    PathPlanningAngleCenter = 0,
    PathPlanningAngleRight,
    PathPlanningAngleLeft
};

typedef NS_ENUM(NSInteger, PathPlanningLevel)
{
    PathPlanningLevelZero = 0,
    PathPlanningLevelOne,
    PathPlanningLevelTwo,
    PathPlanningLevelThree
    
};

@protocol GTPathPlanningDelegate;


@interface GTPathPlanning : UIView

@property (weak ,nonatomic) id <GTPathPlanningDelegate> delegate;


@end

@protocol GTPathPlanningDelegate <NSObject>

@optional
- (void)pathPlanningDidChangedWithDirection:(PathPlanningDirection )direction DirectionLevel:(PathPlanningLevel )directionLevel PathPlanningAngle:(PathPlanningAngle )angle AngleLevel:(PathPlanningLevel )angleLevel;

@end
