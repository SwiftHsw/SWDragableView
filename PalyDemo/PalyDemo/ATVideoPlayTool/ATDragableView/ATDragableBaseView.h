//
//  ATDragableBaseView.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ATMoveDirection){
    ATMoveDirectionNone,
    ATMoveDirectionUp,
    ATMoveDirectionDown,
    ATMoveDirectionRight,
    ATMoveDirectionLeft
} ;
typedef NS_ENUM(NSInteger, ATShowViewType){
    ATShowViewTypeNone,
    ATShowViewTypePush,
    ATShowViewTypePopup,
} ;
typedef NS_ENUM(NSInteger,ATViewTag){
    ATViewTagPersonInfoScrollView = 100000 ,//他人信息(动态，文章等视图的父视图)scrollview的tag，主要用于解决手势冲突
    ATViewTagRecognizeSimultaneousTableView,//他人信息最外层tableview的tag，主要用于解决手势冲突
    ATViewTagPersonInfoDongTai ,//他人信息动态视图的uitableview的tag，主要用于解决手势冲突
    ATViewTagPersonInfoArtical ,//他人信息文章视图的uitableview的tag，主要用于解决手势冲突
    ATViewTagPersonInfoVideo ,//他人信息视频视图的uitableview的tag，主要用于解决手势冲突
    ATViewTagPersonInfoWenDa ,//他人信息问答视图的uitableview的tag，主要用于解决手势冲突
    ATViewTagPersonInfoRelease ,//他人信息发布厅视图的uitableview的tag，主要用于解决手势冲突
    ATViewTagPersonInfoMatrix ,//他人信息矩阵视图的uitableview的tag，主要用于解决手势冲突
    ATViewTagUserCenterView ,//个人中心的uitableview的tag，主要用于解决手势冲突
    ATViewTagImageDetailView ,//相片预览视图tag，主要用于解决手势冲突
    ATViewTagImageDetailDescView ,//相片描述视图tag，主要用于解决手势冲突
};
@interface ATDragableBaseView : UIView
@property(nonatomic,readonly)UIView *dragViewBg ;//用户设置整个视图的背景
@property(nonatomic,readonly)UIView *dragContentView ;//需要显示的视图都加到dragContentView里面

@property(nonatomic,assign)CGFloat topSpace ;//dragContentView的顶部距离屏幕上方的距离
@property(nonatomic,assign)CGFloat contentViewCornerRadius;//dragContentView的圆角
@property(nonatomic,assign)UIRectCorner cornerEdge;//设定dragContentView的哪些边需要圆角
@property(nonatomic,assign,readonly)ATMoveDirection dragDirection;//拖动的方向
@property(nonatomic)BOOL enableHorizonDrag;//是否允许水平拖拽，默认为YES
@property(nonatomic)BOOL enableVerticalDrag;//是否允许垂直拖拽，默认为YES
@property(nonatomic)BOOL enableFreedomDrag;//允许自由拖拽,默认为NO,设为YES，则enableHorizonDrag、enableVerticalDrag自动失效
@property(nonatomic)BOOL defaultHideAnimateWhenDragFreedom;//自由拖拽时，是否使用默认的隐藏动画，默认为YES
@property(nonatomic)ATShowViewType showViewType;//pop push

#pragma mark -- 显示与隐藏动画

- (void)startShow;
- (void)startHide;

- (void)popIn;
- (void)popOutToTop:(BOOL)toTop;
- (void)pushIn;
- (void)pushOutToRight:(BOOL)toRight;

#pragma mark -- 开始、拖拽中、结束拖拽

- (void)dragBeginWithPoint:(CGPoint)pt;
- (void)dragingWithPoint:(CGPoint)pt;
- (void)dragEndWithPoint:(CGPoint)pt shouldHideView:(BOOL)hideView;

#pragma mark -- 视图显示/消失

- (void)viewWillAppear;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)viewDidDisappear;
@end
