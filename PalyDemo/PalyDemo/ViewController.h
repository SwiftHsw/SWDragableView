//
//  ViewController.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/13.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ATNetworkStatus){
    ATNetworkStatusUnknown = -1,//未知状态
    ATNetworkStatusNotReachable = 0,//无网状态
    ATNetworkStatusReachableViaWWAN = 1,//手机网络
    ATNetworkStatusReachableViaWiFi = 2,//Wifi网络
};
@interface ViewController : UIViewController
/**网络状态*/
+ (void)checkingNetworkResult:(void(^)(ATNetworkStatus status))result;


@end

