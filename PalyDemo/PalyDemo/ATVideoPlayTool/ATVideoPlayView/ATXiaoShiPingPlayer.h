//
//  ATXiaoShiPingPlayer.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATAVPlayer.h"

@protocol ATXiaoShiPingPlayerDelegate <NSObject>
- (void)videoDidPlaying;
@end


@interface ATXiaoShiPingPlayer : UIView
@property(nonatomic,weak)id<ATXiaoShiPingPlayerDelegate>delegate;
@property(nonatomic,assign)ATNetworkType netType;
@property(nonatomic)NSString *playUrl;
@property(nonatomic)NSString *corverUrl;
@property(nonatomic)UIImage *corverImage;
- (void)destoryVideoPlayer;
- (void)startPlayVideo;
- (void)pause;
- (void)resume;
@end
