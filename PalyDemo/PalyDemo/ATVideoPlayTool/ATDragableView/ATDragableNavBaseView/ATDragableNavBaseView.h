//
//  ATDragableNavBaseView.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ATDragableBaseView.h"
#import <UIKit/UIKit.h>
#import "ATNavTitleView.h"

@interface ATDragableNavBaseView : ATDragableBaseView
@property(nonatomic,assign)BOOL hideNavTitleView;
@property(nonatomic,assign)CGFloat navTitleHeight;
@property(nonatomic,assign)CGFloat navContentOffsetY;
@property(nonatomic,readonly)ATNavTitleView *navTitleView;
@end
