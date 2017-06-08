//
//  ViewController.m
//  DynamicBadge
//
//  Created by Tree on 2017/5/25.
//  Copyright © 2017年 Tr2e. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SPWaveButton.h"

#define ThemeColor [UIColor colorWithRed:30/255.0 green:144/255.0 blue:1 alpha:1]

@interface ViewController ()

@property (nonatomic, strong) UIView *redCircle;
@property (nonatomic, strong) UIImageView *animationView;

@property (nonatomic, strong) CAShapeLayer *testLayer;
@property (nonatomic, strong) CAShapeLayer *testLayer2;
@property (nonatomic, strong) CAShapeLayer *testLayer3;

@property (nonatomic, weak) UIButton *testButton;
@property (nonatomic, weak) SPWaveButton *waveButton;
@property (nonatomic, weak) UIImageView *testImgView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}

#pragma mark - 综合
- (void)waveBtnClickAction:(UIButton *) button Event:(UIEvent *)event{

    [self.waveButton makeWaveWithButton:button andEvent:event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self  callWaveBtnAnimation];
    });

    [self testForCAEmitterLayer];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    self.testLayer.strokeEnd = 1;
//    self.testLayer2.strokeEnd = 1;
//    self.testLayer3.strokeEnd = 1;
    
    [self testForCAReplicatorLayer];
    
}


#pragma mark - CAReplicatorLayer
- (void)testForCAReplicatorLayer{
    
    // sound wave
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.bounds = CGRectMake(0, 0, 100, 100);
    circle.position = self.view.center;
    circle.opacity = 1;
    
    UIBezierPath *circlepath  = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:15 startAngle:0 endAngle:2 * M_PI  clockwise:YES];
    circle.fillColor = ThemeColor.CGColor;
    circle.path = circlepath.CGPath;
    

    CABasicAnimation *opacity = [CABasicAnimation animation];
    opacity.keyPath = @"opacity";
    opacity.fromValue = @1;
    opacity.toValue = @0;
    

    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.fromValue = @1;
    scale.toValue = @(0.3);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.8;
    group.fillMode = kCAFillModeForwards;
    [group setRemovedOnCompletion:YES];
    group.animations = @[scale];
    group.autoreverses = YES;
    group.repeatCount = MAXFLOAT;
    [circle addAnimation:group forKey:nil];

    
    CAReplicatorLayer *gradientLayer = [CAReplicatorLayer layer];
    [gradientLayer addSublayer:circle];
    gradientLayer.instanceCount = 3;
    gradientLayer.instanceDelay = 0.3;
    
//    [self.view.layer addSublayer:gradientLayer];
    
    // loading ball
    CAReplicatorLayer *instanceGradient = [CAReplicatorLayer layer];
    [instanceGradient addSublayer:circle];
    instanceGradient.instanceCount = 3;
    instanceGradient.instanceDelay = 0.2;
    instanceGradient.instanceTransform = CATransform3DMakeTranslation(50, 0, 0);
    
    [self.view.layer addSublayer:instanceGradient];
    
}

#pragma mark - CAshapeLayer
- (void)testForCAShapeLayer{
    
    // bezierPath
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 200)];
    [path addCurveToPoint:CGPointMake(screenBounds.size.width - 20, 200) controlPoint1:CGPointMake(screenBounds.size.width/2, 50) controlPoint2:CGPointMake(screenBounds.size.width/2, 350)];

    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.strokeEnd = 0;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3;
    shapeLayer.path = path.CGPath;
    
    self.testLayer = shapeLayer;
    [self.view.layer addSublayer:shapeLayer];
    
    // CGPath
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath, NULL, 20, 200);
    CGPathAddLineToPoint(mutablePath, NULL, screenBounds.size.width/2, 50);
    CGPathAddLineToPoint(mutablePath, NULL, screenBounds.size.width/2, 350);
    CGPathAddLineToPoint(mutablePath, NULL, screenBounds.size.width - 20, 200);
    
    CAShapeLayer *shapeLayer2 = [[CAShapeLayer alloc] init];
    shapeLayer2.strokeEnd = 0;
    shapeLayer2.strokeColor = [UIColor lightGrayColor].CGColor;
//    shapeLayer2.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.1].CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = 5;
    shapeLayer2.lineCap = kCALineCapRound;
    shapeLayer2.lineJoin = kCALineJoinBevel;
    shapeLayer2.path = mutablePath;
    
    self.testLayer2 = shapeLayer2;
    [self.view.layer addSublayer:shapeLayer2];
    
    
    CGMutablePathRef mutablePath2 = CGPathCreateMutable();
    CGPathMoveToPoint(mutablePath2, NULL, screenBounds.size.width/2, screenBounds.size.height - 50);
    CGPathAddLineToPoint(mutablePath2, NULL, screenBounds.size.width/2, 380);

    
    CAShapeLayer *shapeLayer3 = [CAShapeLayer layer];
    shapeLayer3.strokeColor = [UIColor purpleColor].CGColor;
    shapeLayer3.lineWidth = 20;
    shapeLayer3.path = mutablePath2;
    shapeLayer3.strokeEnd = 0;
    
    self.testLayer3 = shapeLayer3;
    [self.view.layer addSublayer:shapeLayer3];
    
    
    // slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, screenBounds.size.height - 50, screenBounds.size.width - 40, 50)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.value = 1;
    [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
}

- (void)valueChanged:(UISlider *)slider{

    self.testLayer.strokeEnd = slider.value;
    self.testLayer2.strokeEnd = slider.value;
    self.testLayer3.strokeEnd = slider.value;
    
}

#pragma mark - GradientLayer
- (void)testForGradientLayer{

    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.label.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);// 类似anchor point的映射关系
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.colors = @[(__bridge id _Nullable)[UIColor clearColor].CGColor,(__bridge id _Nullable)[UIColor whiteColor].CGColor,(__bridge id _Nullable)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@0,@0,@0.3];// [0,1]
    
    CABasicAnimation *basic = [CABasicAnimation animation];
    basic.keyPath = @"locations";
    basic.toValue = @[@0.7,@1,@1];
    basic.duration = 3.0;
    basic.fillMode = kCAFillModeForwards;

    [basic setRemovedOnCompletion:NO];
    basic.repeatCount = MAXFLOAT;
    
    [gradientLayer addAnimation:basic forKey:nil];
    
    // 设置蒙板
    self.label.layer.mask = gradientLayer;
    
}

- (void)setupUI4GradientLayer{

    self.label = [[UILabel alloc] init];
    _label.text = @"Slide To Unlock";
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    _label.frame = CGRectMake(30, CGRectGetHeight(self.view.bounds) -  100, CGRectGetWidth(self.view.bounds) - 60, 60);
    
    [self.view addSubview:_label];
    self.view.backgroundColor = [UIColor blackColor];
    
}

#pragma mark - EmitterLayer
- (void)testForCAEmitterLayer{

    // 初始化发射器图层
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.birthRate = 1;
    emitterLayer.lifetime = 10;
    emitterLayer.emitterPosition = self.view.center;
    emitterLayer.emitterSize = self.waveButton.frame.size;
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    emitterLayer.renderMode = kCAEmitterLayerOldestFirst;

    // 初始化发射单元并标记name，方便通过keypath修改相关属性
    CGSize particleSize = CGSizeMake(15, 25);
    CAEmitterCell *blueCell = [self demo_CAEmitterCellWithImage:[self createImageWithColor:[UIColor blueColor] andSize:particleSize]];
    blueCell.name = @"blue";
    CAEmitterCell *yellowCell = [self demo_CAEmitterCellWithImage:[self createImageWithColor:[UIColor yellowColor] andSize:particleSize]];
    yellowCell.name = @"yellow";
    CAEmitterCell *redCell = [self demo_CAEmitterCellWithImage:[self createImageWithColor:[UIColor redColor] andSize:particleSize]];
    redCell.name = @"red";
    
    // 将发射单元添加至发射器
    emitterLayer.emitterCells = @[blueCell,yellowCell,redCell];
    // 添加发射动画
    [emitterLayer addAnimation:demo_ParticleAnimation() forKey:nil];
    
    // 在目标位置添加发射器
    [self.view.layer addSublayer:emitterLayer];
    
}


CAAnimationGroup *demo_ParticleAnimation(){

    CABasicAnimation *blue = [CABasicAnimation animation];
    blue.keyPath = @"emitterCells.blue.birthRate";
    blue.fromValue = @30;
    blue.toValue = @0;
    
    CABasicAnimation *red = [CABasicAnimation animation];
    red.keyPath = @"emitterCells.red.birthRate";
    red.fromValue = @30;
    red.toValue = @0;
    
    CABasicAnimation *yellow = [CABasicAnimation animation];
    yellow.keyPath = @"emitterCells.yellow.birthRate";
    yellow.fromValue = @30;
    yellow.toValue = @0;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[blue,red,yellow];
    group.duration = 1.0f;
    group.fillMode = kCAFillModeForwards;
    [group setRemovedOnCompletion:NO];
    
    return group;
    
}

- (CAEmitterCell *)demo_CAEmitterCellWithImage:(UIImage *)image{

    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    // contents
    emitterCell.contents = (__bridge id _Nullable)(image.CGImage);
    // birthRate
    emitterCell.birthRate = 10;
    // lifetime
    emitterCell.lifetime = 40;
    emitterCell.lifetimeRange = 20;
    // emission
    // emitterCell.emissionLongitude
    // emitterCell.emissionLatitude
    emitterCell.emissionRange = M_PI_2;
    // volocity
    emitterCell.velocity = 200;
    emitterCell.velocityRange = 20;
    // Acceleration
    emitterCell.xAcceleration = 0;
    emitterCell.yAcceleration = 9.8;
    // scale
    emitterCell.scale = 0.6;
    emitterCell.scaleRange = 0.6;
    // spin
    emitterCell.spin = M_PI * 2;
    emitterCell.spinRange = M_PI * 2;
    // color
    // emitterCell.redRange = 0.1f;
    // emitterCell.greenRange = 0.1f;
    // emitterCell.blueRange = 0.1f;
    // emitterCell.alphaRange = 1;
    // color speed
    // emitterCell.alphaSpeed = 10;
    
    
    return emitterCell;
    
}

- (UIImage *)createImageWithColor:(UIColor *)color andSize:(CGSize)size{

    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}



#pragma mark - CATransition
- (void)setImgViewForCATransiton{

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"pic_1"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = 5;
    imageView.layer.masksToBounds = YES;
    
    self.testImgView = imageView;
    [self.view addSubview:imageView];
    
}

- (void)testForCATransition{

    self.testImgView.image = [UIImage imageNamed:@"pic_2"];
    
    CATransition *transition = [[CATransition alloc] init];
    transition.type = @"cameraIrisHollowOpen";
    transition.subtype = kCATransitionFromTop;
    transition.duration = 0.35;

    [self.testImgView.layer addAnimation:transition forKey:nil];
    
}

#pragma mark - wavebtn
- (void)testForWaveBtn{

    SPWaveButton *waveBtn = [[SPWaveButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    waveBtn.center = self.view.center;
    waveBtn.backgroundColor = [UIColor whiteColor];
    [waveBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    [waveBtn setTitleColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:1 alpha:1] forState:UIControlStateNormal];
    waveBtn.layer.borderWidth = 2;
    waveBtn.layer.borderColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:1 alpha:1].CGColor;
    waveBtn.layer.masksToBounds = YES;
    
    [waveBtn addTarget:self action:@selector(waveBtnClickAction:Event:) forControlEvents:UIControlEventTouchUpInside];
    self.waveButton = waveBtn;
    
    [self.view addSubview:waveBtn];
    
}

- (void)callWaveBtnAnimation{
    
    CGRect waveFrame = self.waveButton.frame;
    waveFrame.size.width = 60;
    [self.waveButton setTitle:@"" forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    self.waveButton.frame = waveFrame;
    self.waveButton.center = self.view.center;
    [UIView commitAnimations];


    CAKeyframeAnimation *borderColor = [[CAKeyframeAnimation alloc] init];
    borderColor.keyPath = @"borderColor";
    borderColor.values = @[(__bridge id _Nullable)[UIColor colorWithRed:30/255.0 green:144/255.0 blue:1 alpha:1].CGColor,(__bridge id _Nullable)[UIColor clearColor].CGColor];
    borderColor.keyTimes = @[
                             [NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:0.8]
                           ];
    
    CABasicAnimation *rect = [[CABasicAnimation alloc] init];
    rect.keyPath = @"cornerRadius";
    rect.toValue = @30;
    
    CABasicAnimation *borderWidth = [[CABasicAnimation alloc] init];
    borderWidth.keyPath = @"borderWidth";
    borderWidth.toValue = @3;
    
    CABasicAnimation *backgroundColor = [[CABasicAnimation alloc] init];
    backgroundColor.keyPath = @"backgroundColor";
    backgroundColor.toValue = (__bridge id _Nullable)([UIColor clearColor].CGColor);

    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[borderColor,rect,borderWidth,backgroundColor];
    group.duration = 0.25f;
    group.fillMode = kCAFillModeForwards;
    [group setRemovedOnCompletion:NO];

    [self.waveButton.layer addAnimation:group forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.waveButton makeRotateCircleWithRadius:30];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.waveButton completeAnimation];
    });
    
}

- (void)initializeUI{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Animation" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = self.view.center;
    button.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:button];
    self.testButton = button;
    
    self.testButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.testButton.layer.shadowOpacity = 0.5;
    
    NSLog(@"\nshadowOffset:%f,%f",self.testButton.layer.shadowOffset.width,self.testButton.layer.shadowOffset.height);
    NSLog(@"\nshadowRadius:%f",self.testButton.layer.shadowRadius);

}

/**
 *
 *  positon
 *  cornerRadius
 *  translation.x/y/z
 *  transform.scale/rotation
 *  borderWidth/borderColor
 *  opacity ( like UIView's alpha )
 *  shadowOpacity
 *  shadowRadius ( default is 3.0f)
 *  shadowOffset ( default is (.0f,-3.0f) )
 *  backgroundColor
 ( when we want to change color,we need to use UIColor like this :(__bridge id _Nullable)([UIColor greenColor].CGColor) )
 *
 */

- (void)callAnimationGroup{

    CAKeyframeAnimation *keyframe = [[CAKeyframeAnimation alloc] init];
    keyframe.keyPath = @"position";
    keyframe.path = [self keyframePath];
    
    CAKeyframeAnimation *colors = [[CAKeyframeAnimation alloc] init];
    colors.keyPath = @"backgroundColor";
    colors.values = @[
                        (__bridge id _Nullable)[UIColor redColor].CGColor,
                        (__bridge id _Nullable)[UIColor yellowColor].CGColor,
                        (__bridge id _Nullable)[UIColor greenColor].CGColor,
                        (__bridge id _Nullable)[UIColor blueColor].CGColor,
                        (__bridge id _Nullable)[UIColor purpleColor].CGColor
                        ];
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[keyframe,colors];
    group.duration = 5.0f;
    group.fillMode = kCAFillModeForwards;
    [group setRemovedOnCompletion:NO];
    
    [self.testButton.layer addAnimation:group forKey:nil];
    
}

- (void)callKeyframeAnimation{// CAKeyframeAnimation
    
    CAKeyframeAnimation *keyframe = [[CAKeyframeAnimation alloc] init];
    keyframe.keyPath = @"position";
    keyframe.duration = 5.0f;
//    keyframe.repeatCount = MAXFLOAT;
    keyframe.fillMode = kCAFillModeForwards;
    keyframe.calculationMode = kCAAnimationCubic;
    [keyframe setRemovedOnCompletion:NO];
//    keyframe.values = @[
//                        (__bridge id _Nullable)[UIColor redColor].CGColor,
//                        (__bridge id _Nullable)[UIColor yellowColor].CGColor,
//                        (__bridge id _Nullable)[UIColor greenColor].CGColor,
//                        (__bridge id _Nullable)[UIColor blueColor].CGColor,
//                        (__bridge id _Nullable)[UIColor purpleColor].CGColor
//                        ];
    
    keyframe.path = [self keyframePath];
    
    [self.testButton.layer addAnimation:keyframe forKey:nil];

    
}

- (CGMutablePathRef )keyframePath{

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 100, 100);
    CGPathAddLineToPoint(path, NULL, 100, 200);
    CGPathAddLineToPoint(path, NULL, 200, 350);

    CGPathAddArc(path, NULL, 200, 350, 100, 0, M_PI, NO);
    
    return path;
    
}

- (void)callBasicAnimation{

    CASpringAnimation *basic = [[CASpringAnimation alloc] init];
    basic.keyPath = @"cornerRadius";
    basic.toValue =  @15;
    basic.duration = 2.0f;
    basic.fillMode = kCAFillModeForwards;
    [basic setRemovedOnCompletion:NO];
    basic.damping = 6;
    basic.initialVelocity = 5;
    basic.mass = 0.5;
    
    [self.testButton.layer addAnimation:basic forKey:nil];
    
}

- (void)testForCALayer{

    self.testLayer = [[CAShapeLayer alloc] init];
    _testLayer.strokeEnd = 0;
    _testLayer.strokeColor = [UIColor redColor].CGColor;
    _testLayer.fillColor = [UIColor clearColor].CGColor;
    _testLayer.lineWidth = 3;
    _testLayer.path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:100 startAngle:-M_PI_2 endAngle:3/2.0*M_PI clockwise:YES].CGPath;
    [self.view.layer addSublayer:_testLayer];
    
}

- (void)animationForLayer{

    self.testLayer.strokeEnd = 1;
    
}


#pragma mark - GIF 分解播放
/**
 *  GIF -> NSData -> ImageIO -> UIImage
 */
- (void)testOfGif{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"gakki2" ofType:@"gif"];
//    UIImage *animateImg = [UIImage imageWithContentsOfFile:path];
    
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    
    CGImageSourceRef gifdataSource = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    size_t count = CGImageSourceGetCount(gifdataSource);
    
    UIImage *animateImg = nil;
    if (count <= 1)
    {
        animateImg = [UIImage imageWithData:gifData];
    }
    else
    {
        NSMutableArray *imgArr = [[NSMutableArray alloc] init];
        CGFloat timeinterval = 0.0f;
        
        for (size_t i = 0; i < count; i ++) {
            CGImageRef imgRf = CGImageSourceCreateImageAtIndex(gifdataSource, i, NULL);
            
            if (!imgRf) {
                continue;
            }
            
            timeinterval += [self getKeyFrameDurationWithIndex:i andSoureceRef:gifdataSource];
            
            UIImage *img = [UIImage imageWithCGImage:imgRf scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            [imgArr addObject:img];
            CGImageRelease(imgRf);

        }
        
        CFRelease(gifdataSource);
        
        animateImg = [UIImage animatedImageWithImages:imgArr duration:timeinterval];
        
    }
    
    
    UIImageView *gifImageView = [[UIImageView alloc] initWithImage:animateImg];
    [gifImageView sizeToFit];
    gifImageView.center = self.view.center;
    
    [self.view addSubview:gifImageView];
    
}

- (CGFloat)getKeyFrameDurationWithIndex:(size_t )index andSoureceRef:(CGImageSourceRef )soureRef{

    CGFloat frameDuration = 0.1f;
    
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(soureRef, index, NULL);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *duration = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    
    if (duration)
    {
        frameDuration = duration.floatValue;
    }
    else
    {
        NSNumber *duration = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (duration) frameDuration = duration.floatValue;
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.1f;
    }
    
    CFRelease(cfFrameProperties);
    
    return frameDuration;
    
}


#pragma mark - GIF合成
/**
 *  序列帧图片的读取 -> 创建Gif文件，获取CGImageDestinationRef -> 为单帧图片CGImageRef属性赋值 -> 为Gif设置相关属性 -> 通过CGImageDestinationRef合成gif
 */

- (void)createGifFile{

    NSMutableArray *imgArr = [NSMutableArray new];
    for (int i = 1; i < 67; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"m2_1%04d",i]];
        [imgArr addObject:img];
    }
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *magicPath = [path stringByAppendingString:@"/magic.gif"];
    
    NSLog(@"magicPath : %@",magicPath);
    
    CFURLRef URLRef = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)magicPath, kCFURLPOSIXPathStyle, NO);
    CGImageDestinationRef gifRef = CGImageDestinationCreateWithURL(URLRef, kUTTypeGIF,imgArr.count, NULL);
    
    NSDictionary *keyFrameDict = @{(NSString *)kCGImagePropertyGIFDelayTime:@(1/30.0)};// 30fps
    NSDictionary *gifKeyFrameDict = @{(NSString *)kCGImagePropertyGIFDictionary:keyFrameDict};
    
    for (UIImage *image in imgArr) {// 每帧图片进行设置
        
        CGImageRef imageRef = [image CGImage];
        CGImageDestinationAddImage(gifRef, imageRef, (__bridge CFDictionaryRef) gifKeyFrameDict);
        
    }
    
    NSDictionary *gifSettingDict = @{
                                     
                                     // 色彩空间格式
                                     (NSString *)kCGImagePropertyColorModel:(NSString *)kCGImagePropertyColorModelGray,
                                     // 色彩深度
                                     (NSString *)kCGImagePropertyDepth:@(8),
                                     // gif执行次数
                                     (NSString *)kCGImagePropertyGIFLoopCount:@(1)
                                     
                                     };
    
    NSDictionary *gifDict = @{
                              
                              (NSString *)kCGImagePropertyGIFDictionary : gifSettingDict
                              
                              };
    
    CGImageDestinationSetProperties(gifRef, (__bridge CFDictionaryRef) gifDict);
    
    CGImageDestinationFinalize(gifRef);
    
}

- (void)keyframeImgAnimation{

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.animationView = [[UIImageView alloc] init];
    self.animationView.image = [UIImage imageNamed:@"m2_10001"];
    [self.animationView sizeToFit];
    self.animationView.center = self.view.center;
    [self.view addSubview:self.animationView];
    
    
    NSMutableArray *imgArr = [NSMutableArray new];
    for (int i = 1; i < 67; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"m2_1%04d",i]];
        [imgArr addObject:img];
    }
    
    self.animationView.animationImages = [imgArr copy];
    self.animationView.animationDuration = 67/30.0;
    [self.animationView startAnimating];
    
}

- (void)addKeyFrameChangedCircle{

        self.redCircle = [[UIView alloc] init];
        _redCircle.backgroundColor = [UIColor redColor];
        _redCircle.frame = CGRectMake(0, 0, 50, 50);
        _redCircle.layer.cornerRadius = 5;
        [_redCircle.layer masksToBounds];
    
        [self.view addSubview:_redCircle];
    
}

- (void)keyframeAnimation{

    [UIView animateKeyframesWithDuration:10 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1/5.0 animations:^{
            self.redCircle.frame = CGRectMake(50, 200, 50, 50);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/5.0 relativeDuration:1/5.0 animations:^{
            self.redCircle.frame = CGRectMake(100, 250, 50, 50);
        }];
        [UIView addKeyframeWithRelativeStartTime:2/5.0 relativeDuration:1/5.0 animations:^{
            self.redCircle.frame = CGRectMake(150, 275, 50, 50);
        }];
        [UIView addKeyframeWithRelativeStartTime:3/5.0 relativeDuration:1/5.0 animations:^{
            self.redCircle.frame = CGRectMake(200, 350, 50, 50);
        }];
        [UIView addKeyframeWithRelativeStartTime:4/5.0 relativeDuration:1/5.0 animations:^{
            self.redCircle.frame = CGRectMake(250, 500, 50, 50);
        }];
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self keyframeAnimation];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
