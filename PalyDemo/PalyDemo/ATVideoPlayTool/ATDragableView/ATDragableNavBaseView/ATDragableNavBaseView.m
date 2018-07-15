//
//  ATDragableNavBaseView.m
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ATDragableNavBaseView.h"

//
//  ATDragableNavBaseView.m
//  ATToydayNews
//
//  Created by finger on 2017/9/30.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "ATDragableNavBaseView.h"

@interface ATDragableNavBaseView ()
@property(nonatomic,readwrite)ATNavTitleView *navTitleView;
@end

@implementation ATDragableNavBaseView

- (instancetype)init{
    self = [super init];
    if(self){
        [self _navBaseViewSetupUI_];
    }
    return self ;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self _navBaseViewSetupUI_];
    }
    return self ;
}

#pragma mark -- 设置UI

- (void)_navBaseViewSetupUI_{
    self.topSpace = 0 ;
    _navContentOffsetY = ATStatusBarHeight / 2.0 ;
    _navTitleHeight = ATNavBarHeight ;
    
    [self.dragContentView addSubview:self.navTitleView];
    
    self.navTitleView.contentOffsetY = self.navContentOffsetY;
    [self.navTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dragContentView).priority(998);
        make.left.mas_equalTo(self.dragContentView).priority(998);
        make.width.mas_equalTo(self.dragContentView).priority(998);
        make.height.mas_equalTo(_navTitleHeight);
    }];
}

#pragma mark -- @property setter

- (void)setHideNavTitleView:(BOOL)hideNavTitleView{
    _hideNavTitleView = hideNavTitleView ;
    [self.navTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_hideNavTitleView ? 0 : self.navTitleHeight);
    }];
}

- (void)setNavTitleHeight:(CGFloat)navTitleHeight{
    _navTitleHeight = navTitleHeight ;
    [self.navTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_navTitleHeight);
    }];
}

- (void)setNavContentOffsetY:(CGFloat)navContentOffsetY{
    _navContentOffsetY = navContentOffsetY;
    self.navTitleView.contentOffsetY = navContentOffsetY;
}

#pragma mark -- @property getter

- (ATNavTitleView *)navTitleView{
    if(!_navTitleView){
        _navTitleView = ({
            ATNavTitleView *view = [ATNavTitleView new];
            view ;
        });
    }
    return _navTitleView;
}

@end

