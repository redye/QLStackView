//
//  ViewController.m
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "ViewController.h"
#import "QLStackView.h"
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) QLStackView *stackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // {hc[imageView(width:50,height:50)]}
    // {hc[{hc[imageView(width:50,height:50)][button(width:100,height:30)]}]}
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor blueColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *objects = @{
                              @"imageView": imageView,
                              @"imageView2": [UIImageView new],
                              @"button": button,
                              @"button2": button2
                              };
    
    
    __weak typeof(self) weakSelf = self;
    NSString *imageViews = @"{vl(spacing:10,extendWith:0)[(width:50,height:50,backgroundColor:#ff00ff)][(width:50,height:50,backgroundColor:#ffff00)][(width:50,height:50,backgroundColor:#ffff00,intrinsic:1)]}";
    NSString *imageViews2 = @"{ht(spacing:10,extendWith:0)[(width:50,height:50,backgroundColor:#ffff00)][(width:50,height:50,backgroundColor:#ffff00)][(width:50,height:50,backgroundColor:#ffff00)]}";
    NSString *formatString = [NSString stringWithFormat:@"{vc(spacing:20,extendWith:2)[%@][imageView(width:50,height:50)][(text:哈哈sdhfkasjdfjasdfasjdbfa哈哈,line:0,color:#ff00ff,backgroundColor:#00ff00,cornerRadius:2,padding:10)][(width:100,height:100,backgroundColor:#ff0000,button:<button>)]}", imageViews2];
    NSString *formatString2 = [NSString stringWithFormat:@"{hc(spacing:20,extendWith:-1)[%@][imageView2(width:50,height:50,backgroundColor:#ddddff)][(text:哈哈sdhfkasjdfjasdfasjdbfa哈哈,intrinsic:1,maxWidth:100,line:0,color:#ff00ff,backgroundColor:#00ff00,cornerRadius:8,padding:10)][(width:100,backgroundColor:#ff0000,button:<button2>)]}", imageViews];
    
    [QLStackView asyncParseFormatString:formatString
                                objects:[objects mutableCopy]
                      completionHandler:^(QLStackView * _Nonnull stackView) {
                          stackView.backgroundColor = [UIColor orangeColor];
                          [weakSelf.view addSubview:stackView];
                          [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                              make.centerX.equalTo(weakSelf.view.mas_centerX);
                              make.centerY.equalTo(weakSelf.view.mas_centerY).offset(100);
                          }];
                      }];
    
    [QLStackView asyncParseFormatString:formatString2
                                objects:objects
                      completionHandler:^(QLStackView * _Nonnull stackView) {
                          weakSelf.stackView = stackView;
                          stackView.backgroundColor = [UIColor grayColor];
                          [weakSelf.view addSubview:stackView];
                          [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                              make.top.mas_equalTo(80);
                              make.left.mas_equalTo(0);
                              make.right.mas_equalTo(weakSelf.view.mas_right);
                              make.height.mas_equalTo(200);
                          }];
                      }];
    
}

- (void)buttonClick {
    NSLog(@"button click");
}


@end
