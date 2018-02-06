//
//  BXLPanCuteView.m
//  iOSClient
//
//  Created by leven on 2018/1/25.
//  Copyright © 2018年 borderxlab. All rights reserved.
//

#import "BXLPanCuteView.h"
#import <YYKit.h>
@interface BXLPanCuteView(){
    __weak UIView *_superView;
    UIView *_backView;
    UIBezierPath *_cutePath;
    CAShapeLayer *_shapeLayer;

    CGPoint _pointA;
    CGPoint _pointB;
    CGPoint _pointC;
    CGPoint _pointD;
    CGPoint _pointO;
    CGPoint _pointP;
    
    CGFloat _centerDistance;
    CGFloat _r1;
    
    CGPoint _originalCenter;
    
    UIColor *_basicColor;
    CGFloat _maxDistance; // default 60;
    BOOL _isAnimation;
    BOOL _cutBubble;
}
@end

@implementation BXLPanCuteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUI];
        [self _addGesture];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setUI];
        [self _addGesture];
    }
    return self;
}

- (void)_addGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panAction:)];
    [self addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)setViscosity:(CGFloat)viscosity {
    _viscosity = viscosity;
    if (_viscosity > 0.3) {
        _viscosity = 0.3;
    }
}

- (UIWindow *)onWindow {
    return [[[UIApplication sharedApplication] delegate] window];
}

- (void)_setUI {
    _backView = [UIView new];
    _shapeLayer = [CAShapeLayer layer];
    _viscosity = 0.11;
    _maxDistance = 50;
    _gestureToDismiss = YES;
    _isAnimation = NO;
    _cutBubble = NO;
}

// 红点断开
- (void)_cutBubble {
    _shapeLayer.path = nil;
    [_shapeLayer removeFromSuperlayer];
    [UIView animateWithDuration:0.13 animations:^{
        _backView.alpha = 0;
        _backView.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }completion:^(BOOL finished) {
        _backView.alpha = 1;
        _backView.hidden = YES;
    }];
}

- (void)_beforDraw {
    _isAnimation = YES;
    _basicColor = self.backgroundColor;
    _superView = self.superview;
    _backView.hidden = NO;
    _backView.frame = CGRectMake(0, 0, self.height, self.height);
    _backView.backgroundColor = _basicColor;
    _backView.layer.cornerRadius = self.height / 2.0;
    _backView.layer.masksToBounds = YES;
    _shapeLayer.fillColor = _basicColor.CGColor;
    _originalCenter = self.center;

    [[self onWindow].layer addSublayer:_shapeLayer];
    
    CGPoint point = [_superView convertPoint:self.center toView:[self onWindow]];
    [[self onWindow] addSubview:_backView];
    [[self onWindow] addSubview:self];
    
    _currentCenter = point;
    self.center = point;
    _backView.center = self.center;
    _backView.hidden = NO;
    _maxDistance = self.width * 2.5;
}

- (void)_setDisplayInfor {
    CGPoint center = self.center;
    
    CGPoint originalOnWindowCenter = [_superView convertPoint:_originalCenter toView:[self onWindow]];
    _centerDistance = sqrtf((center.x - originalOnWindowCenter.x)*(center.x - originalOnWindowCenter.x) + (center.y - originalOnWindowCenter.y)*(center.y - originalOnWindowCenter.y));
    
    CGFloat cosDigree =0 , sinDigree = 0;
    if (_centerDistance >= 0) {
        cosDigree = (center.y - originalOnWindowCenter.y) / _centerDistance;
        sinDigree = (center.x - originalOnWindowCenter.x) / _centerDistance;
    }
    CGFloat initWidthDiff = 2;
    CGFloat r1 = self.width / 2 - initWidthDiff - _centerDistance * self.viscosity;
    _r1 = r1 <= 2 ? 2 : r1;
    _pointA = CGPointMake(originalOnWindowCenter.x - _r1 * cosDigree, originalOnWindowCenter.y + _r1 * sinDigree);
    _pointB = CGPointMake(originalOnWindowCenter.x + _r1 * cosDigree, originalOnWindowCenter.y - _r1 * sinDigree);
    _pointD = CGPointMake(center.x - self.width / 2 * cosDigree, center.y + self.width / 2 * sinDigree);
    _pointC = CGPointMake(center.x + self.width /2  * cosDigree, center.y - self.width / 2 * sinDigree);
    
    
    CGPoint centernLineCenterPoint = CGPointMake((originalOnWindowCenter.x + self.center.x)/2, (originalOnWindowCenter.y + self.center.y)/2);
    CGPoint pointOi = CGPointMake(_pointA.x + _centerDistance/2*sinDigree, _pointA.y+_centerDistance/2*cosDigree);
    CGPoint pointPi = CGPointMake(_pointB.x + _centerDistance/2*sinDigree, _pointB.y+_centerDistance/2*cosDigree);
    
    CGFloat diffScale = _centerDistance/_maxDistance;
    if (diffScale >= 0.9) {
        diffScale = 0.9;
    }
    _pointP = CGPointMake(centernLineCenterPoint.x + (pointPi.x - centernLineCenterPoint.x)*(1 - diffScale), pointPi.y + (centernLineCenterPoint.y - pointPi.y)*diffScale);
    _pointO = CGPointMake(pointOi.x + (centernLineCenterPoint.x - pointOi.x)*diffScale, pointOi.y-(pointOi.y-centernLineCenterPoint.y)*diffScale);
}

- (void)_drawPath {
    CGPoint originalOnWindowCenter = [_superView convertPoint:_originalCenter toView:[self onWindow]];
    _backView.frame = CGRectMake(0,0, _r1*2, _r1*2);
    _backView.center = originalOnWindowCenter;
    _backView.layer.cornerRadius = _r1;
    _backView.layer.masksToBounds = YES;
    
    _cutePath = [UIBezierPath bezierPath];
    [_cutePath moveToPoint:_pointA];
    [_cutePath addQuadCurveToPoint:_pointD controlPoint:_pointO];
    [_cutePath addLineToPoint:_pointC];
    [_cutePath addQuadCurveToPoint:_pointB controlPoint:_pointP];
    [_cutePath addLineToPoint:_pointA];
    
    _shapeLayer.path = _cutePath.CGPath;
    _shapeLayer.fillColor = _basicColor.CGColor;
    
    [[self onWindow].layer insertSublayer:_shapeLayer below:self.layer];
}

- (void)_panAction:(UIGestureRecognizer *)gesture {
    if (!_gestureToDismiss) return;
    
    CGPoint point = [gesture locationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self _beforDraw];
    }else if(gesture.state == UIGestureRecognizerStateChanged) {
        point = [self convertPoint:point toView:[self onWindow]];
        _currentCenter = point;
        self.center = point;
        [self _setDisplayInfor];
        if (_centerDistance > _maxDistance
            && !_cutBubble) {
            _cutBubble = YES;
            [self _cutBubble];
        }else if (!_cutBubble){
            [self _drawPath];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded ||
              gesture.state == UIGestureRecognizerStateCancelled ||
              gesture.state == UIGestureRecognizerStateFailed) {
        
        [self _cutBubble];
        CGPoint  velocityPoint = [(UIPanGestureRecognizer *)gesture velocityInView:self];
        if (_centerDistance <= _maxDistance) {
            _cutBubble = NO;
            [self _backOriginalPoint];
        }else {
            _cutBubble = YES;
            if (fabs(velocityPoint.x) > 300 || fabs(velocityPoint.y) > 300) {
                [self _moveToVelocityPointDismiss:velocityPoint];
            }else{
                [self _moveToVelocityPointDismiss:CGPointZero];
            }
        }
    }
}

- (void)_tapAction:(UIGestureRecognizer *)gesture {
    if (!_gestureToDismiss) return;
    [self _moveToVelocityPointDismiss:CGPointZero];
}

- (void)_moveToVelocityPointDismiss:(CGPoint)point{
    CGPoint center  = self.center;
    center = CGPointMake(center.x + point.x / 30, center.y + point.y / 30);
    NSTimeInterval time = sqrt((self.center.x - center.x)*(self.center.x - center.x) + (self.center.y - center.y)*(self.center.y - center.y)) / 600;
    
    if (time <= 0.15) {
        time = 0.15;
    }
    _currentCenter = center;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.center = center;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        _currentCenter = _originalCenter;
        self.center = _originalCenter;
        self.alpha = 1;
        self.hidden = YES;
        [_superView addSubview:self];
        if ([_delegate respondsToSelector:@selector(BXLPanCuteViewDidGestureToDismiss)]) {
            [_delegate BXLPanCuteViewDidGestureToDismiss];
        }
        [self _setUI];
    }];
}

- (void)_backOriginalPoint {
    UIScrollView *scr = (id)_superView;
    UIView *superView = _superView;
    // 如果父类层级以上视图还有可滑动的视图，则在此视图完成动画。
    while (superView) {
        if ([superView isKindOfClass:[UIScrollView class]]) {
            scr = (id)superView;
        }
        superView = superView.superview;
    }

    CGPoint originalCenterOnScr= [[self onWindow] convertPoint:self.center toView:scr];
    _currentCenter = originalCenterOnScr;
    self.center = originalCenterOnScr;
    [scr addSubview:self];

    CGPoint initCenter = [_superView convertPoint:_originalCenter toView:scr];
    _currentCenter = initCenter;

    [UIView animateWithDuration:0.4
                          delay:0.0f
         usingSpringWithDamping:0.3f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.center = initCenter;
                         _backView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [_superView addSubview:self];
                             _currentCenter = _originalCenter;
                             self.center = _originalCenter;
                             [self _setUI];
                             _backView.hidden = YES;
                         }
                     }];
}


@end
