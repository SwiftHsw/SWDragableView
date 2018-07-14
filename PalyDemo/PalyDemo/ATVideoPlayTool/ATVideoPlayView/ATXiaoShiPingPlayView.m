//
//  ATXiaoShiPingPlayView.m
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ATXiaoShiPingPlayView.h"
#import "ATXiaoShiPingPlayer.h"
#import "YPDouYinLikeAnimation.h"

#import "ATNewsCommentView.h"



#define VideoCorverHorizPading 20
#define VideoItemWith (UIDeviceScreenWidth + VideoCorverHorizPading)
#define BottomBarHeight (ATSafeAreaBottomHeight + 44)
#define VideoCorverViewBaseTag 10000
@interface ATXiaoShiPingPlayView()<UIScrollViewDelegate,ATXiaoShiPingPlayerDelegate>{
    UIButton * _titleBtn;
}
//@property(nonatomic)ATAuthorInfoView *navAuthorView;
@property(nonatomic)UIView *bottomBar;
@property(nonatomic)UIScrollView *videoContainer;
@property(nonatomic)UIImageView *animateImageView;//进入播放视图时的动画视图

@property(nonatomic,strong)CAGradientLayer *topGradient;
@property(nonatomic,strong)CAGradientLayer *bottomGradient;

@property(nonatomic)ATNewsBaseInfo *newsInfo;
@property(nonatomic,copy)NSArray *videoArray;
@property(nonatomic,assign)NSInteger selIndex;
@property(nonatomic,assign)UIStatusBarStyle barStyle;
@property(nonatomic,assign)BOOL canHideStatusBar;

@end

@implementation ATXiaoShiPingPlayView

- (instancetype)initWithNewsBaseInfo:(ATNewsBaseInfo *)newsInfo
                          videoArray:(NSArray *)videoArray
                            selIndex:(NSInteger)selIndex{
    self = [super init];
    if(self){
        self.topSpace = 0 ;
        self.enableFreedomDrag = NO ;
        self.enableHorizonDrag = YES ;
        self.enableVerticalDrag = YES ;
        self.newsInfo = newsInfo; //数据传进来
        self.navContentOffsetY = 0 ;
        self.navTitleHeight = ATNavBarHeight ;
        self.videoArray = videoArray; //视频数据
        self.selIndex = selIndex ;
        self.barStyle = [[UIApplication sharedApplication]statusBarStyle];
    }
    return self ;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.topGradient.frame = CGRectMake(0, 0, self.width, 100);
    self.bottomGradient.frame = CGRectMake(0, self.height - 100, self.width, 100);
}
#pragma mark -- 视图的显示和消失

- (void)viewWillAppear{
    [super viewWillAppear];
    [self initUI];
    [self refreshData];
    [self startAnimate];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
#warning 双击666666
//    weakSelf(self);
//    [self addTapGestureWithBlock:^(UIView *gestureView) {
//
//
//
//
//    }];
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    
    [doubleTap setNumberOfTapsRequired:2];
     [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
     [self addGestureRecognizer:singleTap];
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap{
 
    YPDouYinLikeAnimation *ani = [YPDouYinLikeAnimation shareInstance];
    [ani createAnimationWithTap:tap];
    
}
- (void)handleSingleTap:(UITapGestureRecognizer *)tap{
    self.topGradient.hidden = !self.topGradient.hidden;
    self.bottomGradient.hidden = !self.bottomGradient.hidden;
    
    [[UIApplication sharedApplication]setStatusBarHidden:self.topGradient.hidden withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navTitleView.alpha = 1 - self.navTitleView.alpha;
           self.bottomBar.alpha = 1 - self.bottomBar.alpha;
        //导航栏 以及底部透明度
    }completion:^(BOOL finished) {
        
    }];
    
}

- (void)viewWillDisappear{
    [super viewWillDisappear];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:self.barStyle];
    
    //关闭视频
    ATXiaoShiPingPlayer *videoView = [self.videoContainer viewWithTag:VideoCorverViewBaseTag + self.selIndex ];
    [videoView destoryVideoPlayer];
    [videoView removeFromSuperview];
    
    if(self.alphaViewIfNeed){
        self.alphaViewIfNeed(NO);
    }
}

- (void)viewDidAppear{
    [super viewDidAppear];
}

#pragma mark -- 初始化UI

- (void)initUI{
    self.videoContainer.alpha = 0.0 ;
//    self.navAuthorView.alpha = 0.0 ;
    self.bottomBar.alpha = 0.0 ;
    self.dragContentView.backgroundColor = [UIColor clearColor];
    
    [self.dragContentView insertSubview:self.videoContainer belowSubview:self.navTitleView];
    [self.dragContentView insertSubview:self.bottomBar aboveSubview:self.videoContainer];
    
    [self.dragContentView.layer insertSublayer:self.topGradient below:self.navTitleView.layer];
    //插入view layer
    [self.dragContentView.layer insertSublayer:self.bottomGradient below:self.bottomBar.layer];
    
    [self initNavBar];
    
    [self.videoContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dragContentView);
        make.left.mas_equalTo(self.dragContentView);
        make.width.mas_equalTo(VideoItemWith);
        make.height.mas_equalTo(self.dragContentView);
    }];
    
    [self.bottomBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dragContentView);
        make.bottom.mas_equalTo(self.dragContentView);
        make.width.mas_equalTo(self.dragContentView).priority(998);
        make.height.mas_equalTo(BottomBarHeight);
    }];
    
    UIButton *titleBtn = [[UIButton alloc]init];
    [titleBtn setTitle:@"双击可赞,点我弹出评论视图" forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.bottomBar addSubview:titleBtn];
    
    [titleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomBar);
        make.left.mas_equalTo(self.bottomBar);
        make.width.mas_equalTo(UIDeviceScreenWidth);
        make.height.mas_equalTo(self.bottomBar);
    }];
    _titleBtn = titleBtn;
    [_titleBtn addTarget:self action:@selector(didCommentListLick) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutIfNeeded];
    
    [self initVideoPlayView];
}

- (void)initVideoPlayView{
    NSInteger index = 0 ;
    NSInteger count = self.videoArray.count;
#warning 赋值操作
   
    for(NSDictionary *dic  in self.videoArray){
        ATXiaoShiPingPlayer *views = [ATXiaoShiPingPlayer new];
        views.playUrl = dic[@"video_Url"];
        views.corverUrl = dic[@"corver_Url"];;
        views.delegate = self ;
        views.tag = VideoCorverViewBaseTag + index ;
        views.frame = CGRectMake(index * VideoItemWith, 0, UIDeviceScreenWidth, self.videoContainer.height);
        [self.videoContainer addSubview:views];
        index ++;
    }
    
    //横向滚动scrllView 的  ContentSize
    [self.videoContainer setContentSize:CGSizeMake(VideoItemWith * count, 0)];
    [self.videoContainer setContentOffset:CGPointMake(self.selIndex * VideoItemWith, 0) animated:NO];
    
    ATXiaoShiPingPlayer *view = [self.videoContainer viewWithTag:VideoCorverViewBaseTag + self.selIndex];
    [view setCorverImage:self.oriImage];//防止第一次播放时界面闪烁
    [view startPlayVideo];
}

#pragma mark -- 导航栏

- (void)initNavBar{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"leftbackicon_white_titlebar_24x24_"] forState:UIControlStateNormal];
    [backButton setImage:[[UIImage imageNamed:@"leftbackicon_white_titlebar_24x24_"] imageWithAlpha:0.5] forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(dismissVideoPlayView) forControlEvents:UIControlEventTouchUpInside];
    self.navTitleView.leftBtns = @[backButton];
    self.navTitleView.splitView.hidden = YES ;
    self.navTitleView.contentOffsetY = 5 ;
    
//    self.navAuthorView.showDetailLabel = NO ;
//    self.navAuthorView.headerSize = CGSizeMake(30, 30);
//    [self.navTitleView addSubview:self.navAuthorView];
//    [self.navAuthorView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.navTitleView);
//        make.centerY.mas_equalTo(self.navTitleView).mas_offset(5);
//        make.width.mas_equalTo(200);
//        make.height.mas_equalTo(44);
//    }];
}

#pragma mark -- 数据刷新

- (void)refreshData{
    NSString *headUrl = @"http://wx.qlogo.cn/mmopen/vi_32/48rJVeIib7jfQ8lAuullDjbwom2TIYFWXDl6TD4YEVvqDqz94l5BxU7UNHHT5Ko3y1HVfeiah7y7Ziah1SwvGTIzw/64";
    NSString *name = @"米粒儿";

//    self.navAuthorView.name = name;
//    self.navAuthorView.headUrl = headUrl;
//    self.navAuthorView.isConcern = NO ;
//    self.navAuthorView.userId = self.newsInfo.userInfo.user_id;
//
//    self.bottomBar.commentCount = [self.newsInfo.commentCount integerValue];
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.enableHorizonDrag = NO ;
    self.enableVerticalDrag = NO ;
    self.enableFreedomDrag = NO ;
    
    CGPoint offset = self.videoContainer.contentOffset;
    CGFloat progress = offset.x / (CGFloat)VideoItemWith;
    
    NSInteger nextIndex = self.selIndex + 1 ;
    if(nextIndex < self.videoArray.count){
        [[scrollView viewWithTag:VideoCorverViewBaseTag + nextIndex]setAlpha:fabs(progress-self.selIndex)];
    }
    
    [[scrollView viewWithTag:VideoCorverViewBaseTag + self.selIndex] setAlpha:1 - fabs((progress-self.selIndex))];
    
    NSInteger perIndex = self.selIndex - 1 ;
    if(perIndex >= 0){
        [[scrollView viewWithTag:VideoCorverViewBaseTag + perIndex] setAlpha:fabs((self.selIndex - progress))];
    }
}

//结束拉拽视图
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

//完全停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = self.videoContainer.contentOffset;
    NSInteger index = offset.x / VideoItemWith;
    if(index < 0 || index >= self.videoArray.count){
        return ;
    }
    
    self.enableHorizonDrag = (index == 0);
    self.enableVerticalDrag = YES ;
    self.enableFreedomDrag = NO ;
    
    if(self.selIndex != index){
        
        self.selIndex = index ;
        
        //一组数据的 model
//        ATSummaryContent *item = [self.videoArray safeObjectAtIndex:self.selIndex];
//        ATNewsBaseInfo *newsInfo = [ATNewsBaseInfo new];
//        newsInfo.title = item.title;
//        newsInfo.groupId = item.smallVideo.group_id;
//        newsInfo.itemId = item.smallVideo.item_id;
//        newsInfo.commentCount = item.smallVideo.action.comment_count;
//        newsInfo.userInfo = item.smallVideo.user.info;
//        newsInfo.catagory = @"hotsoon_video";
//        self.newsInfo = newsInfo;
        
        ATXiaoShiPingPlayer *view = [self.videoContainer viewWithTag:VideoCorverViewBaseTag + self.selIndex];
        [view startPlayVideo];
        
        [self refreshData];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(scrollToIndex:callBack:)]){
            [self.delegate scrollToIndex:self.selIndex callBack:^(CGRect oriFrame, UIImage *oriImage) {
                self.oriFrame = oriFrame;
                self.oriImage = oriImage;
            }];
        }
        
    }
    
    NSInteger nextIndex = self.selIndex + 1 ;
    if(nextIndex < self.videoArray.count){
        [[scrollView viewWithTag:VideoCorverViewBaseTag + nextIndex]setAlpha:1.0];
    }
    
    [[scrollView viewWithTag:VideoCorverViewBaseTag + self.selIndex] setAlpha:1.0];
    
    NSInteger perIndex = self.selIndex - 1 ;
    if(perIndex >= 0){
        [[scrollView viewWithTag:VideoCorverViewBaseTag + perIndex] setAlpha:1.0];
    }
}

#pragma mark -- 显示动画

- (void)startAnimate{
    CGFloat imageW = UIDeviceScreenWidth;
    CGFloat imageH = UIDeviceScreenHeight;
    CGRect frame = CGRectMake(0, 0, imageW, imageH);
    
    CGRect fromRect = [self.oriView convertRect:self.oriFrame toView:self.dragContentView];
    self.animateImageView = [YYAnimatedImageView new];
    self.animateImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.animateImageView.layer.masksToBounds = YES ;
    self.animateImageView.image = self.oriImage;
    self.animateImageView.frame = fromRect;
    [self.dragContentView addSubview:self.animateImageView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.animateImageView.frame = frame;
    }completion:^(BOOL finished) {
        self.videoContainer.alpha = 1.0 ;
//        self.navAuthorView.alpha = 1.0 ;
        self.bottomBar.alpha = 1.0 ;
        self.dragContentView.backgroundColor = [UIColor blackColor];
    }];
}

#pragma mark -- 关闭视频并退出界面

- (void)dismissVideoPlayView{
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:self.barStyle];
    
    ATXiaoShiPingPlayer *videoView = [self.videoContainer viewWithTag:VideoCorverViewBaseTag + self.selIndex];
    //关闭视频
    [videoView destoryVideoPlayer];
    [videoView setHidden:YES];
    
    CGRect frame = videoView.frame ;
    frame = [self.videoContainer convertRect:frame toView:self.dragContentView];
    frame = [self.dragContentView convertRect:frame toView:self.oriView];
    
    self.dragViewBg.alpha = 0;
    self.dragContentView.hidden = YES;
    if(self.hideImageAnimate){
        self.hideImageAnimate(self.oriImage,frame,self.oriFrame);
    }
}

#pragma mark -- ATXiaoShiPingPlayerDelegate

- (void)videoDidPlaying{
    [self.animateImageView removeFromSuperview];
}

#pragma mark -- ATAuthorInfoViewDelegate

- (void)setConcern:(BOOL)isConcern callback:(void (^)(BOOL))callback{
    if(callback){
        callback(YES);
    }
}

//- (void)clickedUserHeadWithUserId:(NSString *)userId{
//    @weakify(self);
//    ATPersonalInfoView *view = [[ATPersonalInfoView alloc]initWithUserId:userId willDissmissBlock:^{
//        @strongify(self);
//        self.canHideStatusBar = NO ;
//    }];
//    view.topSpace = 0 ;
//    view.navContentOffsetY = ATStatusBarHeight / 2.0 ;
//    view.navTitleHeight = ATNavBarHeight ;
//
//    [[UIApplication sharedApplication].keyWindow addSubview:view];
//    [view mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(UIDeviceScreenWidth, UIDeviceScreenHeight));
//    }];
//    [view pushIn];
//}

#pragma mark -- ATBottomBarDelegate

- (void)sendCommentWidthText:(NSString *)text{
    NSLog(@"%@",text);
}

- (void)favoriteNews:(BOOL)isFavorite callback:(void (^)(BOOL))callback{
    if(callback){
        callback(YES);
    }
}

- (void)shareNews{
    
}

- (void)showCommentView{
//    ATNewsCommentView *view = [[ATNewsCommentView alloc]initWithNewsBaseInfo:self.newsInfo];
//    view.topSpace = 200 ;
//    view.navContentOffsetY = 0 ;
//    view.navTitleHeight = 44 ;
//    view.contentViewCornerRadius = 10 ;
//    view.cornerEdge = UIRectCornerTopRight|UIRectCornerTopLeft;
//
//    [[UIApplication sharedApplication].keyWindow addSubview:view];
//    [view mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(UIDeviceScreenWidth, UIDeviceScreenHeight));
//    }];
//    [view startShow];
}

#pragma mark -- 开始、拖拽中、结束拖拽

- (void)dragBeginWithPoint:(CGPoint)pt{
    self.enableFreedomDrag = NO ;
    CGFloat offsetY = self.videoContainer.contentOffset.y;
    if(offsetY <=0 || offsetY >= self.videoContainer.contentSize.height){
        self.enableFreedomDrag = YES ;
    }
    
    if(self.alphaViewIfNeed){
        self.alphaViewIfNeed(self.enableFreedomDrag&&!self.defaultHideAnimateWhenDragFreedom);
    }
    self.navTitleView.hidden = YES;
  
    
}

- (void)dragingWithPoint:(CGPoint)pt{
    ATXiaoShiPingPlayer *videoView = [self.videoContainer viewWithTag:VideoCorverViewBaseTag + self.selIndex ];
    if(self.enableFreedomDrag){
        self.navTitleView.alpha = 0;
        self.bottomBar.alpha = 0;
        videoView.layer.transform = CATransform3DMakeScale(self.dragViewBg.alpha,self.dragViewBg.alpha,0);
    }
    
    self.topGradient.hidden = YES ;
    self.bottomGradient.hidden = YES ;
    self.videoContainer.scrollEnabled = NO ;
    self.dragContentView.backgroundColor = [UIColor clearColor];
 
}

- (void)dragEndWithPoint:(CGPoint)pt shouldHideView:(BOOL)hideView{
    if(self.enableFreedomDrag){
        if(!hideView){
            ATXiaoShiPingPlayer *videoView = [self.videoContainer viewWithTag:VideoCorverViewBaseTag + self.selIndex ];
            [UIView animateWithDuration:0.3 animations:^{
                videoView.layer.transform = CATransform3DIdentity;
            }completion:^(BOOL finished) {
                self.dragContentView.backgroundColor = [UIColor blackColor];
            }];
        }else{
            [self dismissVideoPlayView];
        }
    }else{
        if(self.alphaViewIfNeed){
            self.alphaViewIfNeed(!hideView);
        }
        self.dragContentView.backgroundColor = [UIColor blackColor];
    }
    
    self.enableFreedomDrag = NO ;
    self.enableHorizonDrag = (self.selIndex == 0) ;
    self.enableVerticalDrag = YES ;
    self.videoContainer.scrollEnabled = YES ;
    self.navTitleView.hidden = NO;
    self.bottomBar.hidden = NO;
}

#pragma mark -- @property getter

- (UIScrollView *)videoContainer{
    if(!_videoContainer){
        _videoContainer = ({
            UIScrollView *view = [UIScrollView new];
            view.showsVerticalScrollIndicator = NO ;
            view.showsHorizontalScrollIndicator = NO ;
            view.pagingEnabled = YES ;
            view.delegate = self ;
            view.bounces = NO ;
            view.layer.masksToBounds = NO ;
            view.backgroundColor = [UIColor clearColor];
            view.userInteractionEnabled = YES ;
            view ;
        });
    }
    return _videoContainer;
}

//- (ATAuthorInfoView *)navAuthorView{
//    if(!_navAuthorView){
//        _navAuthorView = ({
//            ATAuthorInfoView *view = [ATAuthorInfoView new];
//            view.delegate = self ;
//            view.detailLabel.textColor = [UIColor whiteColor];
//            view.nameLabel.textColor = [UIColor whiteColor];
//            view.backgroundColor = [UIColor clearColor];
//            view ;
//        });
//    }
//    return _navAuthorView;
//}
//
- (UIView *)bottomBar{
    if(!_bottomBar){
        _bottomBar = ({
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor whiteColor];

            view ;
        });
    }
    return _bottomBar;
}

- (CAGradientLayer *)topGradient{
    if(!_topGradient){
        _topGradient = [CAGradientLayer layer];
        _topGradient.colors = @[(__bridge id)[[UIColor blackColor]colorWithAlphaComponent:0.5].CGColor, (__bridge id)[UIColor clearColor].CGColor];
        _topGradient.startPoint = CGPointMake(0, 0);
        _topGradient.endPoint = CGPointMake(0.0, 1.0);
    }
    return _topGradient;
}

- (CAGradientLayer *)bottomGradient{
    if(!_bottomGradient){
        _bottomGradient = [CAGradientLayer layer];
        _bottomGradient.colors = @[(__bridge id)[[UIColor blackColor]colorWithAlphaComponent:0.5].CGColor, (__bridge id)[UIColor clearColor].CGColor];
        _bottomGradient.startPoint = CGPointMake(0, 1.0);
        _bottomGradient.endPoint = CGPointMake(0.0, 0.0);
    }
    return _bottomGradient;
}

#pragma mark - didCommentListLick
- (void)didCommentListLick{
    ATNewsBaseInfo  *model;
    
    ATNewsCommentView *view = [[ATNewsCommentView alloc]initWithNewsBaseInfo:model];
    view.topSpace = UIDeviceScreenHeight *0.4 ;
    view.navContentOffsetY = 0 ;
    view.navTitleHeight = 44 ;
    view.contentViewCornerRadius = 10 ;
    view.cornerEdge = UIRectCornerTopRight|UIRectCornerTopLeft;
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(UIDeviceScreenWidth, UIDeviceScreenHeight));
    }];
    [view startShow];
}

@end
