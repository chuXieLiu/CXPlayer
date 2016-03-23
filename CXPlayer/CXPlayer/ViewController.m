//
//  ViewController.m
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

static const NSString * kPlayerItemStatusContex;

@interface ViewController ()

@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) AVPlayerLayer *playerLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *assetURL = [[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"];
    
    AVAsset *asset = [AVAsset assetWithURL:assetURL];
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:0
                    context:&kPlayerItemStatusContex];
    
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    _playerLayer = playerLayer;
    
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    playerLayer.frame = self.view.layer.bounds;
    
    [self.view.layer addSublayer:playerLayer];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _playerLayer.frame = self.view.layer.bounds;
}


- (void)dealloc
{
    [self removeObserver:_player.currentItem forKeyPath:@"status" context:&kPlayerItemStatusContex];
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == &kPlayerItemStatusContex) {
        AVPlayerItem *playerItem = object;
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [_player play];
        }
    }
}








@end
