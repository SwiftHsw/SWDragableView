//
//  ATAVPlayer.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ATMediaType) {
    ATMediaTypeNone = 0,
    ATMediaTypeAudio,
    ATMediaTypeVideo
};

typedef NS_ENUM(NSInteger, ATNetworkType) {
    ATNetworkTypeNet,//网络
    ATNetworkTypeLocal,//本地
};

@class ATAVPlayer;

typedef void(^progressCallback)(ATAVPlayer *player,float progress);//播放进度
typedef void(^seekCompleteCallback)(ATAVPlayer *player,CGFloat prePos,CGFloat curtPos);
typedef void(^willSeekToPosition)(ATAVPlayer *player,CGFloat curtPos,CGFloat toPos);
typedef void(^completeCallback)(ATAVPlayer *player);//播放完成
typedef void(^errorCallback)(ATAVPlayer *player,NSError *error);//播放错误
typedef void(^loadStatusCallback)(ATAVPlayer *player,AVPlayerStatus status);//流媒体加载状态
typedef void(^bufferPercentCallback)(ATAVPlayer *player,float bufferPercent);//流媒体缓冲百分比
typedef void(^bufferingCallback)(ATAVPlayer *player);//正在缓冲
typedef void(^bufferFinishCallback)(ATAVPlayer *player);//缓冲结束

@protocol ATAVPlayerDelegate <NSObject>
- (void)player:(ATAVPlayer *)player progress:(float)progress;
- (void)playerWillSeekToPosition:(ATAVPlayer *)player curtPos:(CGFloat )curtPos toPos:(CGFloat)toPos;
- (void)playerSeekComplete:(ATAVPlayer *)player prePos:(CGFloat)prePos curtPos:(CGFloat)curtPos;
- (void)playerComplete:(ATAVPlayer *)player;
- (void)playerBuffering:(ATAVPlayer *)player;
- (void)playerBufferFinish:(ATAVPlayer *)player;
- (void)player:(ATAVPlayer *)player playerError:(NSError *)error;
- (void)player:(ATAVPlayer *)player loadStatus:(AVPlayerStatus)status;
- (void)player:(ATAVPlayer *)player bufferPercent:(float)bufferPercent;
@end

@interface ATAVPlayer : NSObject
@property (nonatomic,weak)id<ATAVPlayerDelegate>delegate;
@property (nonatomic,assign,readonly)float totalBuffer;//中缓冲的长度
@property (nonatomic,assign,readonly)float currentPlayTime;//当前播放的时间
@property (nonatomic,assign,readonly)float totalTime;//总时长
@property (nonatomic,assign,readonly)float curtPosition;
@property (nonatomic,assign)float seekToPosition;//播放位置，0~1

@property (nonatomic,readonly) AVPlayerLayer *playerLayer;//视频渲染图层

@property (nonatomic,copy) progressCallback progressCallback;
@property (nonatomic,copy) completeCallback completeCallback;
@property (nonatomic,copy) errorCallback errorCallback;
@property (nonatomic,copy) loadStatusCallback loadStatusCallback;
@property (nonatomic,copy) bufferPercentCallback bufferPercentCallback;
@property (nonatomic,copy) willSeekToPosition willSeekToPosition;
@property (nonatomic,copy) seekCompleteCallback seekCompleteCallback;
@property (nonatomic,copy) bufferingCallback bufferingCallback;
@property (nonatomic,copy) bufferFinishCallback bufferFinishCallback;

@property (nonatomic,copy) NSString *mediaUrl;//连接地址
@property (nonatomic,assign) ATMediaType mediaType;
@property (nonatomic,assign) ATNetworkType netType;

+ (instancetype)sharedInstance;

- (void)initPlayInfoWithUrl:(NSString*)url
                  mediaType:(ATMediaType)type
                networkType:(ATNetworkType)netType;

- (void)initPlayInfoWithUrl:(NSString*)url
                  mediaType:(ATMediaType)type
                networkType:(ATNetworkType)netType
                    process:(progressCallback)progressCallback
                  compelete:(completeCallback)completeCallback
                 loadStatus:(loadStatusCallback)loadStatusCallback
              bufferPercent:(bufferPercentCallback)bufferPercentCallback
         willSeekToPosition:(willSeekToPosition)willSeekToPosition
               seekComplete:(seekCompleteCallback)seekCompleteCallback
                  buffering:(bufferingCallback)bufferingCallback
               bufferFinish:(bufferFinishCallback)bufferFinishCallback
                      error:(errorCallback)errorCallback;

#pragma mark -- 重置播放的回调

- (void)resetProcess:(progressCallback)progressCallback
           compelete:(completeCallback)completeCallback
          loadStatus:(loadStatusCallback)loadStatusCallback
       bufferPercent:(bufferPercentCallback)bufferPercentCallback
  willSeekToPosition:(willSeekToPosition)willSeekToPosition
        seekComplete:(seekCompleteCallback)seekCompleteCallback
           buffering:(bufferingCallback)bufferingCallback
        bufferFinish:(bufferFinishCallback)bufferFinishCallback
               error:(errorCallback)errorCallback;

#pragma mark -- 播放控制

- (void)play;
- (bool)isPlay;
- (void)pause;
- (bool)isPause;
- (bool)playFinish;
- (void)releasePlayer;//销毁播放器
@end
