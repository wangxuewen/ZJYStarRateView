//
//  ViewController.m
//  ZJYStarRateView
//
//  Created by administrator on 2018/9/26.
//  Copyright © 2018年 xuewen.wang. All rights reserved.
//

#import "ViewController.h"
#import "ZJYStarRateView.h"

#define StarSpace 10

@interface ViewController () <ZJYStarRateViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZJYStarRateView *starRateView = [[ZJYStarRateView alloc] initWithFrame:CGRectMake(20, 100, 200, 30)];
    
    starRateView.isAnimation = YES;
    starRateView.rateStyle = ZJYIncompleteStar;
    starRateView.tag = 1;
    starRateView.currentScore = 1.2;
    starRateView.starSpaceing = StarSpace;
    starRateView.delegate = self;
    [self.view addSubview:starRateView];
    
    ZJYStarRateView *starRateView2 = [[ZJYStarRateView alloc] initWithFrame:CGRectMake(20, 140, 200, 30) numberOfStars:5 rateStyle:ZJYHalfStar isAnination:YES delegate:self];
    starRateView2.tag = 2;
    starRateView2.starSpaceing = StarSpace;
    
    [self.view addSubview:starRateView2];
    
    ZJYStarRateView *starRateView3 = [[ZJYStarRateView alloc] initWithFrame:CGRectMake(20, 180, 200, 30) finish:^(CGFloat currentScore) {
        NSLog(@"3----  %f",currentScore);
    }];
    starRateView3.starSpaceing = StarSpace;
    
    [self.view addSubview:starRateView3];
    
    ZJYStarRateView *starRateView4 = [[ZJYStarRateView alloc] initWithFrame:CGRectMake(20, 220, 200, 30) numberOfStars:5 rateStyle:ZJYHalfStar isAnination:YES finish:^(CGFloat currentScore) {
        NSLog(@"4----  %f",currentScore);
        
    }];
    starRateView4.testVC = self;
    starRateView4.starSpaceing = StarSpace;
    
    [self.view addSubview:starRateView4];
}

#pragma mark -ZJYStarRateViewDelegate
-(void)starRateView:(ZJYStarRateView *)starRateView currentScore:(CGFloat)currentScore{
        NSLog(@"%ld----  %f",starRateView.tag,currentScore);
}

@end
