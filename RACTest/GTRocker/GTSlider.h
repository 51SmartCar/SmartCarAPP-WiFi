
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,GTSliderStyle)
{
    GTSliderStyle_Nomal = 1,    /*默认样式 例如|________|________|________|________|*/
    GTSliderStyle_Cross = 2,    /*默认样式 例如|--------|--------|--------|--------|*/
    GTSliderStyle_Point = 3,    /*默认样式 例如 ●--------●--------●--------●--------●*/
};

@interface GTSlider : UIControl


/**
 刻度样式 详情参考 枚举值 GTSliderStyle 默认 GTSliderStyle_Nomal
 */
@property (nonatomic) GTSliderStyle sliderStyle;

/**
 滑块填充颜色
 */
@property (nonatomic) UIColor *thumbTintColor;


/**
 滑块阴影颜色
 */
@property (nonatomic) UIColor *thumbShadowColor;


/**
 滑块阴影透明度
 */
@property (nonatomic) CGFloat thumbShadowOpacity;


/**
 滑块直径 默认20
 */
@property (nonatomic) CGFloat thumbDiameter;

/**
 刻度线 线条颜色
 */
@property (nonatomic) UIColor *scaleLineColor;


/**
 刻度线 线条宽度
 */
@property (nonatomic,assign) CGFloat scaleLineWidth;

/**
 刻度线 线条高度
 */
@property (nonatomic,assign) CGFloat scaleLineHeight;


/**
 刻度线 刻度数量
 */
@property (nonatomic,assign) NSInteger scaleLineNumber;


/**
 当前滑块所处 刻度的索引 默认0
 */
@property (nonatomic,assign,readonly) NSInteger currentIdx;


/**
 设置 滑块选中的刻度索引 无动画效果
 */
- (void)setSelectedIndex:(NSInteger)index;


/**
 设置 滑块选中的刻度索引
 animated 是否有动画效果
 */
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
@end
