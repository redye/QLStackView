//
//  QLPartView.m
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "QLPartView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface QLPartView ()

@end

@implementation QLPartView

+ (QLPartView *)createView:(void (^)(QLPartBuilder * _Nonnull))partBuilder {
    QLPartView *partView = [[QLPartView alloc] init];
    partView.builder = [[QLPartBuilder alloc] init];
    partBuilder(partView.builder);
    [partView buildPartView];
    return partView;
}

- (void)buildPartView {
    if (self.builder.image || self.builder.imageUrl) {
        UIImageView *imageView = [self buildImageView];
        if (self.builder.imageUrl) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.builder.imageUrl]
                         placeholderImage:self.builder.placeholderImage];
        } else {
            imageView.image = self.builder.image;
        }
    } else if (self.builder.text && self.builder.text.length > 0) {
        UILabel *label = [self buildLabel];
        label.text = self.builder.text;
        label.font = self.builder.font;
        label.textColor = self.builder.color;
        label.numberOfLines = self.builder.numberOfLines;
    }
    
    if (!self.builder.view) {
        self.builder.view = [[UIView alloc] init];
    }
    
    
    self.builder.backgroundColor ? self.builder.view.layer.backgroundColor = self.builder.backgroundColor.CGColor : nil;
    self.builder.shadowColor ? self.builder.view.layer.shadowColor = self.builder.shadowColor.CGColor : nil;
    self.builder.borderColor ? self.builder.view.layer.borderColor = self.builder.borderColor.CGColor : nil;
    if (self.builder.borderWidth > 0) {
        self.builder.view.layer.borderWidth = self.builder.borderWidth;
    }
    if (self.builder.cornerRadius > 0) {
        self.builder.view.layer.cornerRadius = self.builder.cornerRadius;
        self.builder.view.layer.masksToBounds = YES;
    }
    
    if (self.builder.button) {
        [self.builder.view addSubview:self.builder.button];
        [self.builder.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.builder.view);
        }];
    }
}

- (UIImageView *)buildImageView {
    UIImageView *imageView = nil;
    if (self.builder.view) {
        if ([self.builder.view isKindOfClass:[UIImageView class]]) {
            imageView = (UIImageView *)self.builder.view;
        }
    } else {
        imageView = [[UIImageView alloc] init];
        self.builder.view = imageView;
    }
    return imageView;
}

- (UILabel *)buildLabel {
    UILabel *label = nil;
    if (self.builder.view) {
        if ([self.builder.view isKindOfClass:[UILabel class]]) {
            label = (UILabel *)self.builder.view;
        }
    } else {
        label = [[UILabel alloc] init];
        self.builder.view = label;
    }
    return label;
}

@end
