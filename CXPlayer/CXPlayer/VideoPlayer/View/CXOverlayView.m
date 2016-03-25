//
//  CXOverlayView.m
//  CXPlayer
//
//  Created by c_xie on 16/3/23.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "CXOverlayView.h"
#import "UIView+Extension.h"
#import "NSTimer+Extension.h"
#import "CXFilmstripView.h"
#import "CXPlayerFilm.h"
#import "CXPlayerConst.h"

// 导航条和工具条自定隐藏时间
static const NSTimeInterval kCXShowBarTimerInterval = 3.0f;

@interface CXOverlayView ()
<
    CXFilmstripViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UIView *toolBar;

@property (weak, nonatomic) IBOutlet UIButton *showFilmstripButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *curretnTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UISlider *playingSlider;


@property (weak, nonatomic) IBOutlet UIView *scheduleTimeView;

@property (weak, nonatomic) IBOutlet UILabel *scheduleTimeLabel;

@property (nonatomic,weak) CXFilmstripView *filmstripView;

@property (nonatomic,strong) NSTimer *timer;


@end

@implementation CXOverlayView

#pragma mark - init

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    _scheduleTimeView.hidden = YES;
    _showFilmstripButton.enabled = NO;
    
    _playingSlider.value = 0.f;
    _playingSlider.minimumValue = 0.f;
    [_playingSlider setThumbImage:[UIImage imageNamed:@"knob"]
                         forState:UIControlStateNormal];
    [_playingSlider setThumbImage:[UIImage imageNamed:@"knob_highlighted"]
                         forState:UIControlStateHighlighted];
    
    [_playingSlider addTarget:self action:@selector(sliderChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_playingSlider addTarget:self action:@selector(touchDownSlider:) forControlEvents:UIControlEventTouchDown];
    [_playingSlider addTarget:self action:@selector(touchUpInsideSlider:) forControlEvents:UIControlEventTouchUpInside];
    
    [self beginTimer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    BOOL isOnTopbar = CGRectContainsPoint(_topBar.frame, touchPoint);
    BOOL isOnToolBar = CGRectContainsPoint(_toolBar.frame, touchPoint);
    BOOL isShowing = [self topBarAndToolBarIsShowing];   // 是否显示
    if (!isOnTopbar && !isOnToolBar) {   // 手指不在topBar和toolBar上
        if (isShowing) {    // 隐藏
            if ([self filmstripViewIsShowing]) {
                [self hidenFilmstripViewBlock:^{
                    [self hidenTopBarAndToolBar];
                }];
            } else {
                [self hidenTopBarAndToolBar];
            }
        } else {            // 显示
            [self showTopBarAndToolBar];
        }
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_filmstripView) {   // 可视进度条
        _filmstripView.size = CGSizeMake(self.width, kCXFilmstripViewHeight);
        if (![self filmstripViewIsShowing]) {    // 正隐藏
            _filmstripView.origin = CGPointMake(0, -self.height);
        } else {    // 正显示
            _filmstripView.origin = CGPointMake(0, _topBar.height);
        }
    }
    
    if ([self topBarAndToolBarIsShowing]) {
        [self beginTimer];
    } else {
        [self endTimer];
    }
}



#pragma mark - CXTransport

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title ? title : @"Video Player";
}


- (void)setCurrentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration
{
    NSInteger interval = ceilf(time);// 向上取整
    NSTimeInterval remainTime = duration - time;
    _curretnTimeLabel.text = [self formatTime:interval];
    _totalTimeLabel.text = [self formatTime:remainTime];
    _playingSlider.maximumValue = duration;
    _playingSlider.value = time;
}

- (void)beginTransport
{
    _playButton.selected = YES;
}

- (void)playComplete
{
    _playingSlider.value = 0.f;
    _playButton.selected = NO;
}

- (void)setFilmstrip:(NSArray *)filmstrips
{
    CXFilmstripView *filmstripView = [CXFilmstripView filmstripViewWithFilms:filmstrips];
    [self insertSubview:filmstripView belowSubview:_topBar];
    _filmstripView = filmstripView;
    _filmstripView.delegate = self;
    _filmstripView.height = kCXFilmstripViewHeight;
    _filmstripView.width = self.width;
    _filmstripView.top = - _topBar.height;
    _filmstripView.left = 0;
    _showFilmstripButton.enabled = YES;
}

#pragma mark - CXFilmstripViewDelegate

- (void)filmstripViewWillBeginDragging:(CXFilmstripView *)filmstripView
{
    [self endTimer];
}

- (void)filmstripViewWillEndDragging:(CXFilmstripView *)filmstripView
{
    [self beginTimer];
}

- (void)filmstripView:(CXFilmstripView *)filmstripView didSelectedItem:(CXPlayerFilm *)film
{
    [_delete jumpToTime:film.actualTime];
}


#pragma mark - target event

- (IBAction)close:(UIButton *)sender {
    [self endTimer];
    [_delete close];
}


- (IBAction)show:(UIButton *)sender {
    if (![self filmstripViewIsShowing]) {
        [self showFilmstripViewBlock:nil];
    } else {
        [self hidenFilmstripViewBlock:nil];
    }
}

- (IBAction)play:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (_delete) {
        if (sender.isSelected) {
            [_delete play];
        } else {
            [_delete pause];
        }
    }
}

#pragma mark -UISlider 响应事件

- (void)touchDownSlider:(UISlider *)sender
{
    // 开始触摸滚动条，显示提示时间
    [self endTimer];
    _scheduleTimeView.hidden = NO;
    _scheduleTimeView.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        _scheduleTimeView.alpha = 1.0f;
    } completion:nil];
    [_delete scheduleDidBegin];
}

- (void)sliderChangeValue:(UISlider *)sender
{
    _scheduleTimeView.hidden = NO;
    CGRect trackRect = [_playingSlider convertRect:_playingSlider.bounds toView:self];
    CGRect thumbRect = [_playingSlider thumbRectForBounds:_playingSlider.bounds trackRect:trackRect value:sender.value];
    
    _scheduleTimeView.centerX = thumbRect.origin.x + 15;    // 滑块的一半
    
    _scheduleTimeLabel.text = [self formatTime:sender.value];
    // 值改变
    [_delete scheduleToTime:sender.value];
}


- (void)touchUpInsideSlider:(UISlider *)sender
{
    // 结束触摸，隐藏提示时间
    [UIView animateWithDuration:0.3 animations:^{
        _scheduleTimeView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        _scheduleTimeView.alpha = 0.0f;
        _scheduleTimeView.hidden = YES;
    }];
    [_delete scheduleDidEnd];
    [self beginTimer];
    
}

#pragma mark - topBar和toolBar控制事件

- (void)showTopBarAndToolBar
{
    if ([self topBarAndToolBarIsShowing]) return;
    _showFilmstripButton.enabled = NO;
    [UIView animateWithDuration:0.35 animations:^{
        _topBar.top = 0;
        _toolBar.top = self.bounds.size.height - _toolBar.height;
    } completion:^(BOOL finished) {
        [self beginTimer];
        _showFilmstripButton.enabled = YES;
    }];
}

- (void)hidenTopBarAndToolBar
{
    [self endTimer];
    if (![self topBarAndToolBarIsShowing]) return;
    [UIView animateWithDuration:0.35 animations:^{
        _topBar.top = - _topBar.height;
        _toolBar.top = self.bounds.size.height;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - filmstripView控制事件

- (void)showFilmstripViewBlock:(void(^)())hidenCompleteBlock
{
    if ([self filmstripViewIsShowing]) {
        !hidenCompleteBlock ? : hidenCompleteBlock();
        return;
    }
    _showFilmstripButton.enabled = NO;
    [UIView animateWithDuration:0.35 animations:^{
        _filmstripView.top = _topBar.height;
    } completion:^(BOOL finished) {
        _showFilmstripButton.enabled = YES;
        [_showFilmstripButton setTitle:@"隐藏" forState:UIControlStateNormal];
        !hidenCompleteBlock ? : hidenCompleteBlock();
    }];
}

- (void)hidenFilmstripViewBlock:(void(^)())hidenCompleteBlock
{
    if (![self filmstripViewIsShowing]) {
        !hidenCompleteBlock ? : hidenCompleteBlock();
        return;
    }
    _showFilmstripButton.enabled = NO;
    [UIView animateWithDuration:0.35 animations:^{
        _filmstripView.top = - _filmstripView.height;
    } completion:^(BOOL finished) {
        _showFilmstripButton.enabled = YES;
        [_showFilmstripButton setTitle:@"显示" forState:UIControlStateNormal];
        !hidenCompleteBlock ? : hidenCompleteBlock();
    }];
}


#pragma mark - private method

- (NSString *)formatTime:(NSInteger)time
{
    NSInteger minutes = time / 60;
    NSInteger seconds = time % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd",minutes,seconds];
}

- (BOOL)topBarAndToolBarIsShowing
{
    return _topBar.top >= 0 ? YES : NO;
}

- (BOOL)filmstripViewIsShowing
{
    BOOL isShow = _filmstripView.top >= 0 ? YES : NO;
    return isShow;
}

#pragma mark - NSTimer 事件


- (void)beginTimer
{
    [self endTimer];
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:kCXShowBarTimerInterval
    fireBlock:^{
        [weakSelf hidenFilmstripViewBlock:^{
            [weakSelf hidenTopBarAndToolBar];
        }];
    }];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)endTimer
{
    [_timer invalidate];
    _timer = nil;
}




@end
