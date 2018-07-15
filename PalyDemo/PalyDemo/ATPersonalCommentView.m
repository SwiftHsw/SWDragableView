//
//  ATPersonalCommentView.m
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/14.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ATPersonalCommentView.h"

@implementation ATPersonalCommentView
- (instancetype)initWithCommentId:(NSString *)commentId{
    self = [super init];
    if(self){
//        _commentId = commentId ;
        [self initNavBar];
    }
    return self ;
}
#pragma mark -- 导航栏

- (void)initNavBar{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"button_close"] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"button_close"] imageWithAlpha:0.5] forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(startHide) forControlEvents:UIControlEventTouchUpInside];
    self.navTitleView.leftBtns = @[backButton];
}

@end
