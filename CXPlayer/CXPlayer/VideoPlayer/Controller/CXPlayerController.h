//
//  CXPlayerController.h
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CXPlayerController : NSObject

/**
 *  播放video视图
 */
@property (nonatomic,strong,readonly) UIView *playingView;

- (instancetype)initWithURL:(NSURL *)URL;




@end
