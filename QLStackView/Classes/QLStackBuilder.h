//
//  QLStackBuilder.h
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QLPartView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QLStackAxis) {
    QLStackAxisHorizontal,
    QLStackAxisVertical
};

typedef NS_ENUM(NSInteger, QLStackAlignment) {
    QLStackAlignmentCenter,
    QLStackAlignmentLeft,
    QLStackAlignmentRight,
    QLStackAlignmentTop,
    QLStackAlignmentBottom
};

@class QLStackView;
typedef void(^ParsingFormatStringCompletionHandler)(QLStackView *stackView);

@interface QLStackBuilder : NSObject
/// 轴线方向，默认为水平方向
@property (nonatomic, assign) QLStackAxis axis;
/// 垂直于轴线方向的布局方式
@property (nonatomic, assign) QLStackAlignment alignment;
/// 每个子视图间的距离
@property (nonatomic, assign) CGFloat spacing;
/// 对象
@property (nonatomic, strong) NSDictionary<NSString *, UIView *> *objects;
/// 撑开 stackView 的序号，默认为 0，如果不需要子视图撑开，需要设置为一个小于0的值
@property (nonatomic, assign) NSInteger extendWith;

@property (nonatomic, strong) NSArray<__kindof QLPartView *> *arrangedSubviews;

@property (nonatomic, copy) ParsingFormatStringCompletionHandler completionHandler;

@end

NS_ASSUME_NONNULL_END
