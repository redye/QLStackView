//
//  QLStackView.m
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import "QLStackView.h"
#import "QLPartView.h"
#import "Masonry.h"

@interface QLStackView ()

@property (nonatomic, strong) QLStackBuilder *builder;
@property (nonatomic, copy) ParsingFormatStringCompletionHandler completionHandler;

@end

@implementation QLStackView

+ (QLStackView *)createView:(void (^)(QLStackBuilder * _Nonnull))stackBuilder {
    QLStackView *stackView = [[QLStackView alloc] init];
    stackView.builder = [[QLStackBuilder alloc] init];
    stackBuilder(stackView.builder);
    [stackView buildStackView];
    if (stackView.builder.completionHandler) {
        stackView.builder.completionHandler(stackView);
    }
    return stackView;
}

- (void)buildStackView {
    CGFloat spacing = self.builder.spacing;
    UIView *lastView = nil;
    if (self.builder.axis == QLStackAxisHorizontal) {
        for (NSInteger i = 0; i < self.builder.arrangedSubviews.count; i ++) {
            id x = [self.builder.arrangedSubviews objectAtIndex:i];
            UIView *view = nil;
            QLPartView *partView = nil;
            if ([x isKindOfClass:[QLPartView class]]) {
                partView = (QLPartView *)x;
                view = partView.builder.view;
            } else {
                view = (UIView *)x;
            }
            CGFloat padding = partView ? partView.builder.padding : 0;
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.mas_left);
                } else  {
                    make.left.equalTo(lastView.mas_right).offset(spacing);
                }
                if (partView.builder.width > 0) {
                    make.width.mas_equalTo(partView.builder.width);
                } else if (partView.builder.minWidth > 0) {
                    make.width.mas_greaterThanOrEqualTo(partView.builder.minWidth);
                } else if (partView.builder.maxWidth > 0) {
                    make.width.mas_lessThanOrEqualTo(partView.builder.maxWidth);
                }
                BOOL isHeight = NO;
                if (partView.builder.height > 0) {
                    make.height.mas_equalTo(partView.builder.height);
                    isHeight = YES;
                }
                BOOL needHeight = !isHeight && !partView.builder.intrinsic;
                if (self.builder.alignment == QLStackAlignmentTop) {
                    make.top.equalTo(self.mas_top).offset(padding);
                    needHeight ? make.bottom.equalTo(self.mas_bottom).offset(-padding) : nil;
                } else if (self.builder.alignment == QLStackAlignmentCenter) {
                    make.centerY.equalTo(self.mas_centerY);
                } else if (self.builder.alignment == QLStackAlignmentBottom) {
                    make.bottom.equalTo(self.mas_bottom).offset(-padding);
                    needHeight ? make.top.equalTo(self.mas_top).offset(padding) : nil;
                }
                if (i == self.builder.arrangedSubviews.count - 1 && self.builder.extendWith >= 0) {
                    make.right.equalTo(self.mas_right).offset(-padding);
                }
                if (i == self.builder.extendWith) {
                    make.top.equalTo(self.mas_top).offset(padding);
                    make.bottom.equalTo(self.mas_bottom).offset(-padding);
                }
            }];
            
            lastView = view;
        }
    } else {
        for (NSInteger i = 0; i < self.builder.arrangedSubviews.count; i ++) {
            id x = [self.builder.arrangedSubviews objectAtIndex:i];
            UIView *view = nil;
            QLPartView *partView = nil;
            if ([x isKindOfClass:[QLPartView class]]) {
                partView = (QLPartView *)x;
                view = partView.builder.view;
            } else {
                view = (UIView *)x;
            }
            CGFloat padding = partView ? partView.builder.padding : 0;
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.equalTo(self.mas_top);
                } else  {
                    make.top.equalTo(lastView.mas_bottom).offset(spacing);
                }
                BOOL isWidth = NO;
                if (partView.builder.width > 0) {
                    make.width.mas_equalTo(partView.builder.width);
                    isWidth = YES;
                } else if (partView.builder.minWidth > 0) {
                    make.width.mas_greaterThanOrEqualTo(partView.builder.minWidth);
                    isWidth = YES;
                } else if (partView.builder.maxWidth > 0) {
                    make.width.mas_lessThanOrEqualTo(partView.builder.maxWidth);
                    isWidth = YES;
                }
                if (partView.builder.height > 0) {
                    make.height.mas_equalTo(partView.builder.height);
                }
                BOOL needWidth = !isWidth && !partView.builder.intrinsic;
                if (self.builder.alignment == QLStackAlignmentLeft) {
                    make.left.equalTo(self.mas_left).offset(padding);
                    needWidth ? make.right.equalTo(self.mas_right).offset(-padding) : nil;
                } else if (self.builder.alignment == QLStackAlignmentCenter) {
                    make.centerX.equalTo(self.mas_centerX);
                } else if (self.builder.alignment == QLStackAlignmentRight) {
                    make.right.equalTo(self.mas_right).offset(-padding);
                    needWidth ? make.left.equalTo(self.mas_left).offset(padding) : nil;
                }
                if (i == self.builder.arrangedSubviews.count - 1 && self.builder.extendWith >= 0) {
                    make.bottom.equalTo(self.mas_bottom).offset(-padding);
                }
                if (i == self.builder.extendWith) {
                    make.left.equalTo(self.mas_left).offset(padding);
                    [make.right.equalTo(self.mas_right).offset(-padding) priorityLow];
                }
            }];
            
            lastView = view;
        }
    }
}

+ (void)asyncParseFormatString:(NSString *)formatString
                       objects:(NSDictionary *)objects
             completionHandler:(ParsingFormatStringCompletionHandler)completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self createViewWithFormatString:formatString
                                 objects:objects
                       completionHandler:completionHandler];
    });
}

/**
 * 解析规则：
 * {}表示组合视图
 * []表示零件视图
 * ()属性
 * <>对象
 */
+ (NSString *)regexFormatString:(NSString *)string patterns:(NSArray *)patterns {
    NSArray *escapeArray = @[@"{", @"}", @"[", @"]", @"(", @")"];
    for (NSString *pattern in patterns) {
        NSString *patternString = nil;
        if ([escapeArray containsObject:pattern]) {
            patternString = [NSString stringWithFormat:@"\\%@{1,}", pattern];
        } else {
            patternString = [NSString stringWithFormat:@"%@{1,}", pattern];
        }
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString
                                                                               options:0
                                                                                 error:nil];
        string = [regex stringByReplacingMatchesInString:string
                                                 options:0
                                                   range:NSMakeRange(0, string.length)
                                            withTemplate:pattern];
    }
    return string;
}

+ (void)createViewWithFormatString:(NSString *)formatString
                           objects:(NSDictionary *)objects
                 completionHandler:(ParsingFormatStringCompletionHandler)completionHandler {
    NSArray *operators = @[@"{", @"}", @"[", @"]", @"(", @")", @":", @",", @"<", @">"];
    formatString = [self regexFormatString:formatString patterns:operators];
    NSScanner *scanner = [NSScanner scannerWithString:formatString];
    scanner.charactersToBeSkipped = [NSCharacterSet whitespaceAndNewlineCharacterSet]; // 跳过换行和空白字符
    NSMutableArray *tokens = @[].mutableCopy;
    NSMutableCharacterSet *set = [NSMutableCharacterSet alphanumericCharacterSet];
    [set addCharactersInString:@"./|?!$%#-+_&：“”。，《》！"];
    while (!scanner.isAtEnd) {
        for (NSString *operator in operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:operator];
            }
            NSString *resultString = nil;
            [scanner scanCharactersFromSet:set intoString:&resultString];
            if (resultString) {
                [tokens addObject:resultString];
            }
        }
    }
//    NSLog(@"tokens ===> %@", tokens);
    if (tokens.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createViewWithTokens:tokens objects:objects completionHandler:completionHandler];
        });
    }
}

+ (QLStackView *)createViewWithTokens:(NSArray *)tokens
                     objects:(NSDictionary *)objects
           completionHandler:(ParsingFormatStringCompletionHandler)completionHandler {
    return [QLStackView createView:^(QLStackBuilder * _Nonnull builder) {
        if (completionHandler) {
            builder.completionHandler = completionHandler;
        }
        // 解析数组
        NSMutableArray *arrangedSubviews = @[].mutableCopy;
        for (NSInteger i = 0; i < tokens.count;) {
            NSString *element = [tokens objectAtIndex:i];
            if (i == 0) {
                if ([element isEqualToString:@"{"]) {
                    i ++;
                    continue;
                } else {
                    break;
                }
            }
            if (i == 1 && element.length == 2) {
                NSString *direction = [element substringToIndex:1];
                if ([direction isEqualToString:@"h"]) {
                    builder.axis = QLStackAxisHorizontal;
                } else if ([direction isEqualToString:@"v"]) {
                    builder.axis = QLStackAxisVertical;
                }
                // 垂直于轴线方向布局方式
                NSString *alignment = [element substringFromIndex:1];
                if ([alignment isEqualToString:@"c"]) {
                    builder.alignment = QLStackAlignmentCenter;
                } else if ([alignment isEqualToString:@"t"]) {
                    builder.alignment = QLStackAlignmentTop;
                } else if ([alignment isEqualToString:@"b"]) {
                    builder.alignment = QLStackAlignmentBottom;
                } else if ([alignment isEqualToString:@"l"]) {
                    builder.alignment = QLStackAlignmentLeft;
                } else if ([alignment isEqualToString:@"r"]) {
                    builder.alignment = QLStackAlignmentRight;
                }
                i ++;
                continue;
            }
            if (i == 2 && [element isEqualToString:@"("]) {
                // stackView 的属性
                NSArray *array = [self findMatchedWithArray:tokens startIndex:i leftToken:@"(" rightToken:@")"];
                [self parsePropertyWithArray:array builder:builder];
            }
            if ([element isEqualToString:@"["]) {
                // 子视图
                if (i + 1 < tokens.count) {
                    NSString *ele = [tokens objectAtIndex:i + 1];
                    if ([ele isEqualToString:@"{"]) {
                        NSArray *stackViewTokens = [self findMatchedWithArray:tokens startIndex:i + 1 leftToken:@"{" rightToken:@"}" includeToken:YES];
                        QLStackView *stackView = [self createViewWithTokens:stackViewTokens objects:objects completionHandler:nil];
                        [arrangedSubviews addObject:stackView];
                        i = i + stackViewTokens.count + 1;
                        continue;
                    }
                }
                NSArray *partViewtTokens = [self findMatchedWithArray:tokens startIndex:i leftToken:@"[" rightToken:@"]"];
                if (partViewtTokens.count > 0) {
                    QLPartView *partView = [self createPartViewWithTokens:partViewtTokens objects:objects];
                    [arrangedSubviews addObject:partView];
                }
            }
            i ++;
        }
        builder.arrangedSubviews = arrangedSubviews;
    }];
}

+ (void)parsePropertyWithArray:(NSArray *)array builder:(QLStackBuilder *)builder {
    // 按逗号切割数组
    NSArray *properties = [self propertiesWithArray:array seperator:@","];
    for (NSArray *property in properties) {
        if (property.count == 3) {
            NSString *key = [property objectAtIndex:0];
            NSString *value = [property objectAtIndex:2];
            if ([key isEqualToString:@"spacing"]) {
                builder.spacing = [value floatValue];
            } else if ([key isEqualToString:@"extendWith"]) {
                builder.extendWith = [value integerValue];
            }
        }
    }
}


+ (QLPartView *)createPartViewWithTokens:(NSArray<NSString *> *)tokens objects:(NSDictionary *)objects {
    return [QLPartView createView:^(QLPartBuilder * _Nonnull builder) {
        for (NSInteger i = 0; i < tokens.count; i ++) {
            NSString *ele = [tokens objectAtIndex:i];
            if ([ele isEqualToString:@"("]) {
                NSArray *properties = [self findMatchedWithArray:tokens startIndex:i leftToken:@"(" rightToken:@")"];
                [self parsePartViewPropertyWithArray:properties objects:objects builder:builder];
                break;
            } else {
                NSObject *obj = [objects objectForKey:ele];
                if ([obj isKindOfClass:[UIView class]]) {
                    builder.view = (UIView *)obj;
                }
            }
        }
    }];
}

+ (void)parsePartViewPropertyWithArray:(NSArray<NSString *> *)array
                               objects:(NSDictionary *)objects
                               builder:(QLPartBuilder *)builder {
    NSArray *properties = [self propertiesWithArray:array seperator:@","];
    for (NSArray *property in properties) {
        NSString *key = nil;
        NSString *value = nil;
        if (property.count == 5 && [property[2] isEqualToString:@"<"] && [property[4] isEqualToString:@">"]) {
            key = [property objectAtIndex:0];
            NSString *objKey = [property objectAtIndex:3];
            value = [objects objectForKey:objKey];
        } else if (property.count == 3) {
            key = [property objectAtIndex:0];
            value = [property objectAtIndex:2];
        }
        if (!key || !value) {
            continue;
        }
        if ([key isEqualToString:@"intrinsic"]) {
            builder.intrinsicEqualTo([value boolValue]);
        } else if ([key isEqualToString:@"padding"]) {
            builder.paddingEqualTo([value floatValue]);
        } else if ([key isEqualToString:@"width"]) {
            builder.widthEqualTo([value floatValue]);
        } else if ([key isEqualToString:@"height"]) {
            builder.heightEqualTo([value floatValue]);
        } else if ([key isEqualToString:@"minWidth"]) {
            builder.minWidthEqualTo([value floatValue]);
        } else if ([key isEqualToString:@"maxWidth"]) {
            builder.maxWidthEqualTo([value floatValue]);
        } else if ([key isEqualToString:@"backgroundColor"]) {
            if ([value isKindOfClass:[UIColor class]]) {
                builder.backgroundColorIs((UIColor *)value);
            } else {
                builder.backgroundColorHexIs(value);
            }
        } else if ([key isEqualToString:@"borderColor"]) {
            if ([value isKindOfClass:[UIColor class]]) {
                builder.borderColorIs((UIColor *)value);
            } else {
                builder.borderColorHexIs(value);
            }
        } else if ([key isEqualToString:@"shadowColor"]) {
            if ([value isKindOfClass:[UIColor class]]) {
                builder.shadowColorIs((UIColor *)value);
            } else {
                builder.shadowColorHexIs(value);
            }
        } else if ([key isEqualToString:@"borderWidth"]) {
            builder.borderWidthEqualTo([value floatValue]);
        } else if ([key isEqualToString:@"cornerRadius"]) {
            builder.cornerRadiusEqualTo([value floatValue]);
        } else if ([key isEqualToString:@"font"]) {
            if ([value isKindOfClass:[UIFont class]]) {
                builder.fontIs((UIFont *)value);
            } else {
                builder.fontSizeEqualTo([value floatValue]);
            }
        } else if ([key isEqualToString:@"text"]) {
            builder.textIs(value);
        } else if ([key isEqualToString:@"color"]) {
            if ([value isKindOfClass:[UIColor class]]) {
                builder.colorIs((UIColor *)value);
            } else {
                builder.colorHexIs(value);
            }
        } else if ([key isEqualToString:@"line"]) {
            builder.numberOfLinesEqualTo([value integerValue]);
        } else if ([key isEqualToString:@"image"]) {
            if ([value isKindOfClass:[UIImage class]]) {
                builder.imageIs((UIImage *)value);
            } else {
                builder.imageNameIs(value);
            }
        } else if ([key isEqualToString:@"imageUrl"]) {
            builder.imageUrlIs(value);
        } else if ([key isEqualToString:@"placeholderImage"]) {
            if ([value isKindOfClass:[UIImage class]]) {
                builder.placeholderImageIs((UIImage *)value);
            } else {
                builder.placeholderImageNameIs(value);
            }
        } else if ([key isEqualToString:@"button"]) {
            if ([value isKindOfClass:[UIButton class]]) {
                builder.buttonIs((UIButton *)value);
            }
        }
    }
}


+ (NSArray *)propertiesWithArray:(NSArray<NSString *> *)array seperator:(NSString *)seperator {
    NSString *lastEle = [array lastObject];
    NSMutableArray *copyArray = [array mutableCopy];
    if (![lastEle isEqualToString:seperator]) {
        [copyArray addObject:seperator];
    }
    NSMutableArray *properties = @[].mutableCopy;
    NSInteger startIndex = 0;
    NSInteger i = 0;
    while (i < copyArray.count && startIndex < copyArray.count) {
        NSString *element = copyArray[i];
        if (i > 0 && [element isEqualToString:seperator]) {
            NSInteger length = i - startIndex;
            [properties addObject:[copyArray subarrayWithRange:NSMakeRange(startIndex, length)]];
            startIndex = i + 1;
        }
        i ++;
    }
    return properties;
}

+ (NSArray *)findMatchedWithArray:(NSArray *)array
                       startIndex:(NSInteger)startIndex
                        leftToken:(NSString *)leftToken
                       rightToken:(NSString *)rightToken {
    return [self findMatchedWithArray:array
                           startIndex:startIndex
                            leftToken:leftToken
                           rightToken:rightToken
                         includeToken:NO];
}

+ (NSArray *)findMatchedWithArray:(NSArray *)array
                       startIndex:(NSInteger)startIndex
                        leftToken:(NSString *)leftToken
                       rightToken:(NSString *)rightToken
                     includeToken:(BOOL)isInclude {
    NSInteger index = startIndex + 1;
    NSInteger len = 0;
    for (NSInteger i = startIndex + 1; i < array.count && index < array.count; i ++) {
        NSString *ele = [array objectAtIndex:i];
        if ([ele isEqualToString:leftToken]) {
            index = i + 1;
        } else if ([ele isEqualToString:rightToken]) {
            len = i - index;
            break;
        }
    }
    NSArray *pairs = nil;
    if (isInclude) {
        pairs = [array subarrayWithRange:NSMakeRange(index - 1, len + 2)];
    } else {
        pairs = [array subarrayWithRange:NSMakeRange(index, len)];
    }
    return pairs;
}


@end
