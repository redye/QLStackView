//
//  QLPartBuilder.m
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "QLPartBuilder.h"

@implementation QLPartBuilder

- (QLPartBuilder * _Nonnull (^)(BOOL))intrinsicEqualTo {
    return ^QLPartBuilder *(BOOL intrinsic) {
        self.intrinsic = intrinsic;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(CGFloat))paddingEqualTo {
    return ^QLPartBuilder *(CGFloat padding) {
        self.padding = padding;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(CGFloat))widthEqualTo {
    return ^QLPartBuilder *(CGFloat width) {
        self.width = width;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(CGFloat))heightEqualTo {
    return ^QLPartBuilder *(CGFloat height) {
        self.height = height;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(CGFloat))minWidthEqualTo {
    return ^QLPartBuilder *(CGFloat minWidth) {
        self.minWidth = minWidth;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(CGFloat))maxWidthEqualTo {
    return ^QLPartBuilder *(CGFloat maxWidth) {
        self.maxWidth = maxWidth;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(NSString * _Nonnull))backgroundColorHexIs {
    return ^QLPartBuilder *(NSString *hex) {
        self.backgroundColor = [QLPartBuilder colorWithHexString:hex];
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIColor * _Nonnull))backgroundColorIs {
    return ^QLPartBuilder *(UIColor *backgoundColor) {
        self.backgroundColor = backgoundColor;
        return self;
    };
}

- (QLPartBuilder *(^)(NSString *))borderColorHexIs {
    return ^QLPartBuilder *(NSString *hex) {
        self.borderColor = [QLPartBuilder colorWithHexString:hex];
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIColor * _Nonnull))borderColorIs {
    return ^QLPartBuilder *(UIColor *borderColor) {
        self.backgroundColor = borderColor;
        return self;
    };
}

- (QLPartBuilder *(^)(NSString *))shadowColorHexIs {
    return ^QLPartBuilder *(NSString *hex) {
        self.shadowColor = [QLPartBuilder colorWithHexString:hex];
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIColor * _Nonnull))shadowColorIs {
    return ^QLPartBuilder *(UIColor *shadowColor) {
        self.shadowColor = shadowColor;
        return self;
    };
}

- (QLPartBuilder *(^)(CGFloat))borderWidthEqualTo {
    return ^QLPartBuilder *(CGFloat borderWidth) {
        self.borderWidth = borderWidth;
        return self;
    };
}
- (QLPartBuilder *(^)(CGFloat))cornerRadiusEqualTo {
    return ^QLPartBuilder *(CGFloat cornerRadius) {
        self.cornerRadius = cornerRadius;
        return self;
    };
}

- (QLPartBuilder *(^)(NSString *))textIs {
    return ^QLPartBuilder *(NSString * text) {
        self.text = text;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIFont * _Nonnull))fontIs {
    return ^QLPartBuilder *(UIFont * font) {
        self.font = font;
        return self;
    };
}

- (QLPartBuilder *(^)(CGFloat))fontSizeEqualTo {
    return ^QLPartBuilder *(CGFloat fontSize) {
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}
- (QLPartBuilder * _Nonnull (^)(NSString * _Nonnull))colorHexIs {
    return ^QLPartBuilder *(NSString *hex) {
        self.color = [QLPartBuilder colorWithHexString:hex];
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIColor * _Nonnull))colorIs {
    return ^QLPartBuilder *(UIColor *color) {
        self.color = color;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(NSUInteger))numberOfLinesEqualTo {
    return ^QLPartBuilder *(NSUInteger numberOfLines) {
        self.numberOfLines = numberOfLines;
        return self;
    };
}

- (QLPartBuilder *(^)(NSString *))imageNameIs {
    return ^QLPartBuilder *(NSString *imageName) {
        self.image = [UIImage imageNamed:imageName];
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIImage * _Nonnull))imageIs {
    return ^QLPartBuilder *(UIImage *image) {
        self.image = image;
        return self;
    };
}

- (QLPartBuilder *(^)(NSString *))imageUrlIs {
    return ^QLPartBuilder *(NSString *imageUrl) {
        self.imageUrl = imageUrl;
        return self;
    };
}
- (QLPartBuilder *(^)(NSString *))placeholderImageNameIs {
    return ^QLPartBuilder *(NSString *placeholderImageName) {
        self.placeholderImage = [UIImage imageNamed:placeholderImageName];
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIImage * _Nonnull))placeholderImageIs {
    return ^QLPartBuilder *(UIImage *placeholderImage) {
        self.placeholderImage = placeholderImage;
        return self;
    };
}

- (QLPartBuilder * _Nonnull (^)(UIButton * _Nonnull))buttonIs {
    return ^QLPartBuilder *(UIButton *button) {
        self.button = button;
        return self;
    };
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *stringToConvert = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [QLPartBuilder colorWithRGBHex:hexNum];
}

@end
