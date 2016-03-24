//
//  CXPlayerView.h
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXTransport.h"

@class AVPlayer;

@interface CXPlayerView : UIView

- (instancetype)initWithPlayer:(AVPlayer *)player;


@property (nonatomic,strong) UIColor *backgroupColor;


@property (nonatomic,strong) id<CXTransport> transport;


@end
