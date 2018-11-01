
#import "GTRocker.h"

#define kRadius ([self bounds].size.width * 0.5f)
#define kTrackRadius kRadius * 1.0f    // 控制中心点偏移量

@interface GTRocker ()
{
    CGFloat _x;
    CGFloat _y;
}

@property (strong, nonatomic) UIImageView *handleImageView;
@property (assign, nonatomic) BOOL rockFlag;
@property (nonatomic,assign) NSInteger currentDir;


@end

@implementation GTRocker

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{    
    _direction = RockDirectionCenter;
    
    if (!_handleImageView) {
        UIImage *handleImage = [UIImage imageNamed:@"slider"];
        
        _handleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.5f-handleImage.size.width*0.5f,
                                                                         self.bounds.size.height*0.5f-handleImage.size.height*0.5f,
                                                                         50,
                                                                         50)];
        _handleImageView.image = handleImage;
        
        [self addSubview:_handleImageView];
    }
    
    _x = 0;
    _y = 0;
    
    [self resetHandle];
}


- (void)resetHandle
{
    _x = 0.0;
    _y = 0.0;
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(([self bounds].size.width - [_handleImageView bounds].size.width) * 0.5f,
                                          ([self bounds].size.height - [_handleImageView bounds].size.height) * 0.5f);
    [_handleImageView setFrame:handleImageFrame];
}

- (void)setHandlePositionWithLocation:(CGPoint)location
{
    _x = location.x - kRadius;
    _y = -(location.y - kRadius);
    
    float r = sqrt(_x * _x + _y * _y);
    if (r >= kTrackRadius) {
        _x = kTrackRadius * (_x / r);
        _y = kTrackRadius * (_y / r);
        
        location.x = _x + kRadius;
        location.y = -_y + kRadius;
        
    }
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(location.x - ([_handleImageView bounds].size.width * 0.5f),
                                          location.y - ([_handleImageView bounds].size.width * 0.5f));
    [_handleImageView setFrame:handleImageFrame];
    
    [self rockerValueChanged];
    
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
//    if (location.x>=0 && location.x <= CGRectGetWidth(self.frame)) {
//        location.x = self.frame.origin.x;
//    }
//    if (CGRectContainsPoint(self.frame, location)) {
//        [self setHandlePositionWithLocation:location];
//        _rockFlag = true;
//    }
    
    [self setHandlePositionWithLocation:location];
    _rockFlag = true;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if ( _rockFlag ) {//||CGRectContainsPoint(self.handleImageView.frame, location)
        [self setHandlePositionWithLocation:location];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    
    [self rockerValueChanged];
    if ([self.delegate respondsToSelector:@selector(rockerDidChangeDirection:locationX:locationY: locationDirec:)])
    {
        [self.delegate rockerDidChangeDirection:self locationX: 0 locationY: 0 locationDirec: 0];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    
    [self rockerValueChanged];
    _rockFlag = false;
    if ([self.delegate respondsToSelector:@selector(rockerDidChangeDirection:locationX:locationY: locationDirec:)])
    {
        [self.delegate rockerDidChangeDirection:self locationX: 0 locationY: 0 locationDirec: 0];
    }

}

- (void)rockerValueChanged
{
    NSInteger rockerDirection = -1;
    
    float arc = atan2f(_y,_x);
    
    if ((arc > (3.0f/4.0f)*M_PI &&  arc < M_PI) || (arc < -(3.0f/4.0f)*M_PI &&  arc > -M_PI)) {
        rockerDirection = RockDirectionLeft;
    }else if (arc > (1.0f/4.0f)*M_PI &&  arc < (3.0f/4.0f)*M_PI) {
        rockerDirection = RockDirectionUp;
    }else if ((arc > 0 &&  arc < (1.0f/4.0f)*M_PI) || (arc < 0 &&  arc > -(1.0f/4.0f)*M_PI)) {
        rockerDirection = RockDirectionRight;
    }else if (arc > -(3.0f/4.0f)*M_PI &&  arc < -(1.0f/4.0f)*M_PI) {
        rockerDirection = RockDirectionDown;
    }else if (0 == _x && 0 == _y)
    {
        rockerDirection = RockDirectionCenter;
    }
    
    float r = sqrt(_x * _x + _y * _y);
    
    BOOL direc = (_x<0&&_y>0) || (_x>0&&_y>0) ;

    if (-1 != rockerDirection && r>50 && direc) {//内径50CM
        
        
        NSInteger cidy = _x/20;//每隔20取点
        
        if (self.currentDir != cidy) {
            self.currentDir = cidy;
            
            if ([self.delegate respondsToSelector:@selector(rockerDidChangeDirection:locationX:locationY: locationDirec:)])
            {
                [self.delegate rockerDidChangeDirection:self locationX: _x locationY: _y locationDirec: cidy];
            }
        }
        
    }
}

@end
