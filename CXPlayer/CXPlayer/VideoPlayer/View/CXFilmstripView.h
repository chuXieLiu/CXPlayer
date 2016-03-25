//
//  CXFilmstripView.h
//  CXPlayer
//
//  Created by c_xie on 16/3/25.
//  Copyright © 2016年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CXPlayerFilm;
@class CXFilmstripView;

@protocol CXFilmstripViewDelegate <NSObject>

@optional
- (void)filmstripViewWillBeginDragging:(CXFilmstripView *)filmstripView;
- (void)filmstripViewWillEndDragging:(CXFilmstripView *)filmstripView;
- (void)filmstripView:(CXFilmstripView *)filmstripView didSelectedItem:(CXPlayerFilm *)film;

@end


@interface CXFilmstripView : UIView

+ (instancetype)filmstripViewWithFilms:(NSArray *)films;

@property (nonatomic,weak) id<CXFilmstripViewDelegate> delegate;

@end
