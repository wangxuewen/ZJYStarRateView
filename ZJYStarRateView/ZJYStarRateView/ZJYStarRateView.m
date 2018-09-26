//
//  ZJYStarRateView.m
//  XHStarRateView
//
//  Created by 王学文 on 2017/9/6.
//  Copyright © 2017年 jxh. All rights reserved.
//

#import "ZJYStarRateView.h"

#define ForegroundStarImage @"b27_icon_star_yellow"
#define BackgroundStarImage @"b27_icon_star_gray"
#define StartWidth 20.

typedef void(^completeBlock)(CGFloat currentScore);

@interface ZJYStarRateView()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@property (nonatomic, assign) NSInteger numberOfStars;

@property (nonatomic,strong)completeBlock complete;

@property (nonatomic,assign)CGSize starSize; //星星的大小

@end

@implementation ZJYStarRateView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma mark - 代理方式
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _starSize = CGSizeMake(StartWidth, StartWidth);
        _starSpaceing = 10;
        _rateStyle = ZJYWholeStar;
        [self createStarView];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(ZJYRateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _starSize = CGSizeMake(StartWidth, StartWidth);
        _starSpaceing = 10;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _delegate = delegate;
        [self createStarView];
    }
    return self;
}

#pragma mark - block方式
-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = 5;
        _starSize = CGSizeMake(StartWidth, StartWidth);
        _starSpaceing = 10;
        _rateStyle = ZJYWholeStar;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(ZJYRateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish{
    if (self = [super initWithFrame:frame]) {
        _numberOfStars = numberOfStars;
        _starSize = CGSizeMake(StartWidth, StartWidth);
        _starSpaceing = 10;
        _rateStyle = rateStyle;
        _isAnimation = isAnimation;
        _complete = ^(CGFloat currentScore){
            finish(currentScore);
        };
        [self createStarView];
    }
    return self;
}

#pragma mark - private Method
-(void)createStarView{
    self.testVC.view.backgroundColor = [UIColor redColor];
 
    self.backgroundColor = [UIColor whiteColor];
    if ([self.subviews containsObject:self.foregroundStarView]) {
        [self.foregroundStarView removeFromSuperview];
    }
    
    if ([self.subviews containsObject:self.backgroundStarView]) {
        [self.backgroundStarView removeFromSuperview];
    }
    
    self.foregroundStarView = [self createStarViewWithImage:ForegroundStarImage];
    self.backgroundStarView = [self createStarViewWithImage:BackgroundStarImage];
    
    CGFloat foregroundStarViewWidth = 0.;
    if (_currentScore > 0) {
        foregroundStarViewWidth = _currentScore * StartWidth + (ceilf(_currentScore) - 1) * _starSpaceing;
    } else {
        foregroundStarViewWidth = 0;
    }
    
    self.foregroundStarView.frame = CGRectMake(0, 0, foregroundStarViewWidth, self.bounds.size.height);
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
}

- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * (StartWidth + _starSpaceing), 0, StartWidth, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    //    CGFloat realStarScore = offset / (((StartWidth + _starSpaceing) * self.numberOfStars - _starSpaceing) / self.numberOfStars);
    
    //一个星+一个间距为单位 向下取整
    CGFloat floorStarScore = floorf(offset / (StartWidth + _starSpaceing));
    
    //多于一个完整星（星宽+间距）外的宽度
    CGFloat excessWidth = offset - floorStarScore * (StartWidth + _starSpaceing);
    
    //真实星数目
    CGFloat realStarScore = (offset - floorStarScore * _starSpaceing) / StartWidth;
    ;
    
    if (excessWidth > StartWidth) { //多的是间距。向下取整
        realStarScore = floorf(realStarScore);
    }
    
    switch (_rateStyle) {
        case ZJYWholeStar:
        {
            self.currentScore = ceilf(realStarScore);
            break;
        }
        case ZJYHalfStar:
            self.currentScore = roundf(realStarScore)>=realStarScore ? ceilf(realStarScore):(ceilf(realStarScore)-0.5);
            break;
        case ZJYIncompleteStar:
            self.currentScore = realStarScore;
            break;
        default:
            break;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    __weak ZJYStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.isAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        
        CGFloat foregroundStarViewWidth = 0.;
        if (self->_currentScore > 0) {
            foregroundStarViewWidth = self->_currentScore * StartWidth + (ceilf(self->_currentScore) - 1) * self->_starSpaceing;
        } else {
            foregroundStarViewWidth = 0;
        }
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, foregroundStarViewWidth, weakSelf.bounds.size.height);
    }];
}

-(void)setStarSpaceing:(CGFloat)starSpaceing {
    if (_starSpaceing != starSpaceing) {
        _starSpaceing = starSpaceing;
        [self createStarView];
    }
}

-(void)setCurrentScore:(CGFloat)currentScore {
    if (_currentScore == currentScore) {
        return;
    }
    if (currentScore < 0) {
        _currentScore = 0;
    } else if (currentScore > _numberOfStars) {
        _currentScore = _numberOfStars;
    } else {
        _currentScore = currentScore;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:currentScore:)]) {
        [self.delegate starRateView:self currentScore:_currentScore];
    }
    
    if (self.complete) {
        _complete(_currentScore);
    }
    
    [self setNeedsLayout];
}



@end
