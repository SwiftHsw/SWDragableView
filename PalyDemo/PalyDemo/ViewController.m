//
//  ViewController.m
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import "ViewController.h"

#import "ATXiaoShiPingPlayView.h"

@interface ViewController ()
<ATXiaoShiPingPlayViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didimageSshow:)];
    _coverImage.userInteractionEnabled = YES;
    _coverImage.clipsToBounds = YES;
    [_coverImage sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531566454780&di=9805d218d92a239ecb2d3ca7be562e95&imgtype=0&src=http%3A%2F%2Fscimg.jb51.net%2Fallimg%2F150619%2F14-150619154103533.jpg"]];
    
    [_coverImage addGestureRecognizer:tap];
}
//点击投影视频
- (void)didimageSshow:(UITapGestureRecognizer *)tap{
    UIImageView *imageV = (UIImageView *)tap.view;
    
    ATNewsBaseInfo *newsInfo = [ATNewsBaseInfo new];
    newsInfo.title = @"";
    newsInfo.groupId = @"6560573849614683396";
    newsInfo.itemId = @"";
    newsInfo.commentCount = @"";
//    newsInfo.userInfo = @"";
    newsInfo.catagory = @"hotsoon_video";
    /*
     @"https://static.smartisanos.cn/common/video/video-jgpro.mp4"
     views.playUrl = dic[@"video_Url"];
     views.corverUrl = dic[@"corver_Url"];;
     
     _douyinVideoStrings = @[
     @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
     @"https://www.w3schools.com/html/movie.mp4",
     @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
     @"https://media.w3.org/2010/05/sintel/trailer.mp4",
     @"http://mvvideo2.meitudata.com/576bc2fc91ef22121.mp4",
     @"http://mvvideo10.meitudata.com/5a92ee2fa975d9739_H264_3.mp4",
     @"http://mvvideo11.meitudata.com/5a44d13c362a23002_H264_11_5.mp4",
     @"http://mvvideo10.meitudata.com/572ff691113842657.mp4",
     @"https://api.tuwan.com/apps/Video/play?key=aHR0cHM6Ly92LnFxLmNvbS9pZnJhbWUvcGxheWVyLmh0bWw%2FdmlkPXUwNjk3MmtqNWV6JnRpbnk9MCZhdXRvPTA%3D&aid=381374",
     @"https://api.tuwan.com/apps/Video/play?key=aHR0cHM6Ly92LnFxLmNvbS9pZnJhbWUvcGxheWVyLmh0bWw%2FdmlkPWswNjk2enBud2xvJnRpbnk9MCZhdXRvPTA%3D&aid=381395",
     
     */
    
    
    NSArray *arr = @[
                    
                     @{@"video_Url":@"https://static.smartisanos.cn/common/video/video-jgpro.mp4",@"corver_Url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531566454780&di=9805d218d92a239ecb2d3ca7be562e95&imgtype=0&src=http%3A%2F%2Fscimg.jb51.net%2Fallimg%2F150619%2F14-150619154103533.jpg"},
                     @{@"video_Url":@"https://static.smartisanos.cn/common/video/video-jgpro.mp4",@"corver_Url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531566454780&di=7ce114de973bee98d83813a1b110857e&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fb21c8701a18b87d600047a170d0828381f30fd70.jpg"},
                      @{@"video_Url":@"https://static.smartisanos.cn/common/video/video-jgpro.mp4",@"corver_Url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531566454780&di=f5606862c469738b49833d54179636fa&imgtype=0&src=http%3A%2F%2Fscimg.jb51.net%2Fallimg%2F160218%2F14-16021P95632291.jpg"},
                      @{@"video_Url":@"https://static.smartisanos.cn/common/video/video-jgpro.mp4",@"corver_Url":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531566454780&di=62327f7563f16a305b6e9f15e1c8b727&imgtype=0&src=http%3A%2F%2Fk1.jsqq.net%2Fuploads%2Fallimg%2F160822%2F9_160822144144_1.jpg"},
                      @{@"video_Url":@"https://static.smartisanos.cn/common/video/video-jgpro.mp4",@"corver_Url":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3908859778,19620466&fm=200&gp=0.jpg"},
                     
                      @{@"video_Url":@"http://ugc-vliveochy.tc.qq.com/om.tc.qq.com/A7P018lSkDp9WtNk_MzrhMTztL9FMbWGRthOvCrlXQiQ/u06972kj5ez.m701.mp4?vkey=0F3313C56BB889B99D7DDD1A9922817AAB17AF677D8AA7365274DED93F88444028FDE876C39CEBDCF1BA4B179AB8A3AD55990FCA90642919E9520D94CFEBC8A89F9F43337F3EA2F32ADDFB557EFE6E8D8B25EAEDCF3D68F3BFCA27C221A96D4B2CF2501ED134E476&ocid=2551780780",@"corver_Url":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3908859778,19620466&fm=200&gp=0.jpg"},
                     
                        @{@"video_Url":@"http://mvvideo2.meitudata.com/576bc2fc91ef22121.mp4",@"corver_Url":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3908859778,19620466&fm=200&gp=0.jpg"},
                     
                       @{@"video_Url":@"http://mvvideo10.meitudata.com/5a92ee2fa975d9739_H264_3.mp4",@"corver_Url":@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3908859778,19620466&fm=200&gp=0.jpg"},
                     
                     
                     
      ];
    ATXiaoShiPingPlayView *browser = [[ATXiaoShiPingPlayView alloc]initWithNewsBaseInfo:newsInfo videoArray:arr selIndex:0];
    browser.delegate = self ;
    browser.topSpace = 0 ;
    browser.frame = CGRectMake(0, 0, UIDeviceScreenWidth, UIDeviceScreenHeight);
    browser.defaultHideAnimateWhenDragFreedom = NO ;
    browser.oriView = self.view; //父试图
    browser.oriFrame = imageV.frame;
    browser.oriImage = imageV.image;
    
//    weakSelf(browser);
    
    [browser setHideImageAnimate:^(UIImage *image,CGRect fromFrame,CGRect toFrame){
        
        UIImageView *imageView = [YYAnimatedImageView new];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = fromFrame ;
        imageView.layer.masksToBounds = YES ;
        [self.view addSubview:imageView];
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame = toFrame;
        }completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [browser removeFromSuperview];
//            for(ATXiaoShiPingCell *cell in self.collectView.visibleCells){
//                cell.contentBgView.alpha = 1.0 ;
//            }
            //找到当前Cell 并且透明掉
 
        }];
    }];
    
    [browser setAlphaViewIfNeed:^(BOOL alphaView){
//        上下左右拖动视图时，恢复相片在原视图中的透明度
//        ATXiaoShiPingCell *cell = (ATXiaoShiPingCell *)[self.collectView cellForItemAtIndexPath:self.selIndexPath];
//        cell.contentBgView.alpha = !alphaView ;

    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:browser];
    [browser viewWillAppear];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *   监听网络状态的变化
 */
+ (void)checkingNetworkResult:(void (^)(ATNetworkStatus))result {
    
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            if (result) result(ATNetworkStatusUnknown);
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            if (result) result(ATNetworkStatusNotReachable);
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            if (result) result(ATNetworkStatusReachableViaWWAN);
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            if (result) result(ATNetworkStatusReachableViaWiFi);
        }
    }];
}
@end
