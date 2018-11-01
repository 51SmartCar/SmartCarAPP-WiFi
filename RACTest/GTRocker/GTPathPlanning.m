//
//  GTPathPlanning.m
//  RACTest
//
//  Created by TianYuan on 2018/10/21.
//  Copyright © 2018年 SmartCar. All rights reserved.
//

#import "GTPathPlanning.h"

#define pi 3.14159265358979323846
#define degreesToRadian(x) (pi * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / pi)


@interface GTPathPlanning ()

@property (assign, nonatomic) BOOL pathPlanningFlag;
@property (nonatomic,assign) NSInteger currentDir;

@property (nonatomic,assign) NSInteger direction;
@property (nonatomic,assign) NSInteger directionLevel;

@property (nonatomic,assign) NSInteger angle;
@property (nonatomic,assign) NSInteger angleLevel;

@property (nonatomic,assign) CGPoint originPoint;
@property (nonatomic,assign) CGPoint oldPoint;

@property (nonatomic,strong)NSMutableArray *pointArr;

@property (assign, nonatomic) BOOL  instansDirFlag;

@property (strong ,nonatomic) NSThread *routeHistoryThread;
@property (strong, nonatomic) NSNumber *switchBtnStatus;


@end


@implementation GTPathPlanning

-(NSMutableArray *)pointArr{
    if (!_pointArr) {
        _pointArr = [[NSMutableArray alloc]init];
    }
    return _pointArr;
}



- (void)awakeFromNib
{
    [super awakeFromNib];
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    
    return self;
}


- (void)commonInit
{

    [self resetHandle];
    self.switchBtnStatus = @0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSwitchBtnStatus:) name:@"GTNotificationName" object:nil];

}

-(void)changeSwitchBtnStatus:(NSNotification *)noti{
    NSNumber * status = [noti.userInfo objectForKey:@"switchStatus"];
    
    self.switchBtnStatus = status;

}

CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};


-(CGFloat)angleForLineOneStartPoint:(CGPoint)lineOneStartPoint lineTwoStartPoint:(CGPoint)lineTwoStartPoint lineOneEndPoint:(CGPoint)lineOneEndPoint lineTwoEndPoint:(CGPoint)lineTwoEndPoint{
    
    
    CGFloat a = lineOneEndPoint.x - lineOneStartPoint.x;
    CGFloat b = lineOneEndPoint.y - lineOneStartPoint.y;
    CGFloat c = lineTwoEndPoint.x - lineTwoStartPoint.x;
    CGFloat d = lineTwoEndPoint.y - lineTwoStartPoint.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    
    return radiansToDegrees(rads);
}


#define Vsub(D,A,B) D.x=A.x-B.x; D.y=A.y-B.y
struct vertex
{
    float x;
    float y;
};
float Isleft(struct vertex p1, struct vertex p2, struct vertex p)
{
    struct vertex V1, V2;
    Vsub(V1,p1,p2);
    Vsub(V2, p, p1);
    float f = V1.x*V2.y - V2.x*V1.y;
    return f;
}

-(void)calculateWithTwoPoint:(CGPoint) newPoint andOldPoint:(CGPoint) oldPoints{
    
    struct vertex A={self.originPoint.x,self.originPoint.y};
    struct vertex B={self.self.oldPoint.x,self.self.oldPoint.y};
    struct vertex C={newPoint.x,newPoint.y};
    CGFloat isleft = Isleft( A, B, C);//右边是正的，左边是负的  若是后退，则转弯方向反的
    if (isleft>0) {
        self.angle = (self.direction == 2) ? PathPlanningAngleLeft:PathPlanningAngleRight;
    } else {
        self.angle = (self.direction == 2) ? PathPlanningAngleRight:PathPlanningAngleLeft;
        
    }
    
    CGFloat currentAngle =  [self angleForLineOneStartPoint:self.originPoint lineTwoStartPoint:self.oldPoint lineOneEndPoint:self.oldPoint lineTwoEndPoint:newPoint];
    
    if (currentAngle<=15) {
        self.angleLevel = PathPlanningLevelZero;
    }else if(currentAngle<=25) {
        self.angleLevel = PathPlanningLevelOne;
    }else if(currentAngle<=35) {
        self.angleLevel = PathPlanningLevelTwo;
    }else  {
        self.angleLevel = PathPlanningLevelThree;
    }
    
    if (!self.instansDirFlag) {
        
        self.instansDirFlag = true;
        // MARK: 前进 or 后退 只判断一次  油门默认1
        //y轴<原点Y  前进 2
        if (newPoint.y <= oldPoints.y) {
            self.direction = PathPlanningDirectionUp;//前
        }else{        //y轴>原点Y  后退 1
            self.direction = PathPlanningDirectionDown;
        }
        self.angleLevel = PathPlanningLevelZero;
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(pathPlanningDidChangedWithDirection:DirectionLevel:PathPlanningAngle:AngleLevel:)])
    {
        [self.delegate pathPlanningDidChangedWithDirection:self.direction DirectionLevel:self.directionLevel PathPlanningAngle:self.angle AngleLevel:self.angleLevel ];
    }
    
    //更新
    self.originPoint = CGPointMake(self.oldPoint.x, self.oldPoint.y);
    self.oldPoint = newPoint;
    
}


-(void)resetHandle{
    
    //转角&转角大小
    self.direction = PathPlanningDirectionCenter;
    self.directionLevel = PathPlanningLevelOne;//设置默认一档
    
    //前后&速度大小
    self.angle = PathPlanningAngleCenter;
    self.angleLevel = PathPlanningLevelZero;
    
    //原点
    self.oldPoint = CGPointMake(0, 0);
    self.originPoint = CGPointMake(0, 0);
    self.instansDirFlag = false;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];

    self.oldPoint = location;
    self.originPoint = CGPointMake(self.oldPoint.x, self.oldPoint.y+1);

    self.pathPlanningFlag = true;
    
    self.pointArr = nil;
    [self.pointArr addObject:NSStringFromCGPoint(CGPointMake(self.oldPoint.x, self.oldPoint.y+1))];
    [self.pointArr addObject:NSStringFromCGPoint(location)];

}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if ( self.pathPlanningFlag ) {
        
        CGFloat currentDistance = distanceBetweenPoints(location, self.oldPoint);
        
        if (currentDistance >= 40) {
            
            if ([self.switchBtnStatus  isEqual: @0]) {
                [self.pointArr addObject:NSStringFromCGPoint(location)];
                self.oldPoint = location;
            } else {
                [self calculateWithTwoPoint:location andOldPoint:self.oldPoint];

            }
            
        }
    }
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    self.pathPlanningFlag = false;
    self.instansDirFlag =false;

    self.pointArr = nil;
    
    if ([self.delegate respondsToSelector:@selector(pathPlanningDidChangedWithDirection:DirectionLevel:PathPlanningAngle:AngleLevel:)])
    {
        [self.delegate pathPlanningDidChangedWithDirection:PathPlanningDirectionCenter DirectionLevel:PathPlanningLevelZero PathPlanningAngle:PathPlanningAngleCenter AngleLevel:PathPlanningLevelZero];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    self.pathPlanningFlag = false;
    self.instansDirFlag = false;

    if ([self.delegate respondsToSelector:@selector(pathPlanningDidChangedWithDirection:DirectionLevel:PathPlanningAngle:AngleLevel:)])
    {
        [self.delegate pathPlanningDidChangedWithDirection:PathPlanningDirectionCenter DirectionLevel:PathPlanningLevelZero PathPlanningAngle:PathPlanningAngleCenter AngleLevel:PathPlanningLevelZero];
    }
    
    if ([self.switchBtnStatus  isEqual: @0]) {
        
        [self runRouteHistory];

    }

    
}

-(void)runRouteHistory{
    
    if (self.pointArr.count>=3) {
        
        if (!self.routeHistoryThread) {
            self.routeHistoryThread = [[NSThread alloc] initWithTarget:self selector:@selector(drawRouteHistory) object:nil];
        }
        
        [self.routeHistoryThread start];
        
    }else{
        self.pointArr = nil;

    }
    
}

-(void)drawRouteHistory{
    
    
    for (int i=0; i<=self.pointArr.count-2; i++) {
        
        //在此计数出方向，改变instansDirFlag的值一次，后续不需要进入此方法
        if (!self.instansDirFlag) {
            
            self.instansDirFlag = true;
            // MARK: 前进 or 后退 只判断一次  油门默认1
            //y轴<原点Y  前进 2
            if ((CGPointFromString(self.pointArr[2])).y <= (CGPointFromString(self.pointArr[1])).y) {
                self.direction = PathPlanningDirectionUp;//前
            }else{        //y轴>原点Y  后退 1
                self.direction = PathPlanningDirectionDown;
            }
            self.angleLevel = PathPlanningLevelZero;
            
        }
        
        
        CGPoint oldPoint = CGPointFromString(self.pointArr[i]);
        CGPoint currentPoint = CGPointFromString(self.pointArr[i+1]);
        [self calculateWithTwoPoint:currentPoint andOldPoint:oldPoint];
        NSLog(@"%d",i);
        [NSThread sleepForTimeInterval:0.2];
        
        if (i == self.pointArr.count-2) {
            [self.routeHistoryThread cancel];
            self.routeHistoryThread = nil;

            break;
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(pathPlanningDidChangedWithDirection:DirectionLevel:PathPlanningAngle:AngleLevel:)])
    {
        [self.delegate pathPlanningDidChangedWithDirection:PathPlanningDirectionCenter DirectionLevel:PathPlanningLevelZero PathPlanningAngle:PathPlanningAngleCenter AngleLevel:PathPlanningLevelZero];
    }
    
    self.pointArr = nil;

}


@end
