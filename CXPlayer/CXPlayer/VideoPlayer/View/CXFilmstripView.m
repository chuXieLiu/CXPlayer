//
//  CXFilmstripView.m
//  CXPlayer
//
//  Created by c_xie on 16/3/25.
//  Copyright © 2016年 CX. All rights reserved.
//

#import "CXFilmstripView.h"
#import "CXPlayerFilm.h"
#import "CXPlayerConst.h"
#import "UIView+Extension.h"

static NSString * kCollectionViewCellIdentifier = @"kCollectionViewCellIdentifier";

@interface CXFilmstripCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) CXPlayerFilm *film;

@property (nonatomic,weak) UIImageView *imageView;

@end

@implementation CXFilmstripCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    _imageView = imageView;
    _imageView.frame = self.contentView.bounds;
}

- (void)setFilm:(CXPlayerFilm *)film
{
    _film = film;
    _imageView.image = film.thumbImage;
}

@end


@interface CXFilmstripView ()
<
    UICollectionViewDelegate,
    UICollectionViewDataSource
>

@property (nonatomic,weak) UICollectionView *collection;

@property (nonatomic,strong) NSArray *films;

@end

@implementation CXFilmstripView

+ (instancetype)filmstripViewWithFilms:(NSArray *)films
{
    CXFilmstripView *filmstripView = [[self alloc] init];
    filmstripView.films = films.copy;
    return filmstripView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        CGFloat itemHeight = kCXFilmstripViewHeight;
        CGFloat itemWidth = itemHeight * 16 / 9;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        collection.showsHorizontalScrollIndicator = NO;
        collection.showsVerticalScrollIndicator = NO;
        collection.delegate = self;
        collection.dataSource = self;
        [self addSubview:collection];
        _collection = collection;
        [_collection registerClass:[CXFilmstripCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
        _collection.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collection.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.films.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CXFilmstripCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.film = self.films[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(filmstripView:didSelectedItem:)]) {
        [_delegate filmstripView:self didSelectedItem:self.films[indexPath.row]];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(filmstripViewWillBeginDragging:)]) {
        [_delegate filmstripViewWillBeginDragging:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([_delegate respondsToSelector:@selector(filmstripViewWillEndDragging:)]) {
        [_delegate filmstripViewWillEndDragging:self];
    }
}



#pragma mark - lazy

- (NSArray *)films
{
    if (_films == nil) {
        _films = @[].copy;
    }
    return _films;
}


@end
