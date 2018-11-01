

#import "GTSlider.h"


@interface ClCircleLayer: CALayer
@property (nonatomic,strong) CALayer *fillLayer;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *shadowFilColor;
@property (nonatomic) CGFloat shadowFillOpacity;

@end

@implementation ClCircleLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    _fillColor = [UIColor colorWithRed:0.358 green:1.000 blue:0.834 alpha:1.000];
    _shadowFilColor = [UIColor yellowColor];
    _shadowFillOpacity = 1.0f;
    
    self.shadowColor = self.shadowFilColor.CGColor;
    self.shadowOffset = CGSizeMake(0, 0);
    self.shadowOpacity = self.shadowFillOpacity;
    
    self.fillLayer = [CALayer new];
    self.fillLayer.backgroundColor = self.fillColor.CGColor;
    [self addSublayer:self.fillLayer];
    
}

- (void)layoutSublayers
{
    [super layoutSublayers];
    
    if (!CGSizeEqualToSize(self.bounds.size, self.fillLayer.frame.size)) {
        //更新圆角及阴影 尺寸
        CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.bounds)*0.5, CGRectGetHeight(self.bounds)*0.5);
        CGFloat cornerRadius = CGRectGetWidth(self.bounds) *0.5;
        CGMutablePathRef shadowPath = CGPathCreateMutable();
        CGPathAddArc(shadowPath, nil, centerPoint.x, centerPoint.y, cornerRadius, 0, (CGFloat)M_PI*2, YES);
        self.shadowPath = shadowPath;
        
        self.fillLayer.cornerRadius = cornerRadius;
        
    }
    self.fillLayer.frame = self.bounds;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    self.fillLayer.backgroundColor = self.fillColor.CGColor;
}
- (void)setShadowFilColor:(UIColor *)shadowFilColor
{
    _shadowFilColor = shadowFilColor;
    self.shadowColor = self.shadowFilColor.CGColor;
}

//范围0~1
- (void)setShadowFillOpacity:(CGFloat)shadowFillOpacity
{
    shadowFillOpacity = MAX(0, shadowFillOpacity);
    shadowFillOpacity = MIN(1, shadowFillOpacity);
    
    _shadowFillOpacity = shadowFillOpacity;
    self.shadowOpacity = self.shadowFillOpacity;
}

@end


@interface GTSlider ()
{
    BOOL touchOnCircleLayer;
    CGRect lastFrame;
}

@property (nonatomic,strong)ClCircleLayer *thumbLayer;

@property (nonatomic,assign,readwrite) NSInteger currentIdx;

@end

@implementation GTSlider

#pragma mark - alloc init

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)doInit
{
    touchOnCircleLayer = NO;
    _currentIdx = 0;
    _sliderStyle = GTSliderStyle_Cross;
    
    //滑块相关
    _thumbShadowOpacity = 0.6;
    _thumbShadowColor = [UIColor yellowColor];
    _thumbTintColor = [UIColor colorWithRed:0.358 green:1.000 blue:0.834 alpha:1.000];
    _thumbDiameter = 20;
    
    //刻度线相关
    _scaleLineWidth = 1.0f;
    _scaleLineColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.96 alpha:1.000];
    _scaleLineNumber = 4;
    _scaleLineHeight = 5;
    
    //滑块
    self.thumbLayer = [ClCircleLayer new];
    self.thumbLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.thumbLayer.fillColor = _thumbTintColor;
    self.thumbLayer.shadowFilColor = _thumbShadowColor;
    self.thumbLayer.shadowFillOpacity = _thumbShadowOpacity;
    [self.layer addSublayer:self.thumbLayer];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGRectEqualToRect(lastFrame, self.frame)) {
        lastFrame = self.frame;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGFloat W = CGRectGetWidth(self.bounds);
    CGFloat H = CGRectGetHeight(self.bounds);
    
    //设置滑块位置
//    CGFloat thumLayerFrameX = [self thumbLayerFrameXAtindex:self.currentIdx];
//    CGRect tmpRect = CGRectMake(thumLayerFrameX, (H-self.thumbDiameter)*0.5, self.thumbDiameter, self.thumbDiameter);
//    [self setThumbLayerFrame:tmpRect animated:YES];
//    
    CGFloat thumLayerFrameY = [self thumbLayerFrameYAtindex:self.currentIdx];
    CGRect tmpRects = CGRectMake( (W-self.thumbDiameter)*0.5,thumLayerFrameY, self.thumbDiameter, self.thumbDiameter);
    [self setThumbLayerFrame:tmpRects animated:YES];
    
    //绘制背景颜色
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);

    //绘制主刻度线
    CGPoint spindleScaleStartPoint = CGPointMake(W*0.5, self.thumbDiameter*0.5);
    CGPoint spindleScaleEndPoint = CGPointMake(W*0.5, H - self.thumbDiameter*0.5);
    
    //设置刻度线颜色
    [self.scaleLineColor setStroke];
    
    //绘主刻度轴(Y轴)
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, self.scaleLineWidth);
    CGContextMoveToPoint(context, spindleScaleStartPoint.x,spindleScaleStartPoint.y);
    CGContextAddLineToPoint(context, spindleScaleEndPoint.x,spindleScaleEndPoint.y);
    CGContextStrokePath(context);

    //绘制竖直刻度短线
    NSInteger lineNum = self.scaleLineNumber+1;
    CGFloat oneH = (H-self.thumbDiameter)/self.scaleLineNumber;
    CGFloat x = 0;
    CGFloat startY = self.thumbDiameter*0.5;
    
    for (NSInteger i = 0; i < lineNum; i ++) {
        CGPoint startP = CGPointMake(x-(W/0.5), startY+i*(oneH));
        CGPoint endP =   CGPointMake(x+(W/0.5), startY +i*(oneH));
        CGContextMoveToPoint(context, startP.x, startP.y);
        CGContextAddLineToPoint(context, endP.x, endP.y);
        CGContextStrokePath(context);
    }

}

#pragma mark -
- (CGFloat)thumbLayerFrameYAtindex:(NSInteger)idy
{
    CGFloat H = CGRectGetHeight(self.frame);
    CGFloat oneH = (H-self.thumbDiameter)/self.scaleLineNumber;
    CGFloat y = oneH * idy;
    return y;
}

- (void)setThumbLayerFrame:(CGRect)frame animated:(BOOL)animated
{
    if(animated) {
        self.thumbLayer.actions = nil;
        self.thumbLayer.frame = frame;
    }else {
        NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"position", [NSNull null], @"bounds", nil];
        self.thumbLayer.actions = newActions;
        self.thumbLayer.frame = frame;
    }
}



#pragma mark -
#pragma mark - Touch
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    CGPoint p = [touch locationInView:self];
    if (p.x>=0 && p.x <= CGRectGetWidth(self.frame)) {
        p.x = self.thumbLayer.position.x;
    }
    
//    if (CGRectContainsPoint(self.thumbLayer.frame, p)) {
        touchOnCircleLayer = YES;
        [self didSeleCtcircleLayer];
        return YES;
//    }
    touchOnCircleLayer = NO;
    return NO;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    if (touchOnCircleLayer) {
        CGPoint point = [touch locationInView:self];
        
        CGRect mRect = self.thumbLayer.frame;
        CGFloat y = point.y-self.thumbDiameter*0.5;
        mRect.origin.y = MAX(y, 0);
        mRect.origin.y = MIN(mRect.origin.y, CGRectGetHeight(self.frame)-self.thumbDiameter);
        [self setThumbLayerFrame:mRect animated:NO];
        
        
        CGFloat H = CGRectGetHeight(self.frame);
        CGFloat oneH = (H-self.thumbDiameter)/self.scaleLineNumber;

        CGFloat offY = point.y-self.thumbDiameter*0.5+oneH*0.5;
        offY = MAX(0, offY);
        offY = MIN(offY, CGRectGetHeight(self.frame));
        
        CGFloat idy = offY/oneH;
        int cIdy = (int)idy;
        cIdy = MIN(cIdy, (int)self.scaleLineNumber);
        cIdy = MAX(cIdy, 0);
        
        
        if (self.currentIdx != cIdy) {
            self.currentIdx = cIdy;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        return YES;
    }
    return NO;
}
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event
{
    [self desSelectCircleLayer];
}
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
{
    [self desSelectCircleLayer];
}

//取消选中
- (void)desSelectCircleLayer
{
    self.thumbLayer.transform = CATransform3DIdentity;
    CGRect tmpRect = self.thumbLayer.frame;
    tmpRect.origin.y = [self thumbLayerFrameYAtindex:self.currentIdx];
    
    self.thumbLayer.actions = nil;
    self.thumbLayer.frame = tmpRect;
}
//选中
- (void)didSeleCtcircleLayer
{
    self.thumbLayer.transform = CATransform3DScale(self.thumbLayer.transform, 1.2, 1.2, 1);
}


#pragma mark -
#pragma mark - Setter Method

- (void)setThumbTintColor:(UIColor *)thumbTintColor
{
    _thumbTintColor = thumbTintColor;
    self.thumbLayer.fillColor = thumbTintColor;
}

- (void)setThumbShadowOpacity:(CGFloat)thumbShadowOpacity
{
    _thumbShadowOpacity = thumbShadowOpacity;
    self.thumbLayer.shadowFillOpacity = thumbShadowOpacity;
}
- (void)setThumbShadowColor:(UIColor *)thumbShadowColor
{
    _thumbShadowColor = thumbShadowColor;
    self.thumbLayer.shadowFilColor = thumbShadowColor;
}


#pragma mark - Public Method
- (void)setSelectedIndex:(NSInteger)index
{
    index = MAX(0, index);
    index = MIN(index, self.scaleLineNumber);
    self.currentIdx = index;
    
    CGRect tmpRect = self.thumbLayer.frame;
    tmpRect.origin.y = [self thumbLayerFrameYAtindex:self.currentIdx];
    [self setThumbLayerFrame:tmpRect animated:NO];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    index = MAX(0, index);
    index = MIN(index, self.scaleLineNumber);
    self.currentIdx = index;
    CGRect tmpRect = self.thumbLayer.frame;
    tmpRect.origin.y = [self thumbLayerFrameYAtindex:self.currentIdx];
    [self setThumbLayerFrame:tmpRect animated:animated];

}

@end
