//
//  CXPlayerFilm.h
//  CXPlayer
//
//  Created by c_xie on 16/3/25.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CXPlayerFilm : NSObject

@property (nonatomic,strong) UIImage *thumbImage;

@property (nonatomic,assign) CMTime actualTime;


+ (instancetype)playerFilmWithThumbImage:(UIImage *)image actualTime:(CMTime)time;

@end
