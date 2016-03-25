//
//  CXPlayerFilm.m
//  CXPlayer
//
//  Created by c_xie on 16/3/25.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "CXPlayerFilm.h"

@implementation CXPlayerFilm

+ (instancetype)playerFilmWithThumbImage:(UIImage *)image actualTime:(CMTime)time
{
    CXPlayerFilm *film = [[self alloc] init];
    film.thumbImage = image;
    film.actualTime = time;
    return film;
}

@end
