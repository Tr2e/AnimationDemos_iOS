//
//  SPWaveButton.m
//  DynamicBadge
//
//  Created by Tree on 2017/6/4.
//  Copyright © 2017年 Tr2e. All rights reserved.
//

#import "SPWaveButton.h"


@protocol SPCircleViewDelegate <NSObject>

- (void)endRotateAnimation;

@end

@interface SPCircleView : UIView

@property (nonatomic, assign) BOOL isComplete;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat animateRadius;
@property (nonatomic, assign) NSInteger progress;

@property (nonatomic, weak) id<SPCircleViewDelegate> delegate;

@end

@implementation SPCircleView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setProgress:(NSInteger)progress{
    
    _progress = progress;
    [self setNeedsDisplay];
    
}

- (void)setIsComplete:(BOOL)isComplete{
    
    _isComplete = isComplete;
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect{

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint center =  CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    if (self.isComplete)
    {
        _startAngle = - M_PI_2;
        _endAngle = 2 * M_PI * _progress/30.0f - M_PI_2;
//        NSLog(@"---> %ld <---",(long)_progress);
//        NSLog(@"---> %ld <---",(long)_endAngle);
        
        if (_progress == 30) {
            if ([self.delegate respondsToSelector:@selector(endRotateAnimation)]) {
                [self.delegate endRotateAnimation];
            }
//            [self makeCompleteAnimateWithContext:context]; // 注意调用时机
        }
        else if (_progress == 15)
        {
            [self makeAnimateTickForComplete];// 注意调用时机
        }
        
    }
    else
    {
        if (_progress <= 30)
        {
            _startAngle = - M_PI_2;
            _endAngle = _progress / 30.0f * M_PI - M_PI_2;
        }
        else if (_progress > 30 && _progress <= 60)
        {
            _startAngle = 2*M_PI * (_progress - 30)/ 30.0f - M_PI_2;
            _endAngle = _progress / 60.0f * 2 * M_PI - M_PI_2;
        }
    }
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.animateRadius-1.5 startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    [[UIColor colorWithRed:30/255.0 green:144/255.0 blue:1 alpha:1] setStroke];
    CGContextSetLineWidth(context, 3);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextAddPath(context, path.CGPath);
    CGContextStrokePath(context);
    
}

// 直接绘制
- (void)makeCompleteAnimateWithContext:(CGContextRef)context{

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 15, 30);
    CGPathAddLineToPoint(path, NULL, 27.5, 42.5);
    CGPathAddLineToPoint(path, NULL, 45, 20);
    
    [[UIColor colorWithRed:30/255.0 green:144/255.0 blue:1 alpha:1] setStroke];
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 2);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    CGContextStrokePath(context);
    
}

// 通过shapeLayer，添加对号
- (void)makeAnimateTickForComplete{

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 15, 30);
    CGPathAddLineToPoint(path, NULL, 27.5, 42.5);
    CGPathAddLineToPoint(path, NULL, 45, 20);
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.strokeColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:1 alpha:1].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = @"round";
    layer.lineJoin = @"bevel";
    layer.lineWidth = 2;
    layer.path = path;
    
    CABasicAnimation *stroke = [[CABasicAnimation alloc] init];
    stroke.keyPath = @"strokeEnd";
    stroke.duration = 0.35f;
    stroke.fillMode = kCAFillModeForwards;
    stroke.fromValue = @0;
    stroke.byValue = @1;
    
    [layer addAnimation:stroke forKey:nil];
    
    [self.layer addSublayer:layer];
    
}



@end

@interface SPWaveButton()<SPCircleViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSInteger countTag;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, assign) CGFloat animateRadius;

@property (nonatomic, strong) SPCircleView *circleView;

@property (nonatomic, assign) SPWaveBtnAnimateType currentType;

@end

@implementation SPWaveButton

// show complete
- (void)completeAnimation{

    self.countTag = 0;
    self.circleView.isComplete = YES;
    
}

// change btn to circle and auto rotate
- (void)makeRotateCircleWithRadius:(CGFloat)radius{
    
    self.countTag = 0;
    
    SPCircleView *circle = [[SPCircleView alloc] initWithFrame:self.bounds];
    circle.animateRadius = radius;
    circle.delegate = self;
    [self addSubview:circle];
    self.circleView = circle;
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLinkAction)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.link = link;
    
}

- (void)endRotateAnimation{

    self.link.paused = YES;
    [self.link invalidate];
    self.link = nil;
    
}

- (void)handleDisplayLinkAction{
 
    self.countTag += 1;
    if (self.countTag > 60) {
        self.countTag = 0;
    }
    self.circleView.progress = self.countTag;
    
}

// show wave animation when click the button
- (void)makeWaveWithButton:(UIButton *)button andEvent:(UIEvent *)event{

    self.currentType = BtnAnimateTypeWave;
    self.countTag = 0;
    self.animateRadius = 0;
    self.userInteractionEnabled = NO;
    
    NSSet *touches = event.allTouches;
    NSArray *touchesArr = touches.allObjects;
    UITouch *firstTouch = touchesArr.firstObject;
    
    CGPoint touchPoint = [firstTouch locationInView:button];
    self.touchPoint = touchPoint;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(handleTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    UIView *view = [super hitTest:point withEvent:event];
    
    return view;
    
}

- (void)handleTimerAction{

    self.countTag += 1;
    self.animateRadius += 5;
    
    [self setNeedsDisplay];
    
    if (self.countTag > 50) {
        
        // 复位
        self.countTag = 0;
        self.animateRadius = 0;
        [self.timer invalidate];
        self.timer = nil;
        
        // 绘制
        [self setNeedsDisplay];
        
        // 打开交互
        self.userInteractionEnabled = YES;
        
    }
    
}

- (void)drawRect:(CGRect)rect {
  
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (_currentType == BtnAnimateTypeWave)
    {
        CGContextAddArc(context, self.touchPoint.x, self.touchPoint.y, self.animateRadius, 0, 2*M_PI, NO);
        CGContextSetAlpha(context, 1 - self.countTag/50.0);
        [[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1] setStroke];
        [[UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1] setFill];
        
        CGContextFillPath(context);
    }
    
}

- (void)dealloc{

    NSLog(@"dealloc suc!");
    
}

@end
