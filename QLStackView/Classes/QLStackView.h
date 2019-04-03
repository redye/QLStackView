//
//  QLStackView.h
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLStackBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLStackView : UIView

+ (QLStackView *)createView:(void(^)(QLStackBuilder *))stackBuilder;

/**
 根据格式化字符串创建视图

 @param formatString 格式化字符串
 @param objects 对象字典
 @param completionHandler 完成回调
 */
+ (void)createViewWithFormatString:(NSString *)formatString
                           objects:(NSDictionary * __nullable)objects
                 completionHandler:(ParsingFormatStringCompletionHandler)completionHandler;

/**
 异步解析格式化字符串

 @param formatString 字符串
 @param objects 对象
 @param completionHandler 完成回调
 */
+ (void)asyncParseFormatString:(NSString *)formatString
                       objects:(NSDictionary * __nullable)objects
             completionHandler:(ParsingFormatStringCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
