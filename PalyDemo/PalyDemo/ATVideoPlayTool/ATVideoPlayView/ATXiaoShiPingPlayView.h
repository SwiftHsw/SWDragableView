//
//  ATXiaoShiPingPlayView.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ATDragableNavBaseView.h"
#import "ATNewsBaseInfo.h"

@protocol ATXiaoShiPingPlayViewDelegate <NSObject>
- (void)scrollToIndex:(NSInteger)index callBack:(void(^)(CGRect oriFrame,UIImage *oriImage))callback;
@end



@interface ATXiaoShiPingPlayView : ATDragableNavBaseView
@property(nonatomic,weak)id<ATXiaoShiPingPlayViewDelegate>delegate;
//用于退出播放视图时的动画
@property(nonatomic,assign)CGRect oriFrame;
@property(nonatomic,weak)UIView *oriView;
@property(nonatomic,weak)UIImage *oriImage;
//自由拖拽图片结束时的相片隐藏动画
@property(nonatomic,copy)void(^hideImageAnimate)(UIImage *image,CGRect fromFrame,CGRect toFrame);
//上下左右拖动视图时，恢复相片在原视图中的透明度
@property(nonatomic,copy)void(^alphaViewIfNeed)(BOOL shouldAlphaView);

//id * 视频数据

- (instancetype)initWithNewsBaseInfo:(ATNewsBaseInfo *)newsInfo
                          videoArray:(NSArray *)videoArray
                            selIndex:(NSInteger)selIndex;
@end
