//
//  ATImageZoomView.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATImageZoomView;
@protocol ATImageZoomViewDelegate <NSObject>
- (void)tapImageZoomView;
- (void)imageViewDidZoom:(ATImageZoomView *)zoomView;
@end

@interface ATImageZoomView : UIScrollView
@property(nonatomic,weak)id<ATImageZoomViewDelegate>zoomViewDelegate;
@property(nonatomic,readonly)YYAnimatedImageView *imageView;
@property(nonatomic,readwrite)UIImage *image;
@property(nonatomic,readwrite,copy)NSString *imageUrl;
- (void)showImageWithUrl:(NSString *)imageUrl placeHolder:(UIImage *)image;
- (void)clear;
@end
