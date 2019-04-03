//
//  QLPartView.h
//  QLStackView
//
//  Created by redye.hu on 2019/3/27.
//  Copyright © 2019 redye.hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLPartBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface QLPartView : NSObject

@property (nonatomic, strong) QLPartBuilder *builder;

+ (QLPartView *)createView:(void(^)(QLPartBuilder *))partBuilder;


@end

NS_ASSUME_NONNULL_END
