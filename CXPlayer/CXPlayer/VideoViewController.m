//
//  VideoViewController.m
//  CXPlayer
//
//  Created by c_xie on 16/3/24.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "VideoViewController.h"
#import "CXPlayerController.h"

@interface VideoViewController ()

@property (nonatomic,strong) CXPlayerController *player;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *assetURL = [[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"];
    _player = [[CXPlayerController alloc] initWithURL:assetURL];
    [self.view addSubview:_player.playingView];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _player.playingView.frame = self.view.bounds;
    
    
}

@end
