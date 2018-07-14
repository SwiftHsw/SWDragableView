//
//  ATDragableBaseView.m
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ATDragableBaseView.h"

#import "ATImageZoomView.h"
#import "ATRecognizeSimultaneousTableView.h"

static CGFloat const gestureMinimumTranslation = 5.0;

@interface ATDragableBaseView()<UIGestureRecognizerDelegate,CAAnimationDelegate>
@property(nonatomic,readwrite)UIView *dragViewBg ;//用户设置整个视图的背景
@property(nonatomic,readwrite)UIView *dragContentView ;//需要显示的视图都加到contentView里面
@property(nonatomic,strong)UIPanGestureRecognizer *panRecognizer;//拖动视图的手势
@property(nonatomic,assign)ATMoveDirection dragDirection;//拖动的方向
@end

@implementation ATDragableBaseView

- (instancetype)init{
    self = [super init];
    if(self){
        [self initDragableBaseView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initDragableBaseView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.dragContentView.frame = CGRectMake(0, self.topSpace,self.width, self.height - self.topSpace);
}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (void)initDragableBaseView{
    self.topSpace = 0;
    self.contentViewCornerRadius = 0 ;
    self.cornerEdge = UIRectCornerAllCorners;
    self.enableHorizonDrag = YES ;
    self.enableVerticalDrag = YES ;
    self.enableFreedomDrag = NO ;
    self.defaultHideAnimateWhenDragFreedom = YES ;
    [self addGestureRecognizer:self.panRecognizer];
    [self addSubview:self.dragViewBg];
    [self addSubview:self.dragContentView];
    
    self.dragContentView.frame = CGRectMake(0, self.topSpace,self.width, self.height - self.topSpace);
    
    [self.dragViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    weakSelf(self);
    [self.dragViewBg addTapGestureWithBlock:^(UIView *gestureView) {
        
        [weakSelf startHide];
    }];
}

#pragma mark -- 拖动手势

- (void)panRecognizer:(UIPanGestureRecognizer *)panRecognizer{
    UIGestureRecognizerState state = panRecognizer.state;
    CGPoint point = [panRecognizer translationInView:self];
    if(state == UIGestureRecognizerStateChanged){
        if(self.enableFreedomDrag){
            //如果self.direction == ATMoveDirectionNone，说明偏移量还没有达到gestureMinimumTranslation，不允许拖动
            if(self.dragDirection == ATMoveDirectionNone){
                self.dragDirection = [self determineDirection:point];
                return ;
            }
            CGFloat top = fabs(self.dragContentView.top);
            CGFloat left = fabs(self.dragContentView.left);
            self.dragContentView.centerY = self.dragContentView.centerY + point.y;
            self.dragContentView.centerX = self.dragContentView.centerX + point.x;
            CGFloat alphaTop = (1.0 - (top - self.topSpace) / self.dragContentView.height) ;
            CGFloat alphaLeft = (1.0 - left / self.dragContentView.width) ;
            self.dragViewBg.alpha = MAX(MIN(alphaTop,alphaLeft),0);
            
            [panRecognizer setTranslation:CGPointMake(0, 0) inView:self];
            
            [self dragingWithPoint:[panRecognizer locationInView:self]];
            
        }else{
            if(self.dragDirection == ATMoveDirectionNone){
                self.dragDirection = [self determineDirection:point];
            }
            if(self.dragDirection == ATMoveDirectionUp ||
               self.dragDirection == ATMoveDirectionDown){
                if(!self.enableVerticalDrag){
                    self.dragDirection = ATMoveDirectionNone ;
                    self.dragViewBg.alpha = 1.0 ;
                    self.dragContentView.top = self.topSpace;
                    self.dragContentView.layer.transform = CATransform3DIdentity;
                    return ;
                }
                CGFloat top = self.dragContentView.top;
                if(top + point.y < self.topSpace){
                    self.dragContentView.top = self.topSpace ;
                    return ;
                }
                self.dragContentView.centerY = self.dragContentView.centerY + point.y;
                CGFloat alpha = (1.0 - (top - self.topSpace) / self.dragContentView.height) ;
                self.dragViewBg.alpha = MAX(alpha,0);
                
                [panRecognizer setTranslation:CGPointMake(0, 0) inView:self];
                
                [self dragingWithPoint:[panRecognizer locationInView:self]];
                
            }else if(self.dragDirection == ATMoveDirectionLeft ||
                     self.dragDirection == ATMoveDirectionRight){
                if(!self.enableHorizonDrag){
                    self.dragDirection = ATMoveDirectionNone ;
                    self.dragViewBg.alpha = 1.0 ;
                    self.dragContentView.left = 0;
                    self.dragContentView.layer.transform = CATransform3DIdentity;
                    return ;
                }
                CGFloat left = self.dragContentView.left;
                self.dragContentView.centerX = self.dragContentView.centerX + point.x;
                CGFloat alpha = (1.0 - left / self.dragContentView.width) ;
                self.dragViewBg.alpha = MAX(alpha,0);
                
                [panRecognizer setTranslation:CGPointMake(0, 0) inView:self];
                
                [self dragingWithPoint:[panRecognizer locationInView:self]];
            }
        }
    }else if(state == UIGestureRecognizerStateEnded ||
             state == UIGestureRecognizerStateFailed ||
             state == UIGestureRecognizerStateCancelled){
        BOOL shouldHideView = NO ;
        CGFloat top = self.dragContentView.top;
        CGFloat left = self.dragContentView.left;
        CGFloat maxOffsetY = self.dragContentView.height / 6 ;
        CGFloat maxOffsetX = self.dragContentView.width / 6 ;
        if(self.enableFreedomDrag){
            if(((top - self.topSpace) >= maxOffsetY) ||
               (top < 0 && (fabs(top) - self.topSpace) >= maxOffsetY)){
                if(self.defaultHideAnimateWhenDragFreedom){
                    [self popOutToTop:top < 0];
                    return ;
                }
                shouldHideView = YES ;
            }else{
                if(left >= maxOffsetX ||
                   (left < 0 && fabs(left) >= maxOffsetX)){
                    if(self.defaultHideAnimateWhenDragFreedom){
                        [self pushOutToRight:left > 0];
                        return ;
                    }
                    shouldHideView = YES ;
                }else{
                    [self restoreView];
                }
            }
        }else{
            if(self.dragDirection == ATMoveDirectionUp ||
               self.dragDirection == ATMoveDirectionDown){
                if((top-self.topSpace) >= maxOffsetY){
                    [self popOutToTop:NO];
                    shouldHideView = YES ;
                }else{
                    [self restoreView];
                }
            }else if(self.dragDirection == ATMoveDirectionLeft ||
                     self.dragDirection == ATMoveDirectionRight){
                CGFloat left = self.dragContentView.left;
                if(left > 0 && left >= maxOffsetX){
                    [self pushOutToRight:YES];
                    shouldHideView = YES ;
                }else if(left < 0 && fabs(left) >= maxOffsetX){
                    [self pushOutToRight:NO];
                    shouldHideView = YES ;
                }else{
                    [self restoreView];
                }
            }
        }
        
        [self dragEndWithPoint:[panRecognizer locationInView:self] shouldHideView:shouldHideView];
        
    }else if(state == UIGestureRecognizerStateBegan){
        self.dragDirection = ATMoveDirectionNone;
        [self dragBeginWithPoint:[panRecognizer locationInView:self]];
    }
}

- (ATMoveDirection)determineDirection:(CGPoint)translation{
    if (self.dragDirection != ATMoveDirectionNone){
        return self.dragDirection;
    }
    if (fabs(translation.x) > gestureMinimumTranslation){
        BOOL gestureHorizontal = NO;
        if (translation.y ==0.0){
            gestureHorizontal = YES;
        }else{
            gestureHorizontal = fabs(translation.x - translation.y) > gestureMinimumTranslation;
        }
        if (gestureHorizontal){
            if (translation.x >0.0){
                return ATMoveDirectionRight;
            }else{
                return ATMoveDirectionLeft;
            }
        }
    }else if (fabs(translation.y) > gestureMinimumTranslation){
        BOOL gestureVertical = NO;
        if (translation.x ==0.0){
            gestureVertical = YES;
        }else{
            gestureVertical = fabs(translation.x - translation.y) >gestureMinimumTranslation;
        }
        if (gestureVertical){
            if (translation.y >0.0){
                return ATMoveDirectionDown;
            }else{
                return ATMoveDirectionUp;
            }
        }
    }
    return self.dragDirection;
}

#pragma mark -- 恢复视图的正确位置

- (void)restoreView{
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:2.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.dragViewBg.alpha = 1.0 ;
                         self.dragContentView.left = 0;
                         self.dragContentView.top = self.topSpace;
                         self.dragContentView.layer.transform = CATransform3DIdentity;
                     }completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark -- 显示与隐藏动画

- (void)startShow{
    [self viewWillAppear];
    self.showViewType = ATShowViewTypeNone;
    self.dragViewBg.alpha = 0 ;
    self.dragContentView.top = UIDeviceScreenHeight;
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.85
          initialSpringVelocity:5.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.dragViewBg.alpha = 1.0 ;
                         self.dragContentView.top = self.topSpace;
                     }completion:^(BOOL finished) {
                         [self viewDidAppear];
                     }];
}

- (void)startHide{
    [self viewWillDisappear];
    [UIView animateWithDuration:0.2 animations:^{
        self.dragViewBg.alpha = 0.0 ;
        self.dragContentView.top = UIDeviceScreenHeight;
    } completion:^(BOOL finished) {
        [self removeGestureRecognizer:self.panRecognizer];
        [self viewDidDisappear];
        [self removeFromSuperview];
    }];
}

- (void)popIn{
    [self viewWillAppear];
    self.showViewType = ATShowViewTypePopup;
    self.dragContentView.y = UIDeviceScreenHeight;
    self.dragViewBg.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.dragContentView.y = self.topSpace ;
        self.dragViewBg.alpha = 1.0;
    }completion:^(BOOL finished) {
        [self viewDidAppear];
    }];
}

- (void)popOutToTop:(BOOL)toTop{
    [self viewWillDisappear];
    [UIView animateWithDuration:0.3 animations:^{
        if(toTop){
            self.dragContentView.y = -UIDeviceScreenHeight ;
        }else{
            self.dragContentView.y = UIDeviceScreenHeight ;
        }
        self.dragViewBg.alpha = 0.0 ;
    }completion:^(BOOL finished) {
        [self viewDidDisappear];
        [self removeFromSuperview];
    }];
}

- (void)pushIn{
    [self viewWillAppear];
    self.showViewType = ATShowViewTypePush;
    self.dragContentView.x = UIDeviceScreenWidth ;
    self.dragViewBg.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.dragContentView.x = 0 ;
        self.dragViewBg.alpha = 1.0;
    }completion:^(BOOL finished) {
        [self viewDidAppear];
    }];
}

- (void)pushOutToRight:(BOOL)toRight{
    [self viewWillDisappear];
    [UIView animateWithDuration:0.3 animations:^{
        if(toRight){
            self.dragContentView.x = UIDeviceScreenWidth ;
        }else{
            self.dragContentView.x = -UIDeviceScreenWidth ;
        }
        self.dragViewBg.alpha = 0.0 ;
    }completion:^(BOOL finished) {
        [self viewDidDisappear];
        [self removeFromSuperview];
    }];
}

#pragma mark -- UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    UIView *view = otherGestureRecognizer.view ;
    //与ATImageZoomView的点击、双击手势冲突
    if([view isKindOfClass:[ATImageZoomView class]] &&
       [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        return NO ;
    }else{
        //与上下滚动的视图有冲突
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *view = (UIScrollView *)otherGestureRecognizer.view;
            if(view.contentOffset.y > 0.0){
                return NO ;
            }
            if(view.tag == ATViewTagPersonInfoArtical ||
               view.tag == ATViewTagPersonInfoVideo ||
               view.tag == ATViewTagPersonInfoWenDa ||
               view.tag == ATViewTagPersonInfoDongTai ||
               view.tag == ATViewTagPersonInfoScrollView ||
               view.tag == ATViewTagRecognizeSimultaneousTableView ||
               view.tag == ATViewTagUserCenterView ||
               view.tag == ATViewTagPersonInfoRelease ||
               view.tag == ATViewTagPersonInfoMatrix ||
               view.tag == ATViewTagImageDetailView ||
               view.tag == ATViewTagImageDetailDescView){
                return NO ;
            }
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -- 开始、结束拖拽

- (void)dragBeginWithPoint:(CGPoint)pt{
    
}

- (void)dragingWithPoint:(CGPoint)pt{
    
}

- (void)dragEndWithPoint:(CGPoint)pt shouldHideView:(BOOL)hideView{
    
}

#pragma mark -- 视图显示/消失

- (void)viewWillAppear{
    
}

- (void)viewDidAppear{
    
}

- (void)viewWillDisappear{
    
}

- (void)viewDidDisappear{
}

#pragma mark -- 设置圆角

- (void)adjustCornerRadius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, UIDeviceScreenWidth, UIDeviceScreenHeight) byRoundingCorners:self.cornerEdge cornerRadii:CGSizeMake(self.contentViewCornerRadius, self.contentViewCornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, UIDeviceScreenWidth, UIDeviceScreenHeight);
    maskLayer.path = maskPath.CGPath;
    self.dragContentView.layer.mask = maskLayer;
}

#pragma mark -- @property setter

- (void)setContentViewCornerRadius:(CGFloat)contentViewCornerRadius{
    _contentViewCornerRadius = contentViewCornerRadius;
    [self adjustCornerRadius];
}

- (void)setCornerEdge:(UIRectCorner)cornerEdge{
    _cornerEdge = cornerEdge;
    [self adjustCornerRadius];
}

#pragma mark -- @property getter

- (UIView *)dragViewBg{
    if(!_dragViewBg){
        _dragViewBg = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
            view ;
        });
    }
    return _dragViewBg;
}

- (UIView *)dragContentView{
    if(!_dragContentView){
        _dragContentView = ({
            UIView *view = [[UIView alloc]init];
            view.clipsToBounds = YES ;
            view.backgroundColor = [UIColor whiteColor];
            view ;
        });
    }
    return _dragContentView;
}

- (UIPanGestureRecognizer *)panRecognizer{
    if(!_panRecognizer){
        _panRecognizer = ({
            UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
            recognizer.delegate = self ;
            recognizer;
        });
    }
    return _panRecognizer;
}

@end

