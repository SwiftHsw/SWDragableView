//
//  ATNavTitleView.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import <UIKit/UIKit.h>

//可以自定义View
@interface ATNavTitleView : UIView
@property(nonatomic,copy)NSArray *leftBtns;
@property(nonatomic,copy)NSArray *rightBtns;
@property(nonatomic)UIView *titleView ;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,readonly)UILabel *titleLabel;
@property(nonatomic,readonly)UIView *splitView;

@property(nonatomic,assign)CGFloat contentOffsetY;

- (instancetype)initWithTitle:(NSString *)title
                     leftBtns:(NSArray *)leftBtns
                    rightBtns:(NSArray *)rightBtns;
@end
