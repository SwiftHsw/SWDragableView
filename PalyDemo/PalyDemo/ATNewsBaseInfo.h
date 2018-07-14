//
//  ATNewsBaseInfo.h
//  PalyDemo
//
//  Created by 黄世文 on 2018/7/14.
//  Copyright © 2018年 mac_pro_s. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATNewsBaseInfo : NSObject
@property(nonatomic,copy)NSString *groupId;
@property(nonatomic,copy)NSString *itemId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *publicTime;
@property(nonatomic,copy)NSString *catagory;
@property(nonatomic,copy)NSString *articalUrl;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,copy)NSString *commentCount;
@property(nonatomic,copy)NSString *videoWatchCount;
@property(nonatomic,copy)NSString *diggCount;
@property(nonatomic,copy)NSString *buryCount;
@end
