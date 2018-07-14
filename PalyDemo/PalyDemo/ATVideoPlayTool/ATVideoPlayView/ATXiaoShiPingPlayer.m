//
//  ATXiaoShiPingPlayer.m
//  ATToydayNews
//
//  Created by finger on 2017/10/15.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "ATXiaoShiPingPlayer.h"

@interface ATXiaoShiPingPlayer ()
@property(nonatomic)UIImageView *corverView;//视频封面
@end

@implementation ATXiaoShiPingPlayer

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self ;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [ATAVPlayer sharedInstance].playerLayer.frame = self.bounds;
}

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark -- 初始化UI

- (void)setupUI{
    [self addSubview:self.corverView];
    [self.corverView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark -- 视频播放

- (void)startPlayVideo{
    
    [self destoryVideoPlayer];
    
    NSLog(@"加载中...");
    
    weakSelf(self);
    [[ATAVPlayer sharedInstance]initPlayInfoWithUrl:self.playUrl
                                          mediaType:ATMediaTypeVideo
                                        networkType:self.netType
                                            process:^(ATAVPlayer *player,float progress)
     {
     }compelete:^(ATAVPlayer *player){
         NSLog(@"compelete");
          NSLog(@"加载中成功,关闭加载动画");
         
         [[ATAVPlayer sharedInstance].playerLayer removeFromSuperlayer];
         [[ATAVPlayer sharedInstance] releasePlayer];
         [weakSelf startPlayVideo];
     } loadStatus:^(ATAVPlayer *player, AVPlayerStatus status) {
         NSLog(@"AVPlayerStatus status:%ld",status);
         
         if(self.delegate && [self.delegate respondsToSelector:@selector(videoDidPlaying)]){
             [self.delegate videoDidPlaying];
         }
     } bufferPercent:^(ATAVPlayer *player, float bufferPercent) {
         NSLog(@"bufferPercent percent:%f",bufferPercent);
     } willSeekToPosition:^(ATAVPlayer *player,CGFloat curtPos,CGFloat toPos) {
         NSLog(@"willSeekToPosition");
     } seekComplete:^(ATAVPlayer *player,CGFloat prePos,CGFloat curtPos) {
     } buffering:^(ATAVPlayer *player) {
         NSLog(@"加载中");
     } bufferFinish:^(ATAVPlayer *player) {
    NSLog(@"加载中成功,关闭加载动画");
     } error:^(ATAVPlayer *player, NSError *error) {
       NSLog(@"加载中成功,关闭加载动画");
     }];
    
    [ATAVPlayer sharedInstance].playerLayer.frame = self.bounds;
    [self.layer insertSublayer:[ATAVPlayer sharedInstance].playerLayer above:self.corverView.layer];
    [[ATAVPlayer sharedInstance]play];
}

#pragma mark -- 播放控制

- (void)pause{
    [[ATAVPlayer sharedInstance]pause];
}

- (void)resume{
    if(![ATAVPlayer sharedInstance].playerLayer.superlayer){
        [self startPlayVideo];
    }else{
        [[ATAVPlayer sharedInstance]play];
    }
}

#pragma mark -- 销毁视频播放器

- (void)destoryVideoPlayer{
    [[ATAVPlayer sharedInstance]pause];
    [[ATAVPlayer sharedInstance]releasePlayer];
}

#pragma mark -- @property setter

- (void)setPlayUrl:(NSString *)playUrl{
    if(playUrl == nil){
        _playUrl = @"";
    }else{
        _playUrl = playUrl;
    }
}

- (void)setCorverUrl:(NSString *)corverUrl{
    if(corverUrl == nil){
        corverUrl = @"";
    }
    [self.corverView sd_setImageWithURL:[NSURL URLWithString:corverUrl] placeholderImage:self.corverImage];
}

- (void)setCorverImage:(UIImage *)corverImage{
    self.corverView.image = corverImage;
}

- (UIImage *)corverImage{
    return self.corverView.image;
}

#pragma mark -- @property getter

- (UIImageView *)corverView{
    if(!_corverView){
        _corverView = ({
            UIImageView *view = [UIImageView new];
            view.userInteractionEnabled = NO ;
            view.contentMode = UIViewContentModeScaleAspectFit;
            view.layer.masksToBounds = YES ;
            view ;
        });
    }
    return _corverView;
}

@end

