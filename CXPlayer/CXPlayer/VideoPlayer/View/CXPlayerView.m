//
//  CXPlayerView.m
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "CXPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "CXOverlayView.h"
#import "UIView+Extension.h"

@interface CXPlayerView ()

@property (nonatomic,weak) CXOverlayView *overlayView;

@end

@implementation CXPlayerView

/**
 *  将该view的图层设置为AVPlayerLayer，AVPlayerLayer是真正用于展示video的视图
 *
 *  @return
 */
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer *)player
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _backgroupColor = [UIColor blackColor];
        self.backgroundColor = _backgroupColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [(AVPlayerLayer *)[self layer] setPlayer:player];
        
        _overlayView = [CXOverlayView viewFromXib];
        
        [self addSubview:_overlayView];
        [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _overlayView.frame = self.bounds;
}

- (id<CXTransport>)transport
{
    return _overlayView;
}

- (void)dealloc
{
    NSLog(@"xxxxxxx");
}

@end
