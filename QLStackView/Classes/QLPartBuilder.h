//
//  QLPartBuilder.h
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QLPartBuilder : NSObject

#pragma mark - 布局
/// padding
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat minWidth;

@property (nonatomic, assign) CGFloat maxWidth;

@property (nonatomic, assign) BOOL ignoreExtend;

#pragma mark - 样式
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

/// UILabel
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSUInteger numberOfLines;

/// UIImageView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *placeholderImage;

/// UIButton
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *view;

- (QLPartBuilder *(^)(CGFloat))paddingEqualTo;
- (QLPartBuilder *(^)(CGFloat))widthEqualTo;
- (QLPartBuilder *(^)(CGFloat))heightEqualTo;
- (QLPartBuilder *(^)(CGFloat))minWidthEqualTo;
- (QLPartBuilder *(^)(CGFloat))maxWidthEqualTo;

- (QLPartBuilder *(^)(NSString *))backgroundColorHexIs;
- (QLPartBuilder *(^)(UIColor *))backgroundColorIs;
- (QLPartBuilder *(^)(NSString *))borderColorHexIs;
- (QLPartBuilder *(^)(UIColor *))borderColorIs;
- (QLPartBuilder *(^)(NSString *))shadowColorHexIs;
- (QLPartBuilder *(^)(UIColor *))shadowColorIs;
- (QLPartBuilder *(^)(CGFloat))borderWidthEqualTo;
- (QLPartBuilder *(^)(CGFloat))cornerRadiusEqualTo;

- (QLPartBuilder *(^)(NSString *))textIs;
- (QLPartBuilder *(^)(NSString *))colorHexIs;
- (QLPartBuilder *(^)(UIColor *))colorIs;
- (QLPartBuilder *(^)(CGFloat))fontSizeEqualTo;
- (QLPartBuilder *(^)(UIFont *))fontIs;
- (QLPartBuilder *(^)(NSUInteger))numberOfLinesEqualTo;

- (QLPartBuilder *(^)(NSString *))imageNameIs;
- (QLPartBuilder *(^)(UIImage *))imageIs;
- (QLPartBuilder *(^)(NSString *))imageUrlIs;
- (QLPartBuilder *(^)(NSString *))placeholderImageNameIs;
- (QLPartBuilder *(^)(UIImage *))placeholderImageIs;

- (QLPartBuilder *(^)(UIButton *))buttonIs;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
