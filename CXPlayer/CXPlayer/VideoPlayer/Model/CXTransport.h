//
//  CXTransport.h
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


/**
 *  关联播放暂停业务
 */
@protocol CXTransportDelegate <NSObject>

- (void)play;
- (void)pause;
- (void)stop;

/**
 *  关闭播放器
 */
- (void)close;

/**
 *  跳到某个时间点播放
 *
 *  @param time
 */
- (void)jumpToTime:(NSTimeInterval)time;

/**
 *  开始改变进度
 */
- (void)scheduleDidBegin;

/**
 *  播放进度发生改变
 *
 *  @param time
 */
- (void)scheduleToTime:(NSTimeInterval)time;

/**
 *  进度改变结束
 */
- (void)scheduleDidEnd;



@end




/**
 *  关联UI视图更新
 */
@protocol CXTransport <NSObject>

/**
 *  使遵守CXTransport协议的对象可以调用CXTransportDelegate中的方法
 */
@property (nonatomic,weak) id<CXTransportDelegate> delete;


/**
 *  开始播放
 */
- (void)beginTransport;

/**
 *  播放完成
 */
- (void)playComplete;


/**
 *  设置video标题
 *
 *  @param title 标题
 */
- (void)setTitle:(NSString *)title;

/**
 *  设置播放时长与video总长
 *
 *  @param time     播放时长
 *  @param duration video总长
 */
- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration;






@end

