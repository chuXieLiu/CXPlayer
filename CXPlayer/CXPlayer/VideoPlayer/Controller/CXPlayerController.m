//
//  CXPlayerController.m
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "CXPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import "CXPlayerView.h"
#import "AVAsset+Extension.h"
#import "CXTransport.h"

static const NSString * kPlayerItemStatusContex;

static NSString * kAVPlayerItemPropertyStatus = @"status";


@interface CXPlayerController ()
<
    CXTransportDelegate
>

@property (nonatomic,strong) CXPlayerView *playerView;

@property (nonatomic,strong) AVAsset *asset;

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) AVPlayerItem *playerItem;

/**
 *  播放时间监听器
 */
@property (nonatomic,strong) id timeObserve;

@property (nonatomic,weak) id<CXTransport> transport;   // 指向CXOverlayView

@property (nonatomic,assign) float lastPlaybackRate;


@end

@implementation CXPlayerController

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        // 创建一个播放资源AVAsset对象
        _asset = [AVAsset assetWithURL:URL];
        [self prepareToPlay];
    }
    return self;
}


#pragma mark - CXTransportDelegate

- (void)play
{
    [_player play];
}

- (void)pause
{
    [_player pause];
}

- (void)stop
{
    // 设置为0意味着stop
    [_player setRate:0.f];
    [_transport playComplete];
}

- (void)close
{
    [self stop];
    [_playerView removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)jumpToTime:(NSTimeInterval)time
{
    CMTime interval = CMTimeMakeWithSeconds(time, NSEC_PER_SEC);
    [_player seekToTime:interval];
}

- (void)scheduleDidBegin
{
    _lastPlaybackRate = _player.rate;
    [_player pause];
    // 移除播放时间监听
    [_player removeTimeObserver:_timeObserve];
}

- (void)scheduleToTime:(NSTimeInterval)time
{
    // 结束上一次跳转请求
    [_playerItem cancelPendingSeeks];
    [_player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];


}

- (void)scheduleDidEnd
{
    // 进度改变结束，添加时间监听
    [self addPlayerItemTimeObserver];
    if (_lastPlaybackRate > 0.0f) {
       [_player play];
    }
}



- (void)prepareToPlay
{
    NSArray *assetKeys = @[
                           @"tracks",
                           @"duration",
                           @"commonMetadata",
                           @"availableMediaCharacteristicsWithMediaSelectionOptions"
                           ];
    
    // AVAsset对象只只包含静态信息，即只用来描述对象的静态状态，AVPlayerItem可以构建动态内容，在创建AVPlayerItem时自动载入AVAsset资源属性等信息
    // AVPlayerItem用来构建媒体资源动态动态视角的数据模型，并保持AVPlayer在播放资源时的状态
    _playerItem = [AVPlayerItem playerItemWithAsset:_asset automaticallyLoadedAssetKeys:assetKeys];
    
    // KVO监听播放状态
    [_playerItem addObserver:self
                  forKeyPath:kAVPlayerItemPropertyStatus
                     options:NSKeyValueObservingOptionNew
                     context:&kPlayerItemStatusContex];
    
    
    // AVPlayer是不可见组件，只对播放器进行播放暂停等控制
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    
    
    // 创建用于展示video的视图
    _playerView = [[CXPlayerView alloc] initWithPlayer:_player];
    _transport = _playerView.transport;
    [_transport setDelete:self];
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == &kPlayerItemStatusContex) {
        [_playerItem removeObserver:self forKeyPath:kAVPlayerItemPropertyStatus];
        if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            
            // 监听播放时间
            [self addPlayerItemTimeObserver];
            // 接受播放时间结束通知
            [self addPlayerItemTimeEndObserver];
            
            [self.transport setTitle:_asset.title];
            
            [self.transport beginTransport];
            
            [_player play];
        }
    }
}

- (void)addPlayerItemTimeEndObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemTimeEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemTimeEnd:(NSNotification *)note
{
    if ([NSThread isMainThread]) {
        // 播放结束
        [self.transport playComplete];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.transport playComplete];
        });
    }
}


- (void)addPlayerItemTimeObserver {
    
    __weak typeof(self) weakSelf = self;
    // 0.5秒间隔监听一次时间的变化
    _timeObserve =  [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                          queue:dispatch_get_main_queue()
     usingBlock:^(CMTime time) {
         // 播放时间
         NSTimeInterval playingTime = CMTimeGetSeconds(time);
         // 总时间
         NSTimeInterval duration = CMTimeGetSeconds(weakSelf.playerItem.duration);
         // 更新播放器时间UI
         [weakSelf.transport setCurrentTime:playingTime duration:duration];
         
     }];
}


- (UIView *)playingView
{
    return _playerView;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}





@end
